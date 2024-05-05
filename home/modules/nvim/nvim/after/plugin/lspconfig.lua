local config = function()
	local autocommands = require("config.autocommands")
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lspconfig = require("lspconfig")
	local neodev = require("neodev")

	neodev.setup({})
	autocommands.lspconfig()

	local capabilities = cmp_nvim_lsp.default_capabilities()
	lspconfig.pyright.setup({ capabilities = capabilities })
	lspconfig.lua_ls.setup({ capabilities = capabilities })
	lspconfig.eslint.setup({ capabilities = capabilities })
	lspconfig.tsserver.setup({ capabilities = capabilities })
	lspconfig.marksman.setup({ capabilities = capabilities })
	lspconfig.bashls.setup({ capabilities = capabilities })
	lspconfig.nixd.setup({ capabilities = capabilities })

	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false })

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		silent = true,
		focusable = false,
		max_height = 15,
		max_width = 60,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		silent = true,
		focusable = false,
		max_height = 15,
		max_width = 65,
	})
end

config()
