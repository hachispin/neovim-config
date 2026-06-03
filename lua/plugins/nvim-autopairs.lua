vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")

-- Claude just made some BULLSHIT !!
-- Based off lexima.vim rules

-- Shared helpers
local function close_exists_below(line, kw)
	local bufnr = vim.api.nvim_get_current_buf()
	local row = vim.api.nvim_win_get_cursor(0)[1] -- 1-indexed
	local indent = line:match("^(%s*)")
	-- 1-indexed row == 0-indexed next line, so pass directly to buf_get_lines
	local rest = vim.api.nvim_buf_get_lines(bufnr, row, -1, false)
	for _, l in ipairs(rest) do
		if l:match("^%s*$") then
		-- blank: keep scanning
		elseif l:sub(1, #indent) == indent then
			local ch = l:sub(#indent + 1, #indent + 1)
			if ch:match("%s") then
			-- more indented: keep scanning
			else
				return l:match("^%s*" .. kw .. "%s") ~= nil or l:match("^%s*" .. kw .. "$") ~= nil
			end
		else
			return false
		end
	end
	return false
end

local function lua_guard(opts)
	return not opts.line:match("^%s*%-%-") and not close_exists_below(opts.line, "end")
end

local function sh_guard(opts, kw)
	return not opts.line:match("^%s*#") and not close_exists_below(opts.line, kw)
end

npairs.setup({})
npairs.add_rules({
	-- Lua
	Rule("then", "end", "lua"):end_wise(function(opts)
		if not lua_guard(opts) then
			return false
		end
		return opts.line:match("^%s*if%s+") ~= nil
	end),

	Rule("do", "end", "lua"):end_wise(function(opts)
		if not lua_guard(opts) then
			return false
		end
		return opts.line:match("^%s*while%s+") ~= nil
			or opts.line:match("^%s*for%s+") ~= nil
			or opts.line:match("^%s*do%s*$") ~= nil
	end),

	Rule(")", "end", "lua"):end_wise(function(opts)
		if not lua_guard(opts) then
			return false
		end
		if opts.line:match("%f[%w]end%f[%W]") then
			return false
		end
		return opts.line:match("^%s*function%s+") ~= nil
			or opts.line:match("^%s*local%s+function%s+") ~= nil
			or opts.line:match("=%s*function%s*%(") ~= nil
	end),

	-- Bash
	Rule(" ", " ", "sh")
		:with_pair(function(opts)
			return opts.line:sub(opts.col - 1, opts.col) == "[]"
		end)
		:with_move(cond.done())
		:with_del(cond.done()),

	Rule("do", "done", "sh"):end_wise(function(opts)
		if not sh_guard(opts, "done") then
			return false
		end
		return opts.line:match("^%s*for%s+") ~= nil
			or opts.line:match("^%s*while%s+") ~= nil
			or opts.line:match("^%s*until%s+") ~= nil
			or opts.line:match("^%s*select%s+") ~= nil
	end),

	Rule("in", "esac", "sh"):end_wise(function(opts)
		if not sh_guard(opts, "esac") then
			return false
		end
		return opts.line:match("^%s*case%s+") ~= nil
	end),

	Rule("then", "fi", "sh"):end_wise(function(opts)
		if not sh_guard(opts, "fi") then
			return false
		end
		return opts.line:match("^%s*if%s+") ~= nil
	end),
})
