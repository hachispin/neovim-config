vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local shell_fts = { "sh", "bash", "zsh" }
npairs.setup({})

npairs.add_rules({
	Rule(" ", " ", shell_fts):with_pair(function(opts)
		return opts.line:sub(opts.col - 1, opts.col) == "[]"
	end):with_move(function(_)
		return true
	end),
})
