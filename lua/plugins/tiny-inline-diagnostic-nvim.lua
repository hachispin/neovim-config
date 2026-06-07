vim.pack.add({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })

require("tiny-inline-diagnostic").setup({
	-- Choose a preset style for diagnostic appearance
	-- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
	preset = "powerline",

	-- Make diagnostic background transparent
	transparent_bg = false,

	options = {
		-- Display the source of diagnostics (e.g., "lua_ls", "pyright")
		show_source = {
			enabled = false, -- Enable showing source names
			if_many = true, -- Only show source if multiple sources exist for the same diagnostic
		},

		-- Display the diagnostic code of diagnostics (e.g., "F401", "no-dupe-args")
		show_code = false,

		-- Color the arrow to match the severity of the first diagnostic
		set_arrow_to_diag_color = true,

		-- Throttle update frequency in milliseconds to improve performance
		-- Higher values reduce CPU usage but may feel less responsive
		-- Set to 0 for immediate updates (may cause lag on slow systems)
		throttle = 0,

		-- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
		--       If you want them to always be displayed, you can also set multilines.always_show = true.
		--
		-- Control how diagnostic messages are displayed
		add_messages = {
			messages = true, -- Show full diagnostic messages
			display_count = true, -- Show diagnostic count instead of messages when cursor not on line
			use_max_severity = false, -- When counting, only show the most severe diagnostic
			show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
		},

		-- Settings for multiline diagnostics
		multilines = {
			enabled = true, -- Enable support for multiline diagnostic messages
			always_show = false, -- Always show messages on all lines of multiline diagnostics
			trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
			tabstop = 4, -- Number of spaces per tab when expanding tabs
			severity = nil, -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
		},

		-- Show all diagnostics on the current cursor line, not just those under the cursor
		show_all_diags_on_cursorline = true,

		-- Display related diagnostics from LSP relatedInformation
		show_related = { enabled = false },

		-- Custom function to format diagnostic messages
		-- Receives diagnostic object, returns formatted string
		-- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
		format = function(diag) -- Trim to one line
			return diag.message:match("^[^\r\n]+") or diag
		end,

		-- Automatically disable diagnostics when opening diagnostic float windows
		override_open_float = true,
	},
})
