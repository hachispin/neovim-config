-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = "."

-- lazy setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { colorscheme = { "nordic" } },
	checker = { enabled = true },
})

-- ui 2 and nightly neovim stuff
require("vim._core.ui2").enable()
--

vim.o.shiftwidth = 4 -- amount to shift (<</>>)
vim.o.tabstop = 4 -- visual size of tab (in spaces)
vim.o.showmode = false -- don't show mode (e.g, INSERT) because i use lualine
vim.o.relativenumber = true -- lines numbers shown relative to the cursor

-- show line number (with relative enabled, this shows the line number
-- of the current line you're on, which would otherwise just be "0")
vim.o.number = true

-- case-insensitive search unless search includes uppercase characters
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undofile = true -- save undo history to file for persistence
vim.o.updatetime = 300 -- makes events more responsive (300ms)
vim.o.scrolloff = 10 -- keep 10 lines above and below cursor
vim.o.cmdheight = 0 -- hide cmdline when not being used
vim.diagnostic.enable(true) -- enable diagnostics (though it should be on by default)
vim.diagnostic.config({ -- show warnings as extra ("virtual") lines
	virtual_lines = true,
})

-- partial cmds with cmdheight=0
vim.o.showcmd = true
vim.o.showcmdloc = "statusline"
--

-- shut up lua
vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
--

-- easier split nav, <C-[hjkl]>
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
--

-- switching buffers with <-,.->
vim.keymap.set("n", "<leader>,", function()
	vim.cmd.bp()
end, { desc = "Move to previous buffer" })

vim.keymap.set("n", "<leader>.", function()
	vim.cmd.bn()
end, { desc = "Move to next buffer" })
--

-- view diagnostic
vim.keymap.set("n", "<leader>v", function()
	vim.diagnostic.open_float()
end)
--

-- yank/put with/from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to end of line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Put from system clipboard (after)" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Put from system clipboard (before)" })
--

-- lsp rename (note: must run :wa after)
vim.keymap.set("n", "<leader>r", function()
	-- clear rename field (hacky)
	vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
		callback = function()
			local key = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
			vim.api.nvim_feedkeys(key, "c", false)
			return true
		end,
	})

	vim.lsp.buf.rename()
end, { desc = "Rename current item under cursor with LSP" })
--

-- black background toggle, mostly for better looks when setting transparency --
-- courtesy of chatgpt so like 50% chance of being slop
local groups = {
	"Normal",
	"NormalNC",
	"SignColumn",
	"EndOfBuffer",
}

local saved = {}
local enabled = false

for _, group in ipairs(groups) do
	saved[group] = vim.api.nvim_get_hl(0, { name = group })
end

vim.keymap.set("n", "<leader>b", function()
	enabled = not enabled

	for _, group in ipairs(groups) do
		if enabled then
			local hl = saved[group]

			vim.api.nvim_set_hl(0, group, {
				fg = hl.fg,
				bg = "#000000",
			})
		else
			vim.api.nvim_set_hl(0, group, saved[group])
		end
	end
end)
--

-- neovide specific things (i've betrayed TUIs)
if vim.g.neovide then
	-- vim.o.guifont = "Monaspace Xenon:h14" -- set in config.toml
	vim.g.neovide_text_gamma = 0.9
	vim.g.neovide_text_contrast = 0.1

	-- window settings --
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_padding_top = 12
	vim.g.neovide_refresh_rate = 120 -- only applies if --no-vsync is passed

	-- cursor settings --
	vim.g.neovide_cursor_cell_color_fallback = true
	--[[
	vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_trail_size = 0.3
	vim.g.neovide_scroll_animation_length = 0.3
	--]]

	-- zooming implementation --
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

	-- transparency controls (note: future self may want vim.g.neovide_normal_opacity) --
	local opacity_interval = 0.05
	local minimum_opacity = 0.5
	vim.g.neovide_opacity = 1.0

	vim.keymap.set("n", "t+", function()
		vim.g.neovide_opacity = math.max(minimum_opacity, vim.g.neovide_opacity - opacity_interval)
	end)

	vim.keymap.set("n", "t-", function()
		vim.g.neovide_opacity = math.min(1.0, vim.g.neovide_opacity + opacity_interval)
	end)
	--
end
