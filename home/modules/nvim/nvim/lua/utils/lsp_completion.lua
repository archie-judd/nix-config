local M = {}

---@return integer | nil
function M.get_signature_help_bufnr()
	for i, buf in ipairs(vim.fn.getwininfo()) do
		if buf.variables["textDocument/signatureHelp"] ~= nil then
			return buf.bufnr
		end
	end
	return nil
end

---@param bufnr integer
---@param lsp_method string
---@return boolean
function M.buf_supports_lsp_method(bufnr, lsp_method)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.supports_method(lsp_method) then
			return true
		end
	end
	return false
end

---@param bufnr integer
function M.buf_supports_lsp_omnifunc(bufnr)
	return vim.bo[bufnr].omnifunc == "v:lua.vim.lsp.omnifunc"
end

---@param error table|nil
---@param result Result | Params | nil
---@param ctx table
---@param config table
function M.signature_help_handler(error, result, ctx, config)
	config = vim.tbl_extend("force", config or {}, {
		close_events = { "InsertLeave", "CursorMoved" },
	})
	local existing_buf = M.get_signature_help_bufnr()
	local buf, win = vim.lsp.handlers["textDocument/signatureHelp"](error, result, ctx, config)
	if buf == nil and existing_buf ~= nil then -- if no signature help was returned, delete any existing signature help
		vim.api.nvim_buf_delete(existing_buf, { force = true })
	end
end

---@param bufnr integer
function M.signature_help(bufnr)
	if M.buf_supports_lsp_method(bufnr, "textDocument/signatureHelp") then
		local params = vim.lsp.util.make_position_params()
		vim.lsp.buf_request(bufnr, "textDocument/signatureHelp", params, M.signature_help_handler)
	end
end

---@param bufnr int
function M.turn_persistent_signature_help_on(bufnr)
	if M.buf_supports_lsp_method(bufnr, "textDocument/signatureHelp") then
		require("config.autocommands").signature_help(bufnr)
		M.signature_help(bufnr)
	end
end

function M.turn_persistent_signature_help_off()
	local signature_help_bufnr = M.get_signature_help_bufnr()
	if signature_help_bufnr ~= nil then
		vim.api.nvim_buf_delete(signature_help_bufnr, { force = true })
	end
	vim.api.nvim_del_augroup_by_name("PersistentSignatureHelp")
end

-- A function for toggling persistent signature help.
---@param bufnr integer
function M.toggle_persistent_signature_help(bufnr)
	if vim.g.persistent_signature_help == true then
		M.turn_persistent_signature_help_off()
		vim.g.persistent_signature_help = false
	else
		M.turn_persistent_signature_help_on(bufnr)
		vim.g.persistent_signature_help = true
	end
end

---@param bufnr integer
function M.toggle_persistent_autocomplete(bufnr)
	if vim.g.persistent_autocomplete == true then
		local cmp = require("cmp")
		if cmp.visible() == true then
			cmp.abort()
		end
		vim.g.persistent_autocomplete = false
	else
		vim.g.persistent_autocomplete = true
	end
end

return M
