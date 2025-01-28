local M = {}

M.config = function()
	local dap = require("dap")

	dap.adapters.chrome = {
		type = "executable",
		command = "node",
		args = { "/Users/franckdelage/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
	}

	dap.configurations.typescript = {
		{
			type = "chrome",
			name = "Attach - Remote Debugging",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			name = "Chrome - launch localhost.airfrance.fr",
			type = "chrome",
			request = "launch",
			url = "https://localhost.airfrance.fr",
			webRoot = "${workspaceFolder}",
		},
		{
			name = "Chrome - launch localhost.klm.nl",
			type = "chrome",
			request = "launch",
			url = "https://localhost.klm.nl",
			webRoot = "${workspaceFolder}",
		},
		{
			name = "GraphQL Server - attach debugger",
			type = "node",
			port = 9221,
			skipFiles = { "node_modules/**" },
			request = "attach",
		},
	}
end

return M
