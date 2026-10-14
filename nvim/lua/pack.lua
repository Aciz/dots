local gh_repo = function(x)
	return "https://github.com/" .. x
end

vim.pack.add({
	-- themes
	gh_repo("AlexvZyl/nordic.nvim"),
	gh_repo("rebelot/kanagawa.nvim"),
	{
		src = gh_repo("catppuccin/nvim"),
		name = "catppuccin",
	},
	gh_repo("folke/tokyonight.nvim"),

	-- lualine
	gh_repo("nvim-lualine/lualine.nvim"),

	-- telescope
	gh_repo("nvim-telescope/telescope.nvim"),
	-- telescope dependencies
	gh_repo("nvim-lua/plenary.nvim"),
	gh_repo("nvim-telescope/telescope-fzf-native.nvim"),
	gh_repo("nvim-telescope/telescope-ui-select.nvim"),
	gh_repo("nvim-tree/nvim-web-devicons"),

	-- mini
	gh_repo("nvim-mini/mini.nvim"),

	-- treesitter
	{
		src = gh_repo("nvim-treesitter/nvim-treesitter"),
		branch = "main",
	},
	gh_repo("nvim-treesitter/nvim-treesitter-context"),

	-- rust
	gh_repo("Saecki/crates.nvim"),
	{
		src = gh_repo("mrcjkb/rustaceanvim"),
		-- stay on the current major, per the plugin's install instructions
		version = vim.version.range("^9"),
	},

	-- lsp
	gh_repo("neovim/nvim-lspconfig"),
	gh_repo("mason-org/mason.nvim"),
	gh_repo("WhoIsSethDaniel/mason-tool-installer.nvim"),
	gh_repo("mason-org/mason-lspconfig.nvim"),
	gh_repo("b0o/SchemaStore.nvim"), -- for JSON schema support via jsonls

	-- completion
	{
		src = gh_repo("saghen/blink.cmp"),
		-- released tags ship a prebuilt fuzzy-matcher binary
		version = vim.version.range("1.*"),
	},

	-- dap
	gh_repo("mfussenegger/nvim-dap"),
	gh_repo("jay-babu/mason-nvim-dap.nvim"), -- soft-dependency of nvim-dap
	gh_repo("rcarriga/nvim-dap-ui"),
	gh_repo("nvim-neotest/nvim-nio"), -- nvim-dap-ui dependency
	gh_repo("theHamsta/nvim-dap-virtual-text"),

	-- conform
	gh_repo("stevearc/conform.nvim"),

	-- inline diagnostics
	gh_repo("rachartier/tiny-inline-diagnostic.nvim"),

	-- neogit
	gh_repo("NeogitOrg/neogit"),
	gh_repo("sindrets/diffview.nvim"), -- neogit dependency

	-- gitsigns
	gh_repo("lewis6991/gitsigns.nvim"),

	-- opencode
	gh_repo("nickjvandyke/opencode.nvim"),

	-- misc
	gh_repo("folke/todo-comments.nvim"),
	gh_repo("folke/which-key.nvim"),
	gh_repo("iamcco/markdown-preview.nvim"),
	gh_repo("catgoose/nvim-colorizer.lua"),
	gh_repo("Shatur/neovim-ayu"),
})

--------------------------------------------------------------------------------
-- themes
--------------------------------------------------------------------------------
require("themes.nordic-config")
require("themes.kanagawa-config")
require("themes.catppuccin-config")
require("themes.tokyonight-config")
require("themes.ayu-config")

-- set colorscheme
vim.cmd("colorscheme kanagawa")

--------------------------------------------------------------------------------
-- lualine
--------------------------------------------------------------------------------
require("lualine-config")

--------------------------------------------------------------------------------
-- telescope
--------------------------------------------------------------------------------
require("telescope-config")

--------------------------------------------------------------------------------
-- mini.files
--------------------------------------------------------------------------------
local MiniFiles = require("mini.files")
MiniFiles.setup({})

