local config = function()
	local autocommands = require("config.autocommands")
	local dap = require("dap")
	local mappings = require("config.mappings")

	-- set defaults
	local terminal_height = math.floor(vim.o.lines * 0.3)
	dap.defaults.fallback.exception_breakpoints = "default"
	dap.defaults.fallback.terminal_win_cmd = string.format("below %ssplit new", terminal_height)
	dap.defaults.fallback.focus_terminal = true

	local debugger_path = vim.g.python3_host_prog
	local python_path = vim.fn.exepath("python") ~= "" and vim.fn.exepath("python") or vim.fn.exepath("python3") -- use the path for 'python', if it exists, else use the path for 'python3'

	dap.adapters["python"] = {
		type = "executable",
		command = debugger_path,
		args = { "-m", "debugpy.adapter" },
		options = {
			source_filetype = "python",
		},
	}
	dap.configurations["python"] = {
		{
			type = "python",
			request = "launch",
			name = "Launch file from workspace",
			program = "${file}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			pythonPath = python_path,
			env = { PYTHONPATH = "${workspaceFolder}" },
		},
	}

	-- typescript / javscript
	local js_debug_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = {
				js_debug_path,
				"${port}",
			},
		},
	}
	dap.configurations["typescript"] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch Current File (Typescript)",
			cwd = "${workspaceFolder}",
			program = "${file}",
			outFiles = { "${workspaceFolder}/**/**/*", "!**/node_modules/**" },
			skipFiles = { "<node_internals>/**", "node_modules/**" },
		},
	}
	mappings.dap()
	autocommands.dap()
end

config()