return {
	"saghen/blink.cmp",
	dependencies = {
		"saghen/blink.lib",
		"rafamadriz/friendly-snippets",
	},
	build = function()
		-- build the fuzzy matcher, wait up to 60 seconds
		-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
		require("blink.cmp").build():wait(60000)
	end,

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = { preset = "default" },
		completion = {
			documentation = { auto_show = false },
			trigger = { show_on_insert = true, show_on_backspace = true },
		},
		sources = { default = { "lsp", "path", "snippets", "buffer" } },
		fuzzy = { implementation = "rust" },
		signature = { enabled = true },
	},
}
