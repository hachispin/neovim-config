-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Leader key
vim.g.mapleader = " "

-- General
vim.o.confirm = true
vim.o.inccommand = "split"
vim.o.mouse = "a"
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 200

-- Visual adjustments
require("vim._core.ui2").enable()
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.showbreak = "󱞵 "
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.winborder = vim.g.neovide and "solid" or "rounded"

-- Line numbers (relative)
vim.o.number = true
vim.o.relativenumber = true

-- Less annoying searching
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
	virtual_lines = false,
	virtual_text = false,

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌶",
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

-- Display diagnostic window on hover
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float({
			focus = false,
			source = "if_many",
		})
	end,
})

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
--
-- remap=true is needed for glimmer highlights to work.
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("n", "<leader>Y", '"+Y', { remap = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { remap = true })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { remap = true })
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

-- Restore old cursor position when opening buffers
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") or ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
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

-- For lazy loading
vim.pack.add({ "https://github.com/nvim-mini/mini.misc" })
local misc = require("mini.misc")

_G.lazy_later = function(f)
	misc.safely("later", f)
end

_G.lazy_on_event = function(ev, f)
	misc.safely("event:" .. ev, f)
end

-- HACK: Relative path shenanigans
local choice_to_path = { ["init"] = "../init" }
local choices = { "init" }

-- Auto require plugins and modules
for _, dir in ipairs({ "modules", "plugins" }) do
	local path = vim.fn.stdpath("config") .. "/lua/" .. dir .. "/"

	for _, file in ipairs(vim.fn.glob(path .. "*.lua", false, true)) do
		local basename = vim.fs.basename(file)
		local filename = basename:sub(1, basename:len() - 4)
		choice_to_path[filename] = dir .. "/" .. filename
		choices[#choices + 1] = filename
		require(dir .. "." .. filename)
	end
end

vim.api.nvim_create_user_command("Cfg", function(opts)
	local config = vim.fn.stdpath("config")
	local prefix = config .. "/lua/"

	if opts.args == "" then
		vim.cmd.cd(config)
		return
	end

	for _, choice in ipairs(opts.fargs) do
		if not vim.tbl_contains(choices, choice) then
			vim.notify("Invalid option: " .. choice, vim.log.levels.ERROR)
			return
		end

		local relpath = choice_to_path[choice] .. ".lua"
		vim.cmd.e(prefix .. relpath)
	end
end, {
	nargs = "*",
	complete = function()
		return choices
	end,
})

-- Colorscheme is set in modules/colorschemes.lua
