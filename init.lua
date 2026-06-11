-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "."

-- New UI with pager stuff
require("vim._core.ui2").enable()

local blend = 20

vim.o.confirm = true -- ask to save when doing :q on unsaved buffer
vim.o.cursorline = true -- highlight current line
vim.o.ignorecase = true -- case-insensitive search by default
vim.o.inccommand = "split" -- view substitutions live
vim.o.number = true -- show line number
vim.o.pumblend = blend -- pop up menu blending
vim.o.relativenumber = true -- lines numbers shown relative to the cursor
vim.o.scrolloff = 10 -- keep 10 lines above/below cursor
vim.o.shiftwidth = 4 -- amount to shift (<</>>)
vim.o.showmode = false -- don't show mode (e.g, INSERT)
vim.o.signcolumn = "yes:1" -- reserve one space in signcolumn always
vim.o.smartcase = true -- case-sensitive if \C or search contains captial letters
vim.o.splitbelow = true -- splitting behaviour
vim.o.splitright = true -- ^
vim.o.tabstop = 4 -- visual size of tab (in spaces)
vim.o.undofile = true -- save undo history to file for persistence
vim.o.updatetime = 200 -- makes events more responsive (200ms)
vim.o.winblend = blend -- transparency for floating windows
vim.o.winborder = "none" -- border style for floating windows

-- Show partial cmds (in lualine)
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

-- Be annoying
vim.keymap.set("n", "<left>", "<cmd>echo 'Use h to move!!'<CR>")
vim.keymap.set("n", "<down>", "<cmd>echo 'Use j to move!!'<CR>")
vim.keymap.set("n", "<up>", "<cmd>echo 'Use k to move!!'<CR>")
vim.keymap.set("n", "<right>", "<cmd>echo 'Use l to move!!'<CR>")

-- Clear highlights from search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- LSP rename (note: must run :wa after)
vim.keymap.set("n", "<leader>r", function()
	vim.lsp.buf.rename()
end)

-- View diagnostic
vim.keymap.set("n", "<leader>v", function()
	vim.diagnostic.open_float()
end)

-- Toggle inlay hints
vim.keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Fix
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

-- NOTE: This should be replaced with scrolloffpad if it
-- ever receives the options to replicate this behaviour.
--
-- Make scrolloff behave as you'd expect when approaching EOF
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
-- operator initially being taken as a label.
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
