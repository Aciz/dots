--------------------------------------------------------------------------------
-- appearance
--------------------------------------------------------------------------------

-- enable nerd fonts
vim.g.have_nerd_font = true

-- 24-bit color support
vim.opt.termguicolors = true

-- rounded borders for floating windows
vim.o.winborder = "rounded"

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true
vim.o.cursorline = true

-- reserve space for gitsigns etc.
vim.opt.signcolumn = "yes"

-- hide mode, we have a status bar
vim.o.showmode = false

-- display whitespace characters
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- column marker at 80 chars
vim.opt.colorcolumn = "80"

-- disable netrw banner
vim.g.netrw_banner = 0

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Hightlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})


--------------------------------------------------------------------------------
-- buffers
--------------------------------------------------------------------------------

-- tab options
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.expandtab = true

-- indentation/wrapping
vim.opt.wrap = true
vim.opt.smartindent = true

-- splits to right/bottom
vim.opt.splitright = true
vim.opt.splitbelow = true

-- keep some buffer visible while scrolling
vim.opt.scrolloff = 10

-- preview substitutions live
vim.opt.inccommand = "split"


--------------------------------------------------------------------------------
-- general behavior
--------------------------------------------------------------------------------

-- confirm on failed actions
vim.o.confirm = true

-- case sensitivity options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- spellcheck
-- TODO: this is kinda bad, should try find some decent plugin for it
vim.o.spell = true
vim.o.spelllang = "en_us"

-- swap/backup
vim.opt.swapfile = true
vim.opt.backup = false

-- undo options
vim.opt.undofile = true

-- enable use of system clipboard
-- schedule as this can increase startup time
vim.schedule(function()
	vim.opt.clipboard:append("unnamedplus")
end)

-- allow '@' characters in file names
vim.opt.isfname:append("@-@")

-- autocompletion
vim.o.autocomplete = true
vim.opt.completeopt = "menuone,noselect,fuzzy,nosort"
vim.opt.complete:append("o")
vim.o.pumheight = 15
vim.o.pummaxwidth = 120
vim.o.pumborder = "rounded"

-- disable autocompletion in Telescope buffer
vim.api.nvim_create_autocmd("FileType", {
	desc = "Disables autocompletion in Telescope buffers",
	pattern = "TelescopePrompt",
	callback = function()
		vim.opt_local.autocomplete = false
	end,
})
