vim.pack.add({
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
})

local ok, messages = pcall(vim.fn.readfile, vim.fn.stdpath("config") .. "/messages.txt")
local current_message = messages[math.random(#messages)]
local message_refresh_rate = 2 --seconds
local message_start = os.time()

require("lualine").setup({
	-- extensions = { "quickfix", "fugitive", "mason" },
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
					if msg ~= "" or vim.bo.buftype ~= "" or not ok then
						return msg
					end

					if os.time() >= message_start + message_refresh_rate then
						current_message = messages[math.random(#messages)]
						message_start = os.time()
					end

					return current_message
				end,
			},
			-- I use fedora BTW
			{ "fileformat", symbols = { unix = "" }, color = { fg = "#51A2DA" } },
			{ "filetype", separator = "", padding = { left = 1, right = 0 } },
			{
				"lsp_status",
				show_name = false,
				icons_enabled = false,
				padding = { left = 0, right = 1 },
				symbols = {
					done = "󰄭",
					separator = "",
				},

				fmt = function(msg)
					if msg == "" then
						-- LSP but no status
						if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
							return " 󰄬"
						end

						-- No LSP at all, but isn't like [No Name] or whatever
						if vim.bo.filetype ~= "" then
							return " "
						end
					end

					return msg
				end,
			},
		},
	},
})
