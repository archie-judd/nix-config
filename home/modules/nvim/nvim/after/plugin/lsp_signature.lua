local function config()
	local lsp_signature = require("lsp_signature")
	lsp_signature.setup({ hint_prefix = "", toggle_key = "<C-k>" })
end

config()