-- keymaps
vim.keymap.set("n", "-", function()
	MiniFiles.open()
end, { desc = "Toggle Mini File explorer" })
vim.keymap.set("n", "<leader>-", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Toggle Mini Files in current working directory" })

--------------------------------------------------------------------------------
-- mini.notify
--------------------------------------------------------------------------------
require("mini.notify").setup({
	-- only show messages
	content = {
		format = function(notif)
			return notif.msg
		end,
	},

	window = {
		winblend = 25,
	},
})

--------------------------------------------------------------------------------
-- mini.completions
--------------------------------------------------------------------------------
--[[
local MiniCompletion = require("mini.completion")
MiniCompletion.setup({
	delay = {
		completion = 0,
		info = 0,
		signature = 0,
	},

	window = {
		info = {
			border = "rounded"
		},
		signature = {
			border = "rounded"
		},
	},

	lsp_completion = {
		auto_setup = true,
	}
})
]]
--

--------------------------------------------------------------------------------
-- mini.ai
--------------------------------------------------------------------------------
require("mini.ai").setup({
	n_lines = 500,
})

--------------------------------------------------------------------------------
-- mini.parirs
--------------------------------------------------------------------------------
require("mini.pairs").setup({})

--------------------------------------------------------------------------------
-- mini.surround
--------------------------------------------------------------------------------
require("mini.surround").setup({})

--------------------------------------------------------------------------------
-- treesitter
--------------------------------------------------------------------------------
require("treesitter-config")

--------------------------------------------------------------------------------
-- treesitter-context
--------------------------------------------------------------------------------
require("treesitter-context").setup({
	max_lines = 10,
})

--------------------------------------------------------------------------------
-- rustaceanvim
--------------------------------------------------------------------------------
require("rustaceanvim-config")

--------------------------------------------------------------------------------
-- lsp
--------------------------------------------------------------------------------
require("mason").setup()
require("lsp-config")

--------------------------------------------------------------------------------
-- completion
--------------------------------------------------------------------------------
require("blink-cmp-config")

--------------------------------------------------------------------------------
-- dap
--------------------------------------------------------------------------------
require("dap-config")

-- NOTE: this must be after 'mason.setup()'!
require("mason-nvim-dap").setup({
	automatic_installation = true,
	ensure_installed = {
		"codelldb",
	},
	-- NOTE: passing an empty 'handlers' table enables the default setup, which
	-- registers adapters and configurations for installed sources (codelldb
	-- here); without it, mason-nvim-dap only installs packages
	handlers = {},
})

require("nvim-dap-virtual-text").setup({
	all_references = true,
})

--------------------------------------------------------------------------------
-- conform
--------------------------------------------------------------------------------
require("conform-config")

--------------------------------------------------------------------------------
-- tiny-inline-diagnostic
--------------------------------------------------------------------------------
require("tiny-inline-diagnostic").setup({
	preset = "simple",
})

--------------------------------------------------------------------------------
-- neogit
--------------------------------------------------------------------------------
local Neogit = require("neogit")
Neogit.setup({
	graph_style = "unicode",
	process_spinner = true,
})

-- keymaps
vim.keymap.set("n", "<leader>gs", function()
	Neogit.open()
end, { desc = "Neo[G]it [s]tatus" })
vim.keymap.set("n", "<leader>gp", function()
	Neogit.open({ "pull" })
end, { desc = "Neo[G]it [p]ull" })
vim.keymap.set("n", "<leader>gP", function()
	Neogit.open({ "push" })
end, { desc = "Neo[G]it [P]ush" })
vim.keymap.set("n", "<leader>gc", function()
	Neogit.open({ "commit" })
end, { desc = "Neo[G]it [c]ommit" })
vim.keymap.set("n", "<leader>gb", function()
	Neogit.open({ "branch" })
end, { desc = "Neo[G]it [b]ranch" })
vim.keymap.set("n", "<leader>gr", function()
	Neogit.open({ "rebase" })
end, { desc = "Neo[G]it [r]ebase" })

require("diffview").setup({
	keymaps = {
		view = {
			{ "n", "q", ":DiffviewClose<CR>", { desc = "Close diffview" } },
		},
		file_panel = {
			{ "n", "q", ":DiffviewClose<CR>", { desc = "Close diffview" } },
		},
	},
})

--------------------------------------------------------------------------------
-- gitsigns
--------------------------------------------------------------------------------
require("gitsigns-config")

--------------------------------------------------------------------------------
-- todo-comments
--------------------------------------------------------------------------------
require("todo-comments").setup({
	sings = false,
})

--------------------------------------------------------------------------------
-- which-key
--------------------------------------------------------------------------------
require("which-key-config")

--------------------------------------------------------------------------------
-- markdown-preview
-- NOTE: this is a vimscript plugin
--------------------------------------------------------------------------------
vim.g.mkdp_filetypes = { "markdown" }
vim.g.mkdp_auto_close = 0
vim.g.mkdp_combine_preview = 1

--------------------------------------------------------------------------------
-- opencode
--------------------------------------------------------------------------------

vim.keymap.set({ "n", "x" }, "<leader>oa", function()
	require("opencode").ask("@this: ")
end, { desc = "[o]penCode: [a]sk" })

vim.keymap.set({ "n", "x" }, "<leader>os", function()
	require("opencode").select()
end, { desc = "[o]penCode: [s]elect..." })

vim.keymap.set({ "n", "x" }, "<leader>or", function()
	return require("opencode").operator("@this ")
end, { desc = "[o]penCode: [r]ange [a]ppend", expr = true })

vim.keymap.set({ "n" }, "<leader>ol", function()
	return require("opencode").operator("@this ") .. "_"
end, { desc = "[o]penCode: [l]ine [a]ppend", expr = true })

--------------------------------------------------------------------------------
-- colorizer
--------------------------------------------------------------------------------
require("colorizer").setup({
	options = {
		parsers = {
			oklch = {
				enable = true,
			},
			tailwind = {
				enable = true,
			},
		},
	},
})
