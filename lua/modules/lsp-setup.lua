vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

-- Stuff to install
-- (Don't add rust-analyzer, it's handled by rustaceanvim)
require("mason-tool-installer").setup({
	ensure_installed = {
		"basedpyright",
		"bash-language-server",
		"clangd",
		"csharp-language-server",
		"lua-language-server",
		"ruff",
		"stylua",
		"tombi",
		"clang-format",
		"csharpier",
		"isort",
		"prettierd",
		"roslyn",
		"shellcheck",
		"shfmt",
	},
	auto_update = true,
})

-- LSP configs
vim.lsp.config("lua_ls", {
	settings = { Lua = { diagnostics = { globals = { "vim" } }, format = { enable = false } } },
})

-- Enable LSPs
vim.lsp.enable({ "lua_ls", "clangd" })
