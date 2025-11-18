local utils = require "lsp.utils"
local servers = require "lsp.servers.init"
local keymaps = require "lsp.keymaps"
local diagnostics = require "lsp.diagnostics"

local M = {}

function M.setup()
  -- Setup diagnostics
  diagnostics.setup()

  -- Setup keymaps and LspAttach autocmd
  keymaps.setup()

  -- Create autocmds for each server based on filetype
  for _, server_config in pairs(servers.servers) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = server_config.filetypes,
      callback = function(event)
        -- Check if this server is already running for this buffer
        local clients = vim.lsp.get_clients { bufnr = event.buf, name = server_config.name }
        if #clients == 0 then utils.start_lsp_server(server_config, event.buf) end
      end,
    })
  end

  -- Special handling for eslint - enable it explicitly
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.ts", "*.js", "*.tsx", "*.jsx", "*.html" },
    callback = function(event)
      local clients = vim.lsp.get_clients { bufnr = event.buf, name = "eslint" }
      if #clients == 0 then utils.start_lsp_server(servers.servers.eslint, event.buf) end
    end,
  })

  -- Create user commands
  vim.api.nvim_create_user_command("LspInfo", function()
    local buf_clients = vim.lsp.get_clients { bufnr = 0 }
    local all_clients = vim.lsp.get_clients()

    local lines = { "LSP client info for current buffer:", "" }

    if #buf_clients == 0 then
      table.insert(lines, "No LSP clients attached to this buffer")
    else
      for _, client in ipairs(buf_clients) do
        table.insert(lines, string.format("Client: %s (id %d)", client.name, client.id))
        table.insert(lines, string.format("  Root dir: %s", client.root_dir or "N/A"))
        table.insert(lines, "")
      end
    end

    table.insert(lines, "All active LSP clients:")
    table.insert(lines, "")
    if #all_clients == 0 then
      table.insert(lines, "No active LSP clients")
    else
      for _, client in ipairs(all_clients) do
        table.insert(lines, string.format("  %s (id %d)", client.name, client.id))
      end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "lspinfo"

    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      row = math.floor(vim.o.lines * 0.1),
      col = math.floor(vim.o.columns * 0.1),
      style = "minimal",
      border = "rounded",
    })

    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  end, { desc = "Show LSP client information" })

  vim.api.nvim_create_user_command("LspRestart", function()
    local buf = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_clients { bufnr = buf }

    if #buf_clients == 0 then
      vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
      return
    end

    -- Check if copilot was running
    local has_copilot = false
    for _, client in ipairs(buf_clients) do
      if client.name == "copilot" then
        has_copilot = true
        break
      end
    end

    local client_names = {}
    for _, client in ipairs(buf_clients) do
      table.insert(client_names, client.name)
    end

    -- Stop all clients
    for _, client in ipairs(buf_clients) do
      vim.lsp.stop_client(client.id)
    end

    vim.notify(string.format("Restarting LSP clients: %s", table.concat(client_names, ", ")), vim.log.levels.INFO)

    -- Restart servers for this buffer
    vim.schedule(function()
      local filetype = vim.bo[buf].filetype
      for _, server_config in pairs(servers.servers) do
        for _, ft in ipairs(server_config.filetypes) do
          if ft == filetype then
            utils.start_lsp_server(server_config, buf)
            break
          end
        end
      end

      -- Handle eslint specially if it's a relevant filetype
      if vim.tbl_contains({
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "html",
        "htmlangular",
      }, filetype) then utils.start_lsp_server(servers.servers.eslint, buf) end

      -- Restart copilot if it was running
      if has_copilot then vim.defer_fn(function() vim.cmd "Copilot enable" end, 100) end
    end)
  end, { desc = "Restart LSP clients for current buffer" })
end

return M
