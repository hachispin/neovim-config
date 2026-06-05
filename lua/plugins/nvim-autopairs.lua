vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.setup({})
npairs.add_rules({
	Rule(" ", " ", { "sh", "bash", "zsh" }):with_pair(function(opts)
		return opts.line:sub(opts.col - 1, opts.col) == "[]"
	end):with_move(cond.done()),
})
