vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")

npairs.setup({})
npairs.add_rules({
	-- Bash [ ] and [[ ]] blocks
	Rule(" ", " ", "sh")
		:with_pair(function(opts)
			return opts.line:sub(opts.col - 1, opts.col) == "[]"
		end)
		:with_move(cond.done())
		:with_del(cond.done()),

	-- Courtesy of Claude...
	Rule("do", "done", "sh"):end_wise(function(opts)
		return string.match(opts.line, "^%s*for%s+") ~= nil
			or string.match(opts.line, "^%s*while%s+") ~= nil
			or string.match(opts.line, "^%s*until%s+") ~= nil
			or string.match(opts.line, "^%s*select%s+") ~= nil
	end),

	Rule("in", "esac", "sh"):end_wise(function(opts)
		return string.match(opts.line, "^%s*case%s+") ~= nil
	end),

	Rule("then", "fi", "sh"):end_wise(function(opts)
		return string.match(opts.line, "^%s*if%s+") ~= nil or string.match(opts.line, "^%s*elif%s+") ~= nil
	end),

	Rule("then", "end", "lua"):end_wise(function(opts)
		return string.match(opts.line, "^%s*if%s+") ~= nil or string.match(opts.line, "^%s*elseif%s+") ~= nil
	end),

	Rule("do", "end", "lua"):end_wise(function(opts)
		return string.match(opts.line, "^%s*while%s+") ~= nil
			or string.match(opts.line, "^%s*for%s+") ~= nil
			or string.match(opts.line, "^%s*do%s*$") ~= nil
	end),

	Rule(")", "end", "lua"):end_wise(function(opts)
		return string.match(opts.line, "^%s*function%s+") ~= nil
			or string.match(opts.line, "^%s*local%s+function%s+") ~= nil
			or string.match(opts.line, "=%s*function%s*%(") ~= nil
	end),
})
