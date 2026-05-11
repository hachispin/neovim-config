return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"basedpyright",
			"bashls",
			"clangd",
			"csharp_ls",
			"lua_ls",
			"ruff",
			"stylua",
			"tombi",
		},
		--[[  go install these lol 
			"clang-format"
			"csharpier" 
			"isort" 
			"prettierd" 
			"roslyn" 
			"shellcheck" 
			"shfmt"
		--]]
		automatic_enable = {
			exclude = {
				-- rustaceanvim conflict!
				"rust_analyzer",
			},
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
