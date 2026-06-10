vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.setup({})
npairs.add_rules({
	Rule(" ", " ", { "sh", "bash", "zsh" }):with_pair(function(opts)
		return opts.line:sub(opts.col - 1, opts.col) == "[]"
	end):with_move(cond.done()),

	Rule("<", ">"):with_pair(
		-- regex will make it so that it will auto-pair on
		-- `a<` but not `a <`
		-- The `:?:?` part makes it also
		-- work on Rust generics like `some_func::<T>()`
		cond.before_regex("%a+:?:?$", 3)
	):with_move(function(opts)
		return opts.char == ">"
	end),
})
