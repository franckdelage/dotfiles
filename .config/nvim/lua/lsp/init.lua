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

  local augroup = vim.api.nvim_create_augroup('LspAutocmds', { clear = true })

  -- Create autocmds for each server based on filetype
  for _, server_config in pairs(servers.servers) do
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
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
    group = augroup,
    pattern = { "*.ts", "*.js", "*.tsx", "*.jsx", "*.html" },
    callback = function(event)
      local clients = vim.lsp.get_clients { bufnr = event.buf, name = "eslint" }
      if #clients == 0 then utils.start_lsp_server(servers.servers.eslint, event.buf) end
    end,
  })

  -- Autocmd to handle file renames in Oil
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = "OilActionsPost",
    callback = function(event)
      if event.data.actions[1].type == "move" then
        Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
      end
    end,
  })

  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  vim.api.nvim_create_autocmd("LspProgress", {
    group = augroup,
    ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
      if not client or type(value) ~= "table" then
        return
      end
      local p = progress[client.id]

      for i = 1, #p + 1 do
        if i == #p + 1 or p[i].token == ev.data.params.token then
          p[i] = {
            token = ev.data.params.token,
            msg = ("[%3d%%] %s%s"):format(
              value.kind == "end" and 100 or value.percentage or 100,
              value.title or "",
              value.message and (" **%s**"):format(value.message) or ""
            ),
            done = value.kind == "end",
          }
          break
        end
      end

      local msg = {} ---@type string[]
      progress[client.id] = vim.tbl_filter(function(v)
        return table.insert(msg, v.msg) or not v.done
      end, p)

      local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
      vim.notify(table.concat(msg, "\n"), "info", {
        id = "lsp_progress",
        title = client.name,
        opts = function(notif)
          notif.icon = #progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        end,
      })
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
end

return M
