local conform = require("conform")
conform.setup({
	-- keymaps
	vim.keymap.set("n", "<leader>f", function()
		conform.format({ async = true, lsp_format = "fallback" })
	end, { desc = "[F]ormat buffer" }),

	notify_on_error = true,
	formatters_by_ft = {
		lua = { "stylua" },

		css = { "prettierd" },
		javascript = { "prettierd" },
		javascriptreact = { "prettierd" },
		typescript = { "prettierd" },
		typescriptreact = { "prettierd" },

		sh = { "shfmt" },

		json = { "prettierd" },
		jsonc = { "prettierd" },

		yaml = { "prettierd" },
		toml = { "taplo" },

		cmake = { "cmakelang" },

		rust = { "rustfmt" },

		-- Conform can also run multiple formatters sequentially
		-- python = { "isort", "black" },
		--
		-- You can use 'stop_after_first' to run the first available formatter from the list
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})
