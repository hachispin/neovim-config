-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Leader key
vim.g.mapleader = " "

-- General
vim.o.confirm = true
vim.o.inccommand = "split"
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 200

-- Visual improvements
require("vim._core.ui2").enable()
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.showbreak = "󱞵 "
vim.o.showmode = false
vim.o.signcolumn = "yes:1"
vim.o.winborder = "rounded"

-- Line numbers (relative)
vim.o.number = true
vim.o.relativenumber = true

-- Less annyoing searching
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.o.ignorecase = true
vim.o.smartcase = true

-- Splitting behaviour
vim.o.splitbelow = true
vim.o.splitright = true

-- Blending
vim.o.winblend = 20
vim.o.pumblend = 20

-- Hide command area when it's not being used while still
-- showing partial commands in statusline (or lualine)
vim.o.cmdheight = 0
vim.o.showcmd = true
vim.o.showcmdloc = "statusline"

vim.diagnostic.config({
	-- Handled by tiny-inline-diagnostic
	virtual_lines = false,
	virtual_text = false,

	-- HACK: Set signs so that tiny-inline-diagnostic can inherit these
	-- as signs can't be configured per severity in the plugin's config.
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},

	-- Auto open the float when jumping with `[d` and `]d`
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({
				bufnr = bufnr,
				scope = "cursor",
				focus = false,
			})
		end,
	},
})

-- HACK: Lobotomize the sign handlers (displayed in the signcolumn) to be replaced
-- with tiny-inline-diagnostic with the multilines + display_count options enabled.
vim.diagnostic.handlers.signs = {
	show = function(_, _, _, _) end,
	hide = function(_, _) end,
}

-- I'm lazy
vim.keymap.set({ "n", "v" }, ";", ":")
vim.keymap.set({ "n", "v" }, ":", ":!")

-- LSP keymaps
vim.keymap.set("n", "<leader>r", function()
	-- NOTE: Must run :wa afterwards
	vim.lsp.buf.rename()
end)

vim.keymap.set("n", "<leader>v", function()
	vim.diagnostic.open_float()
end)

vim.keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	vim.lsp.buf.code_action()
end)

-- Easier split navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Switching buffers with , and .
vim.keymap.set("n", "<leader>,", function()
	vim.cmd.bp()
end)

vim.keymap.set("n", "<leader>.", function()
	vim.cmd.bn()
end)

-- Yank/put/delete with/from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d')
vim.keymap.set("n", "<leader>dd", '"+dd')
vim.keymap.set("n", "<leader>D", '"+D')

-- WARN: This may cause some issues if cols < scrolloff * 2
-- while writing on the last line with some terminals.
--
-- Make scrolloff behave as you'd expect when approaching
-- EOF. This should be replaced with scrolloffpad if it
-- ever receives the options to replicate this behaviour.
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("ScrollOffEOF", {}),
	callback = function()
		local win_h = vim.api.nvim_win_get_height(0)
		local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
		local dist = vim.fn.line("$") - vim.fn.line(".")
		local rem = vim.fn.line("w$") - vim.fn.line("w0") + 1
		if dist < off and win_h - rem + dist < off then
			local view = vim.fn.winsaveview()
			view.topline = view.topline + off - (win_h - rem + dist)
			vim.fn.winrestview(view)
		end
	end,
})

-- Prevent jumpy indents from the namespace resolution
-- operator initially being taken as a label in C++.
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cpp",
	callback = function(_)
		vim.cmd.setlocal("indentkeys-=:")
	end,
})

vim.api.nvim_create_user_command("Cfg", function()
	vim.cmd.cd(vim.fn.stdpath("config"))
	vim.cmd.e("init.lua")

	-- Restore old position
	local mark = vim.api.nvim_buf_get_mark(0, '"')
	local lcount = vim.api.nvim_buf_line_count(0)
	if mark[1] > 0 and mark[1] <= lcount then
		pcall(vim.api.nvim_win_set_cursor, 0, mark)
	end
end, {})

-- Auto require plugins and modules
for _, dir in ipairs({ "modules", "plugins" }) do
	local path = vim.fn.stdpath("config") .. "/lua/" .. dir .. "/"

	for _, file in ipairs(vim.fn.glob(path .. "*.lua", false, true)) do
		local basename = vim.fs.basename(file)
		local filename = basename:sub(1, basename:len() - 4)
		require(dir .. "." .. filename)
	end
end

-- Colorscheme is set in modules/colorschemes.lua
