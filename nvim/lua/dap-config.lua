local dap = require("dap")
local dapui = require("dapui")
local projects = require("dap-projects")

-- TODO: actually configure this
dapui.setup({
	layouts = {
		{
			elements = {
				{
					id = "scopes",
					size = 0.5,
				},
				{
					id = "repl",
					size = 0.5,
				},
			},
			position = "bottom",
			size = 20,
		},
		{
			elements = {
				{
					id = "breakpoints",
					size = 0.2,
				},
				{
					id = "stacks",
					size = 0.4,
				},
				{
					id = "watches",
					size = 0.4,
				},
			},
			position = "left",
			size = 60,
		},
	},
	render = {
		indent = 1,
		max_type_length = 25,
		max_value_lines = nil,
	},
	wrap = true,
})

-- project setup
local function get_project()
	local root = vim.fs.root(0, { ".git" })
	if not root then
		return nil
	end

	for _, project in pairs(projects) do
		if root == project.root then
			return project
		end
	end

	return nil
end

-- adapter setup
local gdb_base = {
	type = "executable",
	command = "gdb",
	args = {
		"--interpreter=dap",
		"--eval-command",
		"set print pretty on",
	},
}

local configure_adapter = function(project)
	local adapter = vim.deepcopy(gdb_base)

	if project.debugger then
		adapter.command = project.debugger
	end

	local debug_args = project.debug_args or {}

	-- debug_args may be a table, or a function returning one when the args
	-- need to be resolved at launch time (e.g. the ASAN runtime path)
	if type(debug_args) == "function" then
		debug_args = debug_args()
	end
	vim.list_extend(adapter.args, debug_args)
	dap.adapters.gdb = adapter
end

-- dap setup
local setup_dap = function()
	local project = get_project()

	if not project then
		return
	end

	configure_adapter(project)

	dap.configurations.cpp = project.configurations
	dap.configurations.c = project.configurations
	dap.configurations.rust = project.configurations
end

-- keymaps
vim.keymap.set("n", "<F1>", function()
	dap.step_into()
end, { desc = "Debug: Step into" })
vim.keymap.set("n", "<F2>", function()
	dap.step_over()
end, { desc = "Debug: Step over" })
vim.keymap.set("n", "<F3>", function()
	dap.step_out()
end, { desc = "Debug: Step out" })

vim.keymap.set("n", "<F5>", function()
	if dap.session() == nil then
		setup_dap()
	end

	dap.continue()
end, { desc = "Debug: start/continue" })

vim.keymap.set("n", "<F7>", function()
	dapui.toggle()
end, { desc = "Debug: toggle UI" })

vim.keymap.set("n", "<leader>b", function()
	dap.toggle_breakpoint()
end, { desc = "Debug: Toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set conditional [B]reakpoint" })

local add_watch = function(expr)
	if not require("dap").session() then
		vim.notify("No active debug session", vim.log.levels.WARN)
		return
	end

	if expr == nil or expr == "" then
		return
	end

	require("dapui").elements.watches.add(expr)
	require("dapui").open()
end

-- climb from the cursor to the outermost expression node, so member access
-- chains ('foo->bar->baz'), subscripts ('a[i]') and '(*ptr).field' are captured
-- whole. Binary/unary/assignment nodes are deliberately excluded, so pointing
-- at 'bar' in 'foo->bar + x' gives 'foo->bar', not the whole sum.
local EXPRESSION_NODE_TYPES = {
	identifier = true,
	field_identifier = true,
	this = true,
	pointer_expression = true,
	field_expression = true,
	subscript_expression = true,
	parenthesized_expression = true,
	qualified_identifier = true,
	template_function = true,
	template_method = true,
}

local expression_under_cursor = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr)

	if not ok or not parser then
		return vim.fn.expand("<cword>")
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	local okp, trees = pcall(parser.parse, parser)
	local root = okp and trees and trees[1] and trees[1]:root()
	local node = root and root:named_descendant_for_range(row, col, row, col)

	if not node then
		return vim.fn.expand("<cword>")
	end

	while node:parent() and EXPRESSION_NODE_TYPES[node:parent():type()] do
		node = node:parent()
	end

	if not EXPRESSION_NODE_TYPES[node:type()] then
		return vim.fn.expand("<cword>")
	end

	return (vim.treesitter.get_node_text(node, bufnr):gsub("%s+", " "))
end

vim.keymap.set("n", "<leader>w", function()
	add_watch(expression_under_cursor())
end, { desc = "Debug: [w]atch expression under cursor" })

-- visual mode: watch an arbitrary expression (obj->field, &thing, ...)
vim.keymap.set("v", "<leader>w", function()
	add_watch(table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() }), " "))
end, { desc = "Debug: [w]atch selection" })

-- breakpoint icons
local error_color = vim.api.nvim_get_hl(0, { name = "ErrorMsg" })
local warning_color = vim.api.nvim_get_hl(0, { name = "WarningMsg" })

vim.api.nvim_set_hl(0, "DapBreak", { fg = error_color.fg })
vim.api.nvim_set_hl(0, "DapStop", { fg = warning_color.fg })

local breakpoint_icons = vim.g.have_nerd_font
		and {
			Breakpoint = "●",
			BreakpointCondition = "⊜",
			BreakpointRejected = "⊘",
			LogPoint = "◆",
			Stopped = "",
		}
	or {
		Breakpoint = "B",
		BreakpointCondition = "C",
		BreakpointRejected = "R",
		LogPoint = "L",
		Stopped = "S",
	}
for type, icon in pairs(breakpoint_icons) do
	local tp = "Dap" .. type
	local hl = (type == "Stopped") and "DapStop" or "DapBreak"
	vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

-- listeners
dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
