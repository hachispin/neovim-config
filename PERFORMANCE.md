# Performance

Documenting some performance tweaks I've done. Don't take this as
advice - I'm most definitely more clueless than you are about this.

## Benchmarking

The way I do benchmarks for startup time is by running this:

```zsh
#!/usr/bin/env zsh

set -euo pipefail

sum_times=0.0
num_iterations=25

for ((i = 0; i < num_iterations; i++)); do
	output=$(nvim --headless --startuptime /dev/stdout +q!)
	final_time=$(tail -n2 <<<"$output" | tr -d '\n' | cut -d ' ' -f1 | sed 's/^0*//')
	((sum_times += final_time))
done

echo $((sum_times / num_iterations))
```

This is a _biiit_ hacky. Zsh is used because Bash can't handle floating-points
and the ugly parsing is to get last line (when Neovim is done starting), remove
trailing newline, get accumulated time (first field) and remove trailing zeros.

I could've just used `hyperfine` but this _should_ be more accurate.

## Lazy-loading

Before attempting to lazy-load any plugins:

Initial startup time: ~46.5ms
For reference, clean: ~4.5ms

In order to set-up lazy-loading with `vim.pack`, I read echasnovski's (creator of `mini.nvim`) guide
([here](https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack#lazy-loading)) and used the
`mini.misc` plugin. Some easy targets were `nvim-autopairs` (event) and `tiny-inline-diagnostic`.

[This](https://fredrikaverpil.github.io/blog/2026/04/15/from-lazy.nvim-to-vim.pack/) also helped.

Afterwards: ~42.5ms

Very slight improvement. Maybe I should actually look at what's taking up all the time…

```bash
❯ nvim --headless --startuptime /dev/stdout +q 2>/dev/null | sort --numeric-sort --key 2n | tail -n10
```

Leads to this output:

```text
035.186  001.765  000.377: require('plugins.nvim-treesitter')
022.978  002.019  000.278: require('blink.cmp')
044.390  002.057: reading ShaDa
020.531  003.160  002.484: require('modules.unconfigured-plugins')
011.485  004.806  004.749: sourcing /home/rain/.local/share/nvim/site/pack/core/opt/everforest/colors/everforest.vim
033.345  005.099  004.520: require('plugins.lualine')
026.313  005.713  001.372: require('plugins.blink-cmp')
017.295  005.797  001.626: require('modules.lsp-setup')
011.492  006.634  001.174: require('modules.colorschemes')
037.275  034.168  000.930: sourcing /home/rain/.config/nvim/init.lua
```

So colorschemes, eh? Everforest by itself takes more time to load than clean Neovim…

∘ ∘ ∘ ( °ヮ° ) ?

Alright. Time to defer `blink.cmp` to `{"InsertEnter", "CmdLineEnter"}`. As for colorschemes,
the _active_ colorscheme will still be eagerly loaded, while everything else will just
be made lazy. This prevents sudden flashes (especially when using light mode) at startup.

Some other things I did was:

- switch everforest to a Lua port
- deleted shada (shared data) file

Afterwards: ~34.0ms

## Results

That's around a 31% improvement over the initial startup time I had, so
I'd say this went decently well. Still far from the sub 20ms dream though.

Something tells me this document is far from being done…
