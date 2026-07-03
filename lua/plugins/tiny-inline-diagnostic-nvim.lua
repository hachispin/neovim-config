local opts = {
	-- Choose a preset style for diagnostic appearance
	-- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
	preset = "powerline", -- NOTE: Overridden!

	-- "powerline" preset but with less padding on arrow
	signs = {
		arrow = "  ",
		up_arrow = "",
		right = "",
		left = "",
	},

	blend = { factor = 0.22 },

	-- Customize highlight groups for colors
	-- Use Neovim highlight group names or hex colors like "#RRGGBB"
	hi = {
		-- NOTE: This is visually for Neovide's normal opacity.
		background = "Normal", -- Background highlight for diagnostics
	},
	options = {
		-- Display the diagnostic code of diagnostics (e.g., "F401", "no-dupe-args")
		show_code = false,

		-- Use icons from vim.diagnostic.config instead of preset icons
		use_icons_from_diagnostic = true,

		-- Color the arrow to match the severity of the first diagnostic
		set_arrow_to_diag_color = true,

		-- Throttle update frequency in milliseconds to improve performance.
		-- Higher values reduce CPU usage but may feel less responsive.
		-- Set to 0 for immediate updates (may cause lag on slow systems).
		throttle = 20,

		-- Control how diagnostic messages are displayed
		--
		-- NOTE: When using display_count = true, you need to enable multiline
		-- diagnostics with multilines.enabled = true If you want them to
		-- always be displayed, you can also set multilines.always_show = true.
		add_messages = {
			display_count = true, -- Show diagnostic count instead of messages when cursor not on line
		},

		-- Settings for multiline diagnostics.
		multilines = {
			enabled = true, -- Enable support for multiline diagnostic messages
		},

		-- Show all diagnostics on the current cursor line, not just those under the cursor.
		show_all_diags_on_cursorline = true,

		-- Display related diagnostics from LSP relatedInformation.
		show_related = { enabled = false },

		-- Custom function to format diagnostic messages
		--
		-- Receives diagnostic object, returns formatted string
		--
		-- Example:
		--
		-- function(diag)
		--     return diag.message .. " [" .. diag.source .. "]"
		-- end
		format = function(diag) -- Trim to "summary"
			local regex = "^[^\r\n]+"

			-- Add more stuff here
			if #vim.lsp.get_clients({ bufnr = 0, name = "clangd" }) > 0 then
				regex = regex .. ";"
			end

			return diag.message:match(regex) or diag.message
		end,

		-- Automatically disable diagnostics when opening diagnostic float windows
		override_open_float = true,
	},
}

lazy_later(function()
	-- TODO: Unpin this once an option is added to remove virtual line usage
	-- (the thing that pushes lines down and is quite disruptive… and was
	-- the reason I even used this plugin over native Neovim diagnostics).
	vim.pack.add({
		{
			src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
			version = "e930d0a46031645040d5492595b46cdf6ab3514f",
		},
	})

	require("tiny-inline-diagnostic").setup(opts)
end)
