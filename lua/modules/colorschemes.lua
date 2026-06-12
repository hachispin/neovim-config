vim.pack.add({ -- colorschemes
	"https://github.com/sainnhe/everforest",
	"https://github.com/sainnhe/gruvbox-material",
	"https://github.com/alexvzyl/nordic.nvim",
	"https://github.com/olivercederborg/poimandres.nvim",
})

local use_italic = false

vim.g.everforest_enable_italic = use_italic
vim.g.everforest_background = "hard"
vim.g.gruvbox_material_background = "hard"

vim.cmd.colorscheme("everforest")
