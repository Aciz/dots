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
}

local projects = {
	etjump = {
		root = vim.fn.expand("~/dev/github/etjump"),
		debug_args = {
			"--eval-command",
			"set environment LD_PRELOAD=/usr/lib/clang/22/lib/linux/libclang_rt.asan-x86_64.so",
			"--eval-command",
			"set environment SDL_VIDEODRIVER=wayland",
		},
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
}

return projects
