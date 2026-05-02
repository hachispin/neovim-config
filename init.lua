-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = "."

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

require("lazy").setup({
	spec = { { import = "plugins" } },
	install = { colorscheme = { "gruvbox-material" } },
	checker = { enabled = true },
})

vim.opt.shiftwidth = 4 -- amount to shift (<</>>)
vim.opt.tabstop = 4 -- size of tab
vim.o.relativenumber = true -- lines numbers shown relative to the cursor
vim.o.undofile = true -- save undo history to file for persistence
vim.o.smartcase = true -- case-insensitive search unless search includes uppercase characters
vim.o.updatetime = 300 -- makes events more responsive (300ms)
vim.o.scrolloff = 10 -- keep 10 lines above and below cursor
vim.diagnostic.enable = true -- enable diagnostics... duh
vim.diagnostic.config({ -- show warnings as extra ("virtual") lines
	virtual_lines = true,
})

-- shut up lua
vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

-- easier split nav (even though i don't use it)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- switching buffers with <-,.->
vim.keymap.set("n", "<leader>,", function()
	vim.cmd.bp()
end, { desc = "Move to previous buffer" })

vim.keymap.set("n", "<leader>.", function()
	vim.cmd.bn()
end, { desc = "Move to next buffer" })

-- view diagnostic
vim.keymap.set("n", "<leader>v", function()
	vim.diagnostic.open_float()
end)

-- yank/put with/from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank to end of line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Put from system clipboard (after)" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Put from system clipboard (before)" })

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
