vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
	sections = {
		lualine_x = {
			{ "%S", separator = "" },
			{
				"encoding",
				fmt = function(msg)
					if msg ~= "" then
						return msg
					end

					local n = math.random(6)

					if n == 1 then
						return "haii !!"
					elseif n == 2 then
						return "procrastinating?"
					elseif n == 3 then
						return ">-<"
					elseif n == 4 then
						return "it's OVER"
					elseif n == 5 then
						return "get another hobby"
					elseif n == 6 then
						return "b-baka!"
					end
				end,
			},
			{ "fileformat" },
			{ "filetype", separator = "", padding = { left = 1, right = 0 } },
			{
				"lsp_status",
				show_name = false,
				icons_enabled = false,
				symbols = { separator = "", done = "" },
				padding = { left = 0, right = 1 },
				fmt = function(msg)
					if msg == "" and vim.bo.filetype ~= "" then
						return " "
					end

					return msg
				end,
			},
		},
	},
})
