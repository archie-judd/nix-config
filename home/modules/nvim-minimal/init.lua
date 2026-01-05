local tmux = require("tmux")

tmux.setup({
	copy_sync = { enable = false },
	resize = {
		enable_default_keybindings = true,
		resize_step_x = 5,
		resize_step_y = 5,
	},
})

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
