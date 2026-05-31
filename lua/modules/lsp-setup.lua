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
require("mason-tool-installer").setup({
	ensure_installed = {
		"basedpyright",
		"bash-language-server",
		"clang-format",
		"clangd",
		"csharp-language-server",
		"csharpier",
		"isort",
		"lua-language-server",
		"prettierd",
		"pyright",
		"roslyn",
		"ruff",
		-- "rust-analyzer", (handled by rustaceanvim)
		"shellcheck",
		"shfmt",
		"stylua",
		"tombi",
	},
	auto_update = true,
})

-- LSP configs
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			format = { enable = false },
			runtime = { version = "LuaJIT" },
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
			telemetry = { enable = false },
		},
	},
})

-- Enable LSPs
vim.lsp.enable({
	"lua_ls",
	"clangd",
	"csharp_ls",
	"basedpyright",
	"bash_ls",
	"ruff",
	"tombi",
	"roslyn",
})
