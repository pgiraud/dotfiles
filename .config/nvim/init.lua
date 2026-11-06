print("Hello Pierre! How are you doing today?")

-- Reuse existing Vim directories
vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/after"))
vim.opt.packpath = vim.opt.runtimepath:get()

-- Load existing Vim configuration for compatibility
vim.cmd("source ~/.vimrc")

vim.keymap.set("n", "<F2>", function()
    vim.opt.paste = not vim.opt.paste:get()
end, { desc = "Toggle paste mode" })

vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

vim.lsp.enable('ty')

-- Show diagnostic message directly (inline)
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
        source = "if_many",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
    },
})
