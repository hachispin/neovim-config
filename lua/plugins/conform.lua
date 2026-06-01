vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
	formatters_by_ft = {
		c = { "clang-format" },
		cpp = { "clang-format" },
		javascript = { "prettierd" },
		lua = { "stylua" },
		python = { "isort", "ruff_format" },
		-- rust = { "rustfmt" }, (rustaceanvim)
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
