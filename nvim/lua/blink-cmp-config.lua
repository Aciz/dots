require("blink.cmp").setup({
	keymap = { preset = "default" },

	appearance = {
		nerd_font_variant = "mono",
	},

	-- only show the documentation popup when manually triggered
	completion = {
		documentation = { auto_show = false },
	},

	sources = {
		default = { "lsp", "path", "buffer" },
	},

	-- Rust fuzzy matcher (prebuilt binary, downloaded for the pinned tag),
	-- falls back to the Lua implementation with a warning if unavailable
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
