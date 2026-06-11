vim.pack.add({ "https://github.com/rachartier/tiny-glimmer.nvim" })

-- TODO: Animate <leader> prefixed keybinds
require("tiny-glimmer").setup({
	-- Enable/disable the plugin
	enabled = true,

	-- Automatically reload highlights when colorscheme changes
	-- When enabled, cached highlights will be refreshed on ColorScheme autocmd
	autoreload = true,

	-- Automatic keybinding overwrites
	overwrite = {

		-- Animations
		yank = { enabled = true },
		search = { enabled = true },
		paste = { enabled = true },
		undo = { enabled = true },
		redo = { enabled = true },
	},
})
