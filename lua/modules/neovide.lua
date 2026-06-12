if not vim.g.neovide then
	return
end

-- Font settings
-- Some font settings are in Neovide's config.toml
vim.g.neovide_text_gamma = 0.8
vim.g.neovide_text_contrast = 0.5

-- Window settings
vim.g.neovide_scale_factor = 1.0
--vim.g.neovide_padding_top = 12
vim.g.neovide_refresh_rate = 120 -- only applies if --no-vsync is passed

-- Cursor settings
vim.g.neovide_cursor_cell_color_fallback = true
--[[
	vim.g.neovide_cursor_animation_length = 0.1
    vim.g.neovide_cursor_trail_size = 0.3
	vim.g.neovide_scroll_animation_length = 0.3
	--]]

-- Idle can cause some issues
vim.g.neovide_no_idle = true

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
--
-- normal_opacity is used instead of opacity because some
-- glyphs don't render well (e.g., powerline dividers).
--
-- All this complexity is mainly from CursorLine being
-- fully opaque when setting normal_opacity. I have to sync
-- it with normal_opacity so it doesn't look disgusting.

local function sync_opacity_cursorline()
	local blend = math.floor((1 - vim.g.neovide_normal_opacity) * 100)
	vim.cmd.highlight({ "CursorLine", "blend=" .. blend })
end

local function add_opacity(interval)
	if interval == 0 then
		return
	end

	local new_opacity = vim.g.neovide_normal_opacity + interval

	if interval > 0 then
		vim.g.neovide_normal_opacity = math.min(1.0, new_opacity)
	else
		vim.g.neovide_normal_opacity = math.max(0.5, new_opacity)
	end

	sync_opacity_cursorline()
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		sync_opacity_cursorline()
	end,
})

vim.g.neovide_normal_opacity = 1.0
local interval = 0.05

vim.keymap.set("n", "<leader>t=", function()
	add_opacity(interval)
end)

vim.keymap.set("n", "<leader>t0", function()
	add_opacity(1.0)
end)

vim.keymap.set("n", "<leader>t-", function()
	add_opacity(-interval)
end)
