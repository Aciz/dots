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
					size = 0.5
				},
				{
					id = "repl",
					size = 0.5
				},
			},
			position = "bottom",
			size = 25
		},
		{
			elements = {
				{
					id = "breakpoints",
					size = 0.2
				},
				{
					id = "stacks",
					size = 0.5
				},
				{
					id = "watches",
					size = 0.3
				},
			},
			position = "left",
			size = 60
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
	if not root then return nil end

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
		"--eval-command", "set print pretty on",
	},
}

local configure_adapter = function(project)
	local adapter = vim.deepcopy(gdb_base)
	vim.list_extend(adapter.args, project.debug_args or {})
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
end

-- keymaps
vim.keymap.set("n", "<F1>", function() dap.step_into() end, { desc = "Debug: Step into" })
vim.keymap.set("n", "<F2>", function() dap.step_over() end, { desc = "Debug: Step over" })
vim.keymap.set("n", "<F3>", function() dap.step_out() end, { desc = "Debug: Step out" })

vim.keymap.set("n", "<F5>", function()
	if dap.session() == nil then
		setup_dap()
	end

	dap.continue()
end, { desc = "Debug: start/continue" })

vim.keymap.set("n", "<F7>", function() dapui.toggle() end, { desc = "Debug: toggle UI" })

vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle [b]reakpoint" })
vim.keymap.set("n", "<leader>B", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set conditional [B]reakpoint" })

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
