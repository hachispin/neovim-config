vim.pack.add({ -- colorschemes
	"https://github.com/alexvzyl/nordic.nvim", -- nordic
	"https://github.com/olivercederborg/poimandres.nvim", -- poimandres
	"https://github.com/sainnhe/everforest", -- everforest
	"https://github.com/savq/melange-nvim", -- melange
	"https://github.com/alexmozaidze/palenight.nvim", -- palenight
	"https://github.com/ficd0/ashen.nvim", -- ashen
})

require("palenight").setup({ italic = true })
vim.cmd.colorscheme("palenight")
