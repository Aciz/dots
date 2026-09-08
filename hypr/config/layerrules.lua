hl.layer_rule({
	name = "Fuzzel blur",
	match = {
		namespace = "launcher",
	},

	blur = true,
})

hl.layer_rule({
	name = "DMS blur",
	match = {
		namespace = "dms:bar",
	},

	blur = false,
})
