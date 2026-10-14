-- rustaceanvim owns the rust experience: it configures the builtin
-- 'rust_analyzer' LSP client itself (see the commented out entry in
-- 'lsp-config.lua') and auto-detects 'codelldb' for debugging.
--
-- NOTE: vim.g.rustaceanvim must be set before the plugin initializes, i.e.
-- before the first rust buffer is opened. This file is required from 'pack.lua'
-- during startup, which is early enough for both interactive use and files
-- passed on the command line.
vim.g.rustaceanvim = {
	server = {
		default_settings = {
			["rust-analyzer"] = {
				check = {
					command = "clippy",
				},
			},
		},
	},
}
