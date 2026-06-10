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
	highlight = {
		pattern = [[.*<(KEYWORDS)(\([^)]*\))?\s*:]],
	},
	search = {
		pattern = [[\b(KEYWORDS)(\([^)]*\))?:]],
	},
})

-- FIXME(what-to-fix): Hi
--
-- FIXME: Hi
--
-- TODO: Hi
--
-- FIXME(): Hi
--
-- FIXME(what-to-fix-man): The future of business isn't coming -- it's _here_.
