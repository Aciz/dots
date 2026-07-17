hl.window_rule({
	name = "Workspace 1 clients",
	match = {
		class = "^(brave-browser|firefox)$",
	},

	workspace = "1 silent",
	scrolling_width = 1.0,
})

hl.window_rule({
	name = "Workspace 2 clients",
	match = {
		class = "^(vesktop|elecwhat)$",
	},

	workspace = "2 silent",
})

hl.window_rule({
	name = "Steam",
	match = {
		class = "^(steam)$",
	},

	workspace = "2 silent",
	float = true,
})

hl.window_rule({
	name = "Steam main window",
	match = {
		class = "^(steam)$",
		title = "^(Steam)$",
	},

	float = false,
})

hl.window_rule({
	name = "Floating windows (class)",
	match = {
		class = "^(QtPack3r|hyprland-share-picker|io.github.celluloid_player.Celluloid|io.github.Qalculate.qalculate-qt|melonDS|vlc|xdg-desktop-portal-gtk)$",
	},

	float = true,
})

hl.window_rule({
	name = "Floating windows (title)",
	match = {
		title = "^(Welcome to CLion)$",
	},

	float = true,
})

hl.window_rule({
	name = "Thunar popups",
	match = {
		class = "(?i)^(thunar)$",
		title = "^(File Operation Progress|Rename).*",
	},

	float = true,
})

hl.window_rule({
	name = "Xarchiver",
	match = {
		class = "^(xarchiver)$",
		title = "^(Add files|Create a new archive).*",
	},

	float = true,
})

hl.window_rule({
	name = "Content: game",
	match = {
		class = "^(gamescope|steam_app_|ete|etl|nierautomata).*",
	},

	content = "game",
})

hl.window_rule({
	name = "Content: game (xdgTag)",
	match = {
		xdg_tag = "^(proton-game)$",
	},

	content = "game",
})

hl.window_rule({
	name = "Tearing for games",
	match = {
		content = "game",
	},

	monitor = "DP-1",
	immediate = true,
})

hl.window_rule({
	name = "Clipse",
	match = {
		class = "^(clipse)$",
	},

	float = true,
	size = { "(monitor_w * 0.6)", "(monitor_h * 0.75)" },
})

hl.window_rule({
	name = "Disable VRR for MPV",
	match = {
		class = "^(mpv)$",
	},

	no_vrr = true,
})

hl.window_rule({
	name = "Full width windows",
	match = {
		class = "^(NetRadiant-Custom|com.obsproject.Studio|gimp|jetbrains-clion)$",
	},

	scrolling_width = 1.0,
})

hl.window_rule({
	name = "Show Me The Key overlay",
	match = {
		title = "^(Floating Window - Show Me The Key)$",
	},

	float = true,
	pin = true,
})

hl.window_rule({
	name = "GIMP floating popups",
	match = {
		class = "^(gimp)$",
	},

	float = true,
})

hl.window_rule({
	name = "GIMP main window",
	match = {
		class = "^(gimp)$",
		title = "^(GNU Image Manipulation Program)$",
	},

	float = false,
})
