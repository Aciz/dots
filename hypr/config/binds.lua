local mainMod = "SUPER"

hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("vesktop --ozone-platform=wayland --use-gl=egl"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("elecwhat"))
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("steam"))

hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("ALT + V", hl.dsp.exec_cmd("kitty --class clipse -e clipse"))

hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd("swappyfile=$(hyprshot -m region -z -- echo); swappy -f $swappyfile -o $swappyfile")
)

hl.bind(
	"SHIFT + Print",
	hl.dsp.exec_cmd("swappyfile=$(hyprshot -m window -z -- echo); swappy -f $swappyfile -o $swappyfile")
)
