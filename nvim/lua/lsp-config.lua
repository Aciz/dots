-- keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format local buffer" })

vim.lsp.inlay_hint.enable(true)

-- diagnostic
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	virtual_text = {
		source = "if_many",
		spacing = 2,
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},
})

-- autocompletions, straight from nvim docs
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(ev)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
		end

		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		-- if client:supports_method('textDocument/implementation') then
		-- Create a keymap for vim.lsp.buf.implementation ...
		-- end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		-- if not client:supports_method('textDocument/willSaveWaitUntil')
		-- 		and client:supports_method('textDocument/formatting') then
		-- 	vim.api.nvim_create_autocmd('BufWritePre', {
		-- 		group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
		-- 		buffer = ev.buf,
		-- 		callback = function()
		-- 			vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
		-- 		end,
		-- 	})
		-- end

		if client and client:supports_method("textDocument/inlayHint", ev.buf) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
			end, "[T]oggle Inlay [H]ints")
		end


		-- enable code action on current line, regardless of the cursor position
		map("gra",
			function()
				local curr_row = vim.api.nvim_win_get_cursor(0)[1]
				vim.lsp.buf.code_action { ["range"] = { ["start"] = { curr_row, 0 }, ["end"] = { curr_row, 200 } } }
			end,
			"[G]oto Code [A]ction", { "n", "x" })
	end,
})

-- lsp servers
local servers = {
	------------------------------------------------------------------------------
	-- lua_ls
	------------------------------------------------------------------------------
	lua_ls = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
						path ~= vim.fn.stdpath('config')
						and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using (most
					-- likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
					-- Tell the language server how to find Lua modules same way as Neovim
					-- (see `:h lua-module-load`)
					path = {
						'lua/?.lua',
						'lua/?/init.lua',
					},
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
						vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
						"/usr/share/hypr/stubs",
					},
					-- Or pull in all of 'runtimepath'.
					-- NOTE: this is a lot slower and will cause issues when working on
					-- your own configuration.
					-- See https://github.com/neovim/nvim-lspconfig/issues/3189
					-- library = vim.api.nvim_get_runtime_file('', true),
				},
			})
		end,
		settings = {
			Lua = {
				diagnostics = {
					globals = {
						"vim",
					},
				},
			},
		},
	},

	------------------------------------------------------------------------------
	-- clangd
	------------------------------------------------------------------------------
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--header-insertion=never",
			"--completion-style=detailed",
			"--function-arg-placeholders=1",
			"--fallback-style=llvm",
			"--all-scopes-completion=true",
			"--clang-tidy",
			"--enable-config",
		},
	},

	-- FIXME: python dependency issue, can't install:
	-- Failed to find a python3 installation in PATH that meets the required versions (<3.14,>=3.8.0). Found version: 3.14.6.
	-- cmake = {},
}


local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	-- You can add other tools here that you want Mason to install
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end
