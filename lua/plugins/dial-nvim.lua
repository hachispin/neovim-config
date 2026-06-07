vim.pack.add({ "https://github.com/monaqa/dial.nvim" })

local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal_int, -- includes negative
		-- Non-negative
		augend.integer.alias.hex,
		augend.integer.alias.octal,
		augend.integer.alias.binary,
		-- Time formats
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%d/%m/%Y"],
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%H:%M:%S"],
		augend.date.alias["%H:%M"],
		augend.constant.alias.bool, -- true<->false
		augend.constant.alias.Bool, -- True<->False
		augend.semver.alias.semver, -- inc. MAJOR resets MINOR, PATCH and etc.

		-- Custom stuff
		augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
		augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
		augend.constant.new({ elements = { "<<", ">>" }, word = false, cyclic = true }),
	},
})

-- Override normal <C-a> and <C-x>
vim.keymap.set("n", "<C-a>", function()
	require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "<C-x>", function()
	require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g<C-a>", function()
	require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g<C-x>", function()
	require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("x", "<C-a>", function()
	require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("x", "<C-x>", function()
	require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("x", "g<C-a>", function()
	require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("x", "g<C-x>", function()
	require("dial.map").manipulate("decrement", "gvisual")
end)
