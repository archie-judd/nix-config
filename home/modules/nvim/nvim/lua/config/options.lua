vim.wo.number = true
vim.wo.relativenumber = true
vim.o.splitright = true
vim.o.clipboard = "unnamedplus"
vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,preview"
vim.o.shortmess = "c" -- 'c' means 'don't show ins-completion mode messages'
vim.o.laststatus = 3 -- only one statusline
vim.cmd.colorscheme("catppuccin-mocha")
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" }) -- fix oil background
