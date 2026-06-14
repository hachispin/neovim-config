lazy_on_event("InsertEnter,CmdLineEnter" , function()
	vim.pack.add({ "https://github.com/saghen/blink.lib", "https://github.com/saghen/blink.cmp" })
	local cmp = require("blink.cmp")

	cmp.build():pwait()
	cmp.setup({
		completion = { documentation = { auto_show = false }, trigger = { show_on_blocked_trigger_characters = {} } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				lsp = {
					override = {
						get_trigger_characters = function(self)
							local trigger_characters = self:get_trigger_characters()
							vim.list_extend(trigger_characters, { "\n", "\t", " " })
							return trigger_characters
						end,
					},
				},
			},
		},
		fuzzy = { implementation = "rust" },
		signature = { enabled = true },
	})
end)
