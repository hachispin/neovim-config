vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

local parsers = {
	"bash",
	"c",
	"c_sharp",
	"cpp",
	"diff",
	"html",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"vim",
	"vimdoc",
}

local ts = require("nvim-treesitter")
-- ts.setup({ endwise = { enabled = true }, autopairs = { enabled = true } })
ts.install(parsers)

-- Treesitter recommends this
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		ts.update()
	end,
})

local comment_fold_queries = {
	"(comment)+ @fold",
	"[(line_comment) (block_comment)]+ @fold",
}

local comment_folds_enabled = {}

---@param language string
local function enable_comment_folds(language)
	if comment_folds_enabled[language] ~= nil then
		return
	end

	for _, query in ipairs(comment_fold_queries) do
		if pcall(vim.treesitter.query.parse, language, query) then
			-- Keep the language's normal folds and add runs of line comments or a
			-- single multi-line block comment as an extra fold.
			vim.treesitter.query.set(language, "folds", "; extends\n" .. query)
			comment_folds_enabled[language] = true
			return
		end
	end

	comment_folds_enabled[language] = false
end

-- From kickstart.nvim
---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
	-- Check if a parser exists and load it
	if not vim.treesitter.language.add(language) then
		return
	end

	-- Enable syntax highlighting and other treesitter features
	vim.treesitter.start(buf, language)

	-- Enable treesitter based folds
	-- For more info on folds see `:help folds`
	enable_comment_folds(language)
	vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.wo.foldmethod = "expr"

	-- Check if treesitter indentation is available for this language, and if so enable it
	-- in case there is no indent query, the indentexpr will fallback to the vim's built in one
	local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

	-- Enable treesitter based indentation
	if has_indent_query then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local buf, filetype = args.buf, args.match
		local language = vim.treesitter.language.get_lang(filetype)

		if not language then
			return
		end

		treesitter_try_attach(buf, language)
	end,
})
