-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { colorscheme = { "gruvbox-material" } },
	checker = { enabled = true },
})

-- use system clipboard
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- preferences
vim.opt.shiftwidth = 4

-- useful stuff
vim.o.number = true
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 300
vim.o.scrolloff = 10
vim.o.showmode = false
vim.diagnostic.enable = true
vim.diagnostic.config({
	virtual_lines = true,
})

-- lsp stuff
vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

-- easier split nav
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- switching buffers
vim.keymap.set("n", "<leader>p", ":bp<CR>", { desc = "Move to previous buffer" })
vim.keymap.set("n", "<leader>n", ":bn<CR>", { desc = "Move to next buffer" })

-- lsp renaming but rename field is left blank, instead of having
-- the original name (which is annoying to edit since it's in cmdline)
vim.keymap.set("n", "<leader>r", function()
	vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
		callback = function()
			local key = vim.api.nvim_replace_termcodes("<C-u>", true, false, true)
			vim.api.nvim_feedkeys(key, "c", false)
			return true
		end,
	})
	vim.lsp.buf.rename()
end, { desc = "Rename current item under cursor with LSP" })
