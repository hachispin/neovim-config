-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = "."

-- new ui with pager stuff
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

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },

	virtual_text = { current_line = true },
	virtual_lines = false,

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

-- partial cmds
vim.o.cmdheight = 0
vim.o.showcmd = true
vim.o.showcmdloc = "statusline"

-- i'm lazy
vim.keymap.set("n", ";", ":")

-- clear highlights from /
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")


-- lsp rename (note: must run :wa after)
vim.keymap.set("n", "<leader>r", function()
	vim.lsp.buf.rename()
end, { desc = "LSP rename" })

-- view diagnostic
vim.keymap.set("n", "<leader>v", function()
	vim.diagnostic.open_float()
end)

-- toggle inlay hints
vim.keymap.set("n", "<leader>h", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- fix
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.code_action()
end)

-- easier split nav
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- switching buffers with , and .
vim.keymap.set("n", "<leader>,", function()
	vim.cmd.bp()
end, { desc = "Move to previous buffer" })

vim.keymap.set("n", "<leader>.", function()
	vim.cmd.bn()
end, { desc = "Move to next buffer" })

-- yank/put with/from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "[y]ank to system clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "[yy]ank current line to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "[Y]ank until end of line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "[p]ut from system clipboard (after)" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "[P]ut from system clipboard (before)" })

-- require
require('plugins.cord')
require('plugins.lualine')
require('lsp-setup')
require('rustaceanvim')

-- neovide specific things
if vim.g.neovide then
	-- window settings
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_padding_top = 12
	vim.g.neovide_refresh_rate = 120 -- only applies if --no-vsync is passed

	-- cursor settings
	vim.g.neovide_cursor_cell_color_fallback = true
	--[[
	vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_trail_size = 0.3
	vim.g.neovide_scroll_animation_length = 0.3
	--]]

	-- zooming implementation
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

	-- transparency controls (note: future self may want vim.g.neovide_normal_opacity)
	local opacity_interval = 0.05
	local minimum_opacity = 0.5
	vim.g.neovide_opacity = 1.0

	vim.keymap.set("n", "t=", function()
		vim.g.neovide_opacity = math.max(minimum_opacity, vim.g.neovide_opacity - opacity_interval)
	end)

	vim.keymap.set("n", "t0", function()
		vim.g.neovide_opacity = 1.0
	end)

	vim.keymap.set("n", "t-", function()
		vim.g.neovide_opacity = math.min(1.0, vim.g.neovide_opacity + opacity_interval)
	end)
end
