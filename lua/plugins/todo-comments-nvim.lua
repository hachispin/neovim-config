vim.pack.add({ "https://github.com/folke/todo-comments.nvim" })

require("todo-comments").setup({
	keywords = {
		FIX = { alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
		TODO = { alt = {} },
		HACK = { alt = {} },
		WARN = { alt = { "WARNING", "XXX" } },
		PERF = { alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "OPTIMISE" } },
		NOTE = { alt = { "INFO", "TIP", "SAFETY" } },
		TEST = { alt = { "TESTING", "PASSED", "FAILED", "PASS", "FAIL" } },
	},
})
