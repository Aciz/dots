local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		mappings = {
			n = {
				["dd"] = actions.delete_buffer,
			}
		}
	},

	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},

	pickers = {
		buffers = {
			sort_mru = true,
			ignore_current_buffer = true,
		},
	},
})

-- enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

-- keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sF", builtin.git_files, { desc = "[S]earch Git [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- This runs on LSP attach per buffer (see main LSP attach function in 'neovim/nvim-lspconfig' config for more info,
-- it is better explained there). This allows easily switching between pickers if you prefer using something else!
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
	callback = function(event)
		local buf = event.buf

		-- Find references for the word under your cursor.
		vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

		-- Jump to the implementation of the word under your cursor.
		-- Useful when your language has ways of declaring types without an actual implementation.
		vim.keymap.set(
			"n",
			"gri",
			builtin.lsp_implementations,
			{ buffer = buf, desc = "[G]oto [I]mplementation" }
		)

		-- Jump to the definition of the word under your cursor.
		-- This is where a variable was first declared, or where a function is defined, etc.
		-- To jump back, press <C-t>.
		vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })

		-- Fuzzy find all the symbols in your current document.
		-- Symbols are things like variables, functions, types, etc.
		vim.keymap.set(
			"n",
			"gO",
			builtin.lsp_document_symbols,
			{ buffer = buf, desc = "Open Document Symbols" }
		)

		-- Fuzzy find all the symbols in your current workspace.
		-- Similar to document symbols, except searches over your entire project.
		vim.keymap.set(
			"n",
			"gW",
			builtin.lsp_dynamic_workspace_symbols,
			{ buffer = buf, desc = "Open Workspace Symbols" }
		)

		-- Jump to the type of the word under your cursor.
		-- Useful when you're not sure what type a variable is and you want to see
		-- the definition of its *type*, not where it was *defined*.
		vim.keymap.set(
			"n",
			"grt",
			builtin.lsp_type_definitions,
			{ buffer = buf, desc = "[G]oto [T]ype Definition" }
		)
	end,
})
