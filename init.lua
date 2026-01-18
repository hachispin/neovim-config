require("config.lazy")

-- use system clipboard
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
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

vim.lsp.config(
    'lua_ls',
    {settings = {Lua = {diagnostics = {globals = {"vim"}}}}}
)

vim.lsp.config(
    'rust_analyzer',
    {settings = {Rust = {checkOnSave = true, check = { enable = true, command = 'clippy'}}}}
)

-- easier split nav

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })


