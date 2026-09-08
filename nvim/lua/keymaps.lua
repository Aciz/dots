-- space as leader key
vim.g.mapleader = " "

-- switch focus
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- delete text without saving it to register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- CTRL + c to exit normal mode and clear text highlight from search
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "<C-c>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })
vim.keymap.set("n", "<Esc>", ":nohl<CR>", { desc = "Clear search highlighting", silent = true })

-- move lines up and down in visual selection
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up in visual selection" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" })

-- better indentation
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })

-- join lines without shifting cursor position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- keep cursor centered while scrolling
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer, keep cursor centered" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer, keep cursor centered" })

-- same as above, but for search
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, keep cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, keep cursor centered" })

-- buffer-specific find/replace
vim.keymap.set("n", "<leader>Fr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under the cursor in the current buffer" })

-- quickfix list
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- chmod +x for the current file
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable", silent = true })

-- restart neovim
vim.keymap.set("n", "<leader>re", "<cmd>restart<CR>", { desc = "Restart Neovim" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle built-in undotree" })
