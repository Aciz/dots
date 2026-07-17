-- add plugin
-- NOTE: this installs the plugin temporarily
vim.api.nvim_create_user_command("PackAdd", function(opts)
	vim.pack.add(opts.fargs)
end, { nargs = "+", desc = "Add plugins (:PackAdd user/repo1 user/repo2 ..)" })

-- delete plugin
-- NOTE: this deletes the plugin temporarily
vim.api.nvim_create_user_command("PackDel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2 ..)" })

-- update plugins
-- if no arguments are given, updates all plugins
vim.api.nvim_create_user_command("PackUpdate", function(opts)
	-- check for args
	if opts.args:match("%S") then
		-- update specific plugins
		local plugins = vim.split(opts.args, "%s+", { trimempty = true })
		vim.pack.update(plugins)
	else
		-- update all
		vim.pack.update()
	end
end, { nargs = "*", desc = "Update all plugins or specific ones" })
