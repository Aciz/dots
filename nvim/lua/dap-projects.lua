-- resolve the ASAN runtime path for the currently installed clang, so clang
-- version bumps don't break asan runs. 'clang --print-file-name' echoes the
-- name back unchanged when it can't find the file, so check that too.
local function resolve_clang_asan_lib()
	local name = "libclang_rt.asan-x86_64.so"
	local out = vim.trim(vim.fn.system({ "clang", "--print-file-name=" .. name }))
	if vim.v.shell_error ~= 0 or out == "" or out == name then
		return nil
	end

	return out
end

-- dynamically linked ETJump libs are built with ASAN while the engine is not,
-- so LD_PRELOAD must point at the correct clang runtime or the process won't
-- launch at all
local function etjump_debug_args()
	local args = {
		"--eval-command",
		"set breakpoint pending on",
		"--eval-command",
		"set sysroot /",
		"--eval-command",
		"set environment SDL_VIDEODRIVER=wayland",
	}

	local asan = resolve_clang_asan_lib()

	if asan then
		table.insert(args, 1, "--eval-command")
		table.insert(args, 2, "set environment LD_PRELOAD=" .. asan)
	else
		vim.notify("dap: could not resolve libclang_rt.asan-x86_64.so, ASAN will be disabled", vim.log.levels.WARN)
	end

	return args
end

local etjump_launch_table = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/etjump-dev",
	"+set fs_game etjump",
	"+set cm_optimizePatchPlanes 1",
	"+set r_mode 19",
	"+devmap long",
}

local etjump_launch_table_ui = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/etjump-dev",
	"+set fs_game etjump",
	"+set cm_optimizePatchPlanes 1",
	"+set r_mode 19",
}

local etjump_launch_table_etl = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/etjump-dev",
	"+set fs_game etjump",
	"+set cm_optimizePatchPlanes 1",
	"+set r_mode 16",
	"+set com_zonemegs 128",
	"+devmap long",
}

local etl_launch_table = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/etlegacy-dev",
	"+devmap goldrush",
}

local etl_launch_table_ui = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/etlegacy-dev",
	"+devmap",
}

local etl_launch_table_etjump = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/etlegacy-dev",
	"+set fs_game etjump",
	"+devmap",
}

local ete_launch_table_etjump = {
	"+set fs_basepath .",
	"+set fs_homepath /home/aciz/games/ete-dev",
	"+set fs_game etjump",
	"+set r_fullscreen 0",
}

local projects = {
	etjump = {
		root = vim.fn.expand("~/dev/github/etjump"),
		debug_args = etjump_debug_args,
		configurations = {
			{
				name = "ETJump Debug (ETe)",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/games/etjump-dev/ete.x86_64",
				cwd = "/home/aciz/dev/github/etjump/build",
				stopOnEntry = false,
				args = {
					table.concat(etjump_launch_table, " "),
				},
			},
			{
				name = "ETJump Debug UI (ETe)",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/games/etjump-dev/ete.x86_64",
				cwd = "/home/aciz/dev/github/etjump/build",
				stopOnEntry = false,
				args = {
					table.concat(etjump_launch_table_ui, " "),
				},
			},
			{
				name = "ETJump Debug (ETe-ded)",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/games/etjump-dev/ete-ded.x86_64",
				cwd = "/home/aciz/dev/github/etjump/build",
				stopOnEntry = false,
				args = {
					table.concat(etjump_launch_table, " "),
				},
			},
			{
				-- attach to a dedicated server started via 'local-server-gdb.sh'
				-- (gdbserver :55555), which keeps a real tty for the server console
				name = "ETJump Dedicated Server (gdbserver attach)",
				type = "gdb",
				request = "attach",
				target = "localhost:55555",
				program = "/home/aciz/games/etjump-dev/ete-ded.x86_64",
				cwd = "/home/aciz/dev/github/etjump/build",
			},
			{
				name = "ETJump Debug (ETL)",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/games/etlegacy/etl.x86_64",
				cwd = "/home/aciz/dev/github/etjump/build",
				stopOnEntry = false,
				args = {
					table.concat(etjump_launch_table_etl, " "),
				},
			},
		},
	},

	etlegacy = {
		root = vim.fn.expand("~/dev/github/etlegacy"),
		debug_args = {
			"--eval-command",
			"set environment LD_PRELOAD=/usr/lib/libasan.so",
			"--eval-command",
			"set environment SDL_VIDEODRIVER=wayland",
		},
		configurations = {
			{
				name = "ETLegacy Debug x64",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/etlegacy/build/etl.x86_64",
				cwd = "/home/aciz/dev/github/etlegacy/build",
				stopOnEntry = false,
				args = {
					table.concat(etl_launch_table, " "),
				},
			},
			{
				name = "ETLegacy Debug x64 UI",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/etlegacy/build/etl.x86_64",
				cwd = "/home/aciz/dev/github/etlegacy/build",
				stopOnEntry = false,
				args = {
					table.concat(etl_launch_table_ui, " "),
				},
			},
			{
				name = "ETLegacy Debug x86",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/etlegacy/build/etl.i386",
				cwd = "/home/aciz/dev/github/etlegacy/build",
				stopOnEntry = false,
				args = {
					table.concat(etl_launch_table, " "),
				},
			},
			{
				name = "ETLegacy Dedicated Server Debug x64",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/etlegacy/build/etlded.x86_64",
				cwd = "/home/aciz/dev/github/etlegacy/build",
				stopOnEntry = false,
				args = {
					table.concat(etl_launch_table, " "),
				},
			},
			{
				name = "ETLegacy Debug ETJump x64",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/etlegacy/build/etl.x86_64",
				cwd = "/home/aciz/dev/github/etlegacy/build",
				stopOnEntry = false,
				args = {
					table.concat(etl_launch_table_etjump, " "),
				},
			},
		},
	},

	ete = {
		root = vim.fn.expand("~/dev/github/ETe"),
		debug_args = {
			"--eval-command",
			"set environment SDL_VIDEODRIVER=wayland",
		},
		configurations = {
			{
				name = "ETe Debug (ETJump) x64",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/ETe/build/ETe/ETe.x86_64",
				cwd = "/home/aciz/dev/github/ETe/build/ETe",
				stopOnEntry = false,
				args = {
					table.concat(ete_launch_table_etjump, " "),
				},
			},
			{
				name = "ETe Debug (ETJump) x86",
				type = "gdb",
				request = "launch",
				program = "/home/aciz/dev/github/ETe/build/ETe/ETe.x86",
				cwd = "/home/aciz/dev/github/ETe/build/ETe",
				stopOnEntry = false,
				args = {
					table.concat(ete_launch_table_etjump, " "),
				},
			},
		},
	},
	camtrace3d = {
		root = vim.fn.expand("~/dev/github/camtrace3d"),
		debugger = "rust-gdb",
		configurations = {
			{
				name = "Camtrace: Debug",
				type = "gdb",
				request = "launch",
				program = vim.fn.expand("~/dev/github/camtrace3d/target/debug/camtrace3d"),
				cwd = vim.fn.expand("~/dev/github/camtrace3d"),
				stopOnEntry = false,
			},
			{
				name = "Camtrace: Debug (release)",
				type = "gdb",
				request = "launch",
				program = vim.fn.expand("~/dev/github/camtrace3d/target/release/camtrace3d"),
				cwd = vim.fn.expand("~/dev/github/camtrace3d"),
				stopOnEntry = false,
			},
		},
	},
}

return projects
