local opts = {
	formatters_by_ft = {
		-- Conform will run multiple formatters sequentially
		-- You can customize some of the format options for the filetype (:help conform.format)
		-- Conform will run the first available formatter
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettier" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_format = "fallback",
	},
}

return {
	"stevearc/conform.nvim",
	opts = opts,
}
