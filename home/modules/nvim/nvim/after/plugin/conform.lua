local config = function()
	local conform = require("conform")
	conform.setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { { "prettierd" } },
			typescript = { { "prettierd" } },
			json = { { "prettierd" } },
			yaml = { { "prettierd" } },
			markdown = { { "prettierd" } },
			sh = { { "shfmt" } },
			nix = { { "nixfmt" } },
		},
		formatters = {
			black = {
				prepend_args = { "--preview" },
			},
		},
	})
end

config()