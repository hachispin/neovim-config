vim.pack.add({ "https://github.com/xiyaowong/transparent.nvim" })

vim.pack.add({ -- colorschemes
	"https://github.com/sainnhe/everforest",
	"https://github.com/alexvzyl/nordic.nvim",
	"https://github.com/olivercederborg/poimandres.nvim",
})

require("transparent").setup({})
vim.g.everforest_enable_italic = true
vim.g.everforest_background = "hard"

vim.cmd.colorscheme("everforest")
