vim.wo.number = true
vim.wo.relativenumber = true
vim.o.splitright = true
vim.o.clipboard = "unnamedplus"
vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,preview"
vim.o.shortmess = "ltToCcF"
vim.o.directory = "."
vim.g.persistent_autocomplete = true
vim.g.persistent_signature_help = true
vim.cmd.colorscheme("catppuccin-mocha")
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" }) -- fix oil background
