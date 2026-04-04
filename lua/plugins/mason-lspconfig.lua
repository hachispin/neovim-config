return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"lua_ls",
			"bashls",
			"clangd",
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
