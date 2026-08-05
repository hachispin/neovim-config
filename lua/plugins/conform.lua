-- TODO: Figure out a way to trigger loading on commands (such as :ConformInfo) too.
lazy_on_event("BufWritePre", function()
	vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

	local conform = require("conform")
	conform.setup({
		formatters_by_ft = {
			["_"] = { "trim_newlines", "trim_whitespace" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			css = { "prettierd" },
			html = { "prettierd" },
			javascript = { "biome" },
			json = { "biome" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			python = { "ruff_format" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			toml = { "tombi" },
			typescript = { "biome" },
			yaml = { "prettierd" },
		},

		-- Format asynchronously
		format_after_save = {
			lsp_format = "fallback",
		},
	})
end)
