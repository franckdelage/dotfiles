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

  -- Eagerly warm up angularls on first html buffer attach so the TypeScript
  -- project is loaded before the user makes their first real LSP request.
  -- Without this, the first go-to-definition takes 20-30s while the Angular
  -- compiler parses the entire monorepo tsconfig cold.
  local angular_warmed_up = false
  vim.api.nvim_create_autocmd('LspAttach', {
    group = augroup,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client or client.name ~= 'angularls' then return end
      local ft = vim.bo[event.buf].filetype
      if ft ~= 'html' and ft ~= 'htmlangular' then return end
      if angular_warmed_up then return end
      angular_warmed_up = true
      vim.defer_fn(function()
        local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
        local done = false
        vim.notify('Loading Angular project...', 'info', {
          id = 'angular_warmup',
          title = 'angularls',
          timeout = false,
          opts = function(notif)
            if done then
              notif.icon = ' '
            else
              notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end
          end,
        })
        client:request('textDocument/hover', {
          textDocument = { uri = vim.uri_from_bufnr(event.buf) },
          position = { line = 0, character = 0 },
        }, function()
          done = true
          vim.notify('Angular project ready', 'info', {
            id = 'angular_warmup',
            title = 'angularls',
            opts = function(notif)
              notif.icon = ' '
              notif.timeout = 2000
            end,
          })
        end, event.buf)
      end, 500)
    end,
  })

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
  -- NOTE: :lsp and :checkhealth vim.lsp are now built-in in Nvim 0.12
end

return M
