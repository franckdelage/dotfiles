local M = {}

M.config = function ()
  require("dap").configurations["typescript"] = {
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
      type = "chrome",
      name = "Launch Chrome",
      request = "launch",
      url = "https://localhost.airfrance.fr/en",
    },
  }
end

return M
