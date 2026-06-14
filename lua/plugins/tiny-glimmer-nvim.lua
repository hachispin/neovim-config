vim.pack.add({ "https://github.com/rachartier/tiny-glimmer.nvim" })

require("tiny-glimmer").setup({
	-- Automatic keybinding overwrites
	overwrite = {

		-- Animations
		yank = { enabled = true },
		paste = { enabled = true },
		undo = { enabled = true },
		redo = { enabled = true },
	},

	animations = {
		fade = {
			max_duration = 300,
			min_duration = 300,
			from_color = "#FFFF00",
			to_color = "Normal",
		},
	},
})
