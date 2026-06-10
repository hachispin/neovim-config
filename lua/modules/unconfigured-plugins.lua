vim.pack.add({
	"https://github.com/RRethy/nvim-treesitter-endwise",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/mrcjkb/rustaceanvim",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/tpope/vim-fugitive",
})

-- Some plugins need this
require("mini.surround").setup({})
