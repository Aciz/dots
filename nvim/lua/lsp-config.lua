-- keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })

vim.lsp.inlay_hint.enable(true)

-- diagnostic
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.WARN },
	signs = vim.g.have_nerd_font and {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	} or {},
	-- virtual_text = {
	-- 	source = "if_many",
	-- 	spacing = 2,
	-- 	format = function(diagnostic)
	-- 		local diagnostic_message = {
	-- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
	-- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
	-- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
	-- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
	-- 		}
	-- 		return diagnostic_message[diagnostic.severity]
	-- 	end,
	-- },
})

-- lsp keymaps and diagnostics (completion lives in 'blink-cmp-config.lua')
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(ev)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
		end

		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
		-- if client:supports_method('textDocument/implementation') then
		-- Create a keymap for vim.lsp.buf.implementation ...
		-- end

		-- completion is provided by blink.cmp, see 'blink-cmp-config.lua'

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
		map("gra", function()
			local curr_row = vim.api.nvim_win_get_cursor(0)[1]
			vim.lsp.buf.code_action({ ["range"] = { ["start"] = { curr_row, 0 }, ["end"] = { curr_row, 200 } } })
		end, "[G]oto Code [A]ction", { "n", "x" })
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
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using (most
					-- likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Tell the language server how to find Lua modules same way as Neovim
					-- (see `:h lua-module-load`)
					path = {
						"lua/?.lua",
						"lua/?/init.lua",
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

	------------------------------------------------------------------------------
	-- cmake
	------------------------------------------------------------------------------
	-- FIXME: python dependency issue, can't install:
	-- Failed to find a python3 installation in PATH that meets the required versions (<3.14,>=3.8.0). Found version: 3.14.6.
	-- cmake = {},

	------------------------------------------------------------------------------
	-- bash
	------------------------------------------------------------------------------
	bashls = {
		cmd = { "bash-language-server", "start" },
		settings = {
			bashIde = {
				-- Glob pattern for finding and parsing shell script files in the workspace.
				-- Used by the background analysis features across files.

				-- Prevent recursive scanning which will cause issues when opening a file
				-- directly in the home directory (e.g. ~/foo.sh).
				--
				-- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
				globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			},
		},
		filetypes = { "bash", "sh" },
		root_markers = { ".git" },
	},
	-- TODO: figure this out
	-- shellcheck = {
	-- 	cmd = { "shellcheck" },
	-- },

	------------------------------------------------------------------------------
	-- typescript
	------------------------------------------------------------------------------
	vtsls = {},
	eslint = {},

	------------------------------------------------------------------------------
	-- json
	------------------------------------------------------------------------------
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},

	------------------------------------------------------------------------------
	-- toml
	------------------------------------------------------------------------------
	taplo = {},

	------------------------------------------------------------------------------
	-- markdown
	------------------------------------------------------------------------------
	marksman = {},

	------------------------------------------------------------------------------
	-- python
	------------------------------------------------------------------------------
	pyright = {},
	ruff = {},

	------------------------------------------------------------------------------
	-- rust
	------------------------------------------------------------------------------
	-- NOTE: the rust-analyzer client is owned by rustaceanvim, see
	-- 'rustaceanvim-config.lua'. Configuring it here as well would register a
	-- second client and conflict with rustaceanvim's setup.
	-- rust_analyzer = {
	-- 	settings = {
	-- 		["rust-analyzer"] = {
	-- 			check = {
	-- 				command = "clippy",
	-- 			},
	-- 		},
	-- 	},
	-- },
}

local ensure_installed = vim.tbl_keys(servers)

require("mason-lspconfig").setup({
	ensure_installed = ensure_installed,
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"prettierd",
		"shfmt",
	},
})

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
end
