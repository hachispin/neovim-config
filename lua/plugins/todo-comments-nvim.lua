vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })

require("todo-comments").setup({
	signs = false,
	keywords = {
		FIX = { alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
		TODO = { alt = { "TO-DO" } },
		HACK = { alt = { "WORKAROUND" } },
		WARN = { alt = { "WARNING", "XXX" } },
		PERF = { alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "OPTIMISE" } },
		NOTE = { alt = { "INFO", "TIP", "SAFETY", "N.B", "NB" } },
		TEST = { alt = { "TESTING", "PASSED", "FAILED", "PASS", "FAIL" } },
	},

	-- Allows, e.g., "FIXME(issue-to-fix): ..." to be highlighted.
	search = { pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]] },
	highlight = { pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]] },
})
