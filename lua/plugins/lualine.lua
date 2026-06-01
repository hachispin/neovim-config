vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
	sections = {
		lualine_x = {
			{ "%S", separator = "" },
			"encoding",
			"fileformat",
			-- To ensure correct padding even if no lsp_status
			{
				"filetype",
				separator = "",
				padding = { left = 1, right = 0 },
				cond = function()
					return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
				end,
			},
			{
				"filetype",
				separator = "",
				padding = { left = 1, right = 1 },
				cond = function()
					return next(vim.lsp.get_clients({ bufnr = 0 })) == nil
				end,
			},
			{
				"lsp_status",
				show_name = false,
				icons_enabled = false,
				symbols = { separator = "" },
				padding = { left = 0, right = 1 },
			},
		},
	},
})
