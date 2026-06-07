vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

local messages = vim.fn.readfile(vim.fn.stdpath("config") .. "/messages.txt")
local current_message = messages[math.random(#messages)]
local message_refresh_rate = 2 --seconds
local message_start = os.time()

require("lualine").setup({
	options = {
		globalstatus = true,
		always_show_tabline = false,
	},
	sections = {
		lualine_x = {
			{ "%S", separator = "" },
			{
				"encoding",
				fmt = function(msg)
					if msg ~= "" or vim.bo.buftype ~= "" then
						return msg
					end

					if os.time() >= message_start + message_refresh_rate then
						current_message = messages[math.random(#messages)]
						message_start = os.time()
					end

					return current_message
				end,
			},
			-- i use fedora btw
			{ "fileformat", symbols = { unix = "" }, color = { fg = "#51A2DA" } },
			{ "filetype", separator = "", padding = { left = 1, right = 0 } },
			{
				"lsp_status",
				show_name = false,
				icons_enabled = false,
				padding = { left = 0, right = 1 },
				symbols = {
					done = "",
					separator = "",
				},

				fmt = function(msg)
					if msg == "" and #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
						return " "
					end

					return msg
				end,
			},
		},
	},
})
