vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter" } })

local ts = require("nvim-treesitter")
ts.setup({})
ts.install({ "rust", "bash", "c", "cpp", "c_sharp" })

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		ts.update()
	end,
})
