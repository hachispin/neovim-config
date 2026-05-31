vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
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
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
