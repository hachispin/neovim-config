local opts = {
	compile = true, -- enable compiling the colorscheme
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = false,
	dimInactive = false,
	terminalColors = true,
	colors = { -- add/modify theme and palette colors
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},
	overrides = function(colors) -- add/modify highlights
		return {}
	end,
	theme = "wave", -- Load "wave" theme
	background = { -- map the value of 'background' option to a theme
		dark = "wave", -- try "dragon" !
		light = "lotus",
	},
}

return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	opts = opts,
}
