-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "."

-- New UI with pager stuff
require("vim._core.ui2").enable()

vim.o.winborder = "rounded" -- rounded borders
vim.o.shiftwidth = 4 -- amount to shift (<</>>)
vim.o.tabstop = 4 -- visual size of tab (in spaces)
vim.o.showmode = false -- don't show mode (e.g, INSERT) because i use lualine
vim.o.relativenumber = true -- lines numbers shown relative to the cursor
vim.o.cursorline = true -- highlight current line
vim.o.number = true -- show line number
vim.o.inccommand = "split" -- view substitutions live
vim.o.undofile = true -- save undo history to file for persistence
vim.o.updatetime = 200 -- makes events more responsive (200ms)
vim.o.scrolloff = 10 -- keep 10 lines above and below cursor
vim.o.ignorecase = true -- case-insensitive search by default
vim.o.smartcase = true -- case-sensitive if \C or search contains captial letters
vim.o.splitright = true -- change splitting behaviour
vim.o.splitbelow = true -- ^
vim.o.confirm = true -- ask to save when doing :q on unsaved buffer

-- Show partial cmds (in lualine)
vim.o.cmdheight = 0
vim.o.showcmd = true
vim.o.showcmdloc = "statusline"

vim.diagnostic.config({
	-- Handled by tiny-inline-diagnostic
	virtual_lines = false,
	virtual_text = false,

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
end, { desc = "LSP rename" })

-- View diagnostic
vim.keymap.set("n", "<leader>v", function()
	vim.diagnostic.open_float()
end)

-- Toggle inlay hints
vim.keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Fix
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.code_action()
end)

-- Easier split navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Switching buffers with , and .
vim.keymap.set("n", "<leader>,", function()
	vim.cmd.bp()
end, { desc = "Move to previous buffer" })

vim.keymap.set("n", "<leader>.", function()
	vim.cmd.bn()
end, { desc = "Move to next buffer" })

-- Yank/put with/from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "[y]ank to system clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "[yy]ank current line to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "[Y]ank until end of line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "[p]ut from system clipboard (after)" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "[P]ut from system clipboard (before)" })

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

-- Current colorscheme
vim.cmd.colorscheme("everforest")

-- Neovide specific options
if vim.g.neovide then
	-- Window settings
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_padding_top = 12
	vim.g.neovide_refresh_rate = 120 -- only applies if --no-vsync is passed

	-- Cursor settings
	vim.g.neovide_cursor_cell_color_fallback = true
	--[[
	vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_trail_size = 0.3
	vim.g.neovide_scroll_animation_length = 0.3
	--]]

	-- Zooming implementation
	local sf = 1.125

	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end

	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(sf)
	end)

	vim.keymap.set("n", "<C-0>", function()
		vim.g.neovide_scale_factor = 1.0
	end)

	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / sf)
	end)

	-- Transparency controls
	-- (NOTE: future self may want vim.g.neovide_normal_opacity)
	local opacity_interval = 0.05
	local minimum_opacity = 0.5
	vim.g.neovide_opacity = 1.0

	vim.keymap.set("n", "<leader>t=", function()
		vim.g.neovide_opacity = math.min(1.0, vim.g.neovide_opacity + opacity_interval)
	end)

	vim.keymap.set("n", "t0", function()
		vim.g.neovide_opacity = 1.0
	end)

	vim.keymap.set("n", "<leader>t-", function()
		vim.g.neovide_opacity = math.max(minimum_opacity, vim.g.neovide_opacity - opacity_interval)
	end)
end
