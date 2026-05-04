return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.everforest_enable_italic = true
		vim.g.everforest_background = "soft"
		vim.g.everforest_better_performance = 1
		vim.cmd.colorscheme("everforest")
	end,
}
