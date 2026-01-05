if vim.fn.has("nvim-0.10") == 1 then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
vim.opt.clipboard = "unnamedplus"

vim.keymap.set(
	"n",
	"<CR>",
	":noh <CR> <CR>",
	{ silent = true, noremap = true, desc = "Highlight: de-highlight and then press enter" }
)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { silent = true, noremap = true, desc = "Windows: select window to left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { silent = true, noremap = true, desc = "Windows: Select window to right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { silent = true, noremap = true, desc = "Windows: select window below" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { silent = true, noremap = true, desc = "Window: select window above" })
