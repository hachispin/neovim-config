lazy_later(function()
	vim.pack.add({
		-- TODO: Stop using this patch once it's merged.
		{ src = "https://github.com/ixti/nvim-treesitter-endwise", version = "nvim-0-11-compat" },
		"https://github.com/lewis6991/gitsigns.nvim",
		"https://github.com/mrcjkb/rustaceanvim",
		"https://github.com/nvim-mini/mini.surround",
		"https://github.com/tpope/vim-fugitive",
	})

	-- Some plugins need this
	require("mini.surround").setup({})
end)
