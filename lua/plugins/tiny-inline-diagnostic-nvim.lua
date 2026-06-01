vim.pack.add({ "https://github.com/rachartier/tiny-inline-diagnostic.nvim" })

require("tiny-inline-diagnostic").setup({
	-- Choose a preset style for diagnostic appearance
	-- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
	preset = "powerline",

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

		-- Automatically disable diagnostics when opening diagnostic float windows
		override_open_float = true,
	},
})
