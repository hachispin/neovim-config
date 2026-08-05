vim.pack.add({ "https://github.com/NMAC427/guess-indent.nvim" })

require("guess-indent").setup({
	on_tab_options = {
		["shiftwidth"] = 4,
	},
})
