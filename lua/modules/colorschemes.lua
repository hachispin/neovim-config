-- themes maybe
--[[ 
	"https://github.com/alexmozaidze/palenight.nvim", -- palenight { italic = true }
	"https://github.com/alexvzyl/nordic.nvim", -- nordic
	"https://github.com/arnauKL/south.nvim", -- south
	"https://github.com/blazkowolf/gruber-darker.nvim", -- gruber-darker
	"https://github.com/ficd0/ashen.nvim", -- ashen
	"https://github.com/savq/melange-nvim", -- melange
	"https://github.com/neanias/everforest-nvim", -- everforest { italics = true, ui_contrast = "high" }
--]]

local theme_src = ""
local theme = ""
local opts = {}

if vim.g.background == "light" then
	theme_src = "https://github.com/neanias/everforest-nvim"
	theme = "everforest"
	opts = { italics = true, ui_contrast = "high" }
else
	theme_src = "https://github.com/blazkowolf/gruber-darker.nvim"
	theme = "gruber-darker"
end

vim.pack.add({ theme_src })

-- Put colorscheme autocmds here.
if vim.g.neovide then
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function(_)
			vim.api.nvim_set_hl(0, "FloatBorder", { link = "NormalFloat" })
		end,
	})
end

require(theme).setup(opts)
vim.cmd.colorscheme(theme)
