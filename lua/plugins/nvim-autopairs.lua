lazy_on_event("InsertEnter", function()
	vim.pack.add({ "https://github.com/windwp/nvim-autopairs" })

	local npairs = require("nvim-autopairs")
	local Rule = require("nvim-autopairs.rule")
	local cond = require("nvim-autopairs.conds")
	local endwise = require("nvim-autopairs.ts-rule").endwise
	local cpp_operator = cond.before_text("operator")
	local cpp_angle_pair_conditions = {
		-- Template names, including identifiers ending in a digit or underscore.
		cond.before_regex("[%w_]+:?:?$", 3),
		cond.before_regex("#include%s?$", 9),
		cond.before_text("template "),
		cond.before_text("import "),
		cond.before_text("__has_include("),
		cond.before_text("__has_include_next("),
		-- C++20 generic lambdas, including non-empty capture lists.
		cond.before_regex("%b[]$", -1),
		cond.before_text("operator()"),
	}

	local function cpp_angle_pair(opts)
		-- Avoid `operator<`, `operator<<`, and `operator<=>` declarations.
		if cpp_operator(opts) then
			return false
		end

		for _, condition in ipairs(cpp_angle_pair_conditions) do
			if condition(opts) then
				return true
			end
		end

		return false
	end

	npairs.setup({})
	npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
	npairs.add_rules({
		endwise("then$", "fi", "sh"),
		endwise("do$", "done", "sh"),
		endwise("^%s*case%s+.*%s+in$", "esac", "sh"),

		Rule(" ", " ", { "sh", "bash", "zsh" }):with_pair(function(opts)
			return opts.line:sub(opts.col - 1, opts.col) == "[]"
		end):with_move(cond.done()),

		Rule("<", ">", { "rust", "java", "cs" }):with_pair(
			-- regex will make it so that it will auto-pair on
			-- `a<` but not `a <`
			-- The `:?:?` part makes it also
			-- work on Rust generics like `some_func::<T>()`
			cond.before_regex("%a+:?:?$", 3)
		):with_move(function(opts)
			return opts.char == ">"
		end),

		Rule("<", ">", { "cpp" }):with_pair(cpp_angle_pair):with_move(function(opts)
			return opts.char == ">"
		end),

		Rule("<", ">", { "c" }):with_pair(cond.before_text("#include")):with_move(function(opts)
			return opts.char == ">"
		end),
	})
end)
