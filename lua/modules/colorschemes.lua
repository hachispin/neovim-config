lazy_later(function()
	vim.pack.add({
		"https://github.com/alexvzyl/nordic.nvim", -- nordic
		"https://github.com/olivercederborg/poimandres.nvim", -- poimandres
		"https://github.com/savq/melange-nvim", -- melange
		"https://github.com/alexmozaidze/palenight.nvim", -- palenight
		"https://github.com/ficd0/ashen.nvim", -- ashen
	})

	require("palenight").setup({ italic = true })
end)

vim.pack.add({
	"https://github.com/neanias/everforest-nvim", -- everforest
})

require("everforest").setup({
	---Whether italics should be used for keywords and more.
	italics = true,
	---The contrast of line numbers, indent lines, etc. Options are `"high"` or
	---`"low"` (default).
	ui_contrast = "high",
})

vim.cmd.colorscheme("everforest")
