local gitsigns = require("gitsigns")
gitsigns.setup({
	on_attach = function(bufnr)
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "Jump to next git [c]hange" })

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "Jump to previous git [c]hange" })

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })

		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git [s]tage hunk" })

		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git [r]eset hunk" })

		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
		map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "git preview hunk [i]nline" })

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "git [b]lame line" })

		-- open the whole file as it was at the commit that last touched this line
		map("n", "<leader>hV", function()
			local file = vim.api.nvim_buf_get_name(0)

			if file == "" then
				return
			end

			local dir = vim.fn.fnamemodify(file, ":h")
			local base = vim.fn.fnamemodify(file, ":t")
			local line = vim.api.nvim_win_get_cursor(0)[1]

			local out =
				vim.fn.systemlist({ "git", "-C", dir, "blame", "-L", line .. "," .. line, "--porcelain", "--", base })
			local sha = out[1] and out[1]:match("^(%x+)")

			-- no commit yet (0..0), git error, or file not in a repo
			if not sha or sha:match("^0+$") then
				vim.notify("git: no commit found for this line", vim.log.levels.WARN)
				return
			end

			gitsigns.show(sha)
		end, { desc = "git open [V]ersion of file at this line's commit" })

		-- TODO: doc
		map("n", "<leader>hd", gitsigns.diffthis)

		-- TODO: doc
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end)

		map("n", "<leader>hQ", function()
			gitsigns.setqflist("all")
		end, { desc = "git show all changes in [Q]uickfix" })
		map("n", "<leader>hq", gitsigns.setqflist, { desc = "git show changes in [q]uickfix" })

		-- Toggles
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
		-- TODO: doc
		map("n", "<leader>tw", gitsigns.toggle_word_diff)

		-- Text object
		-- TODO: doc
		map({ "o", "x" }, "ih", gitsigns.select_hunk)
	end,
})
