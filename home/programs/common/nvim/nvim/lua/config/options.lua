vim.opt.splitright = true
vim.opt.clipboard = "unnamed"
vim.opt.pumheight = 10
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.completeopt = "menuone,noinsert,preview"
vim.o.shortmess = "ltToCcF"
vim.g.persistent_autocomplete = true
vim.g.persistent_signature_help = true
vim.cmd.colorscheme("catppuccin-mocha")
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" }) -- fix oil background
