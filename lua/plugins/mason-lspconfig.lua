return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"basedpyright",
			"ruff",
			"lua_ls",
			"bashls",
			"clangd",
			"csharp_ls",
		},
		automatic_enable = {
			exclude = {
				-- rustaceanvim conflict
				"rust_analyzer",
			},
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
