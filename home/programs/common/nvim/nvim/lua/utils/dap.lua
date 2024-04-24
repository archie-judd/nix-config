local M = {}

---@param bufname string
---@return boolean
function M.is_bufname_repl_or_terminal(bufname)
	if string.find(bufname, "%[dap%-repl%]") == nil and string.find(bufname, "%[dap%-terminal%]") == nil then
		return false
	else
		return true
	end
end

function M.restart_in_correct_buf()
	local dap = require("dap")
	local bufname = vim.api.nvim_buf_get_name(0)
	local tabnr = vim.api.nvim_get_current_tabpage()
	if not M.is_bufname_repl_or_terminal(bufname) then
		dap.restart()
	else
		for i, win in ipairs(vim.fn.getwininfo()) do
			local bufname = vim.api.nvim_buf_get_name(win.bufnr)
			if not M.is_bufname_repl_or_terminal(bufname) and win.tabnr == tabnr then
				vim.api.nvim_set_current_win(win.winid)
				dap.restart()
			end
		end
	end
end

---@return boolean
function M.dap_is_active()
	return require("dap").status ~= ""
end

function M.debug_with_repl()
	local dap = require("dap")
	if not M.dap_is_active() then
		dap.terminate()
	end
	local repl_width = math.floor(vim.o.columns * 0.4)
	local wincmd = string.format("%svsplit new", repl_width)
	dap.continue()
	dap.repl.open({}, wincmd)
end

function M.debug_closest_test_with_repl()
	local dap = require("dap")
	local neotest = require("neotest")
	if not M.dap_is_active() then
		dap.terminate()
	end
	local repl_width = math.floor(vim.o.columns * 0.4)
	local wincmd = string.format("%svsplit new", repl_width)
	neotest.run.run({ strategy = "dap" })
	dap.repl.open({}, wincmd)
end

return M
