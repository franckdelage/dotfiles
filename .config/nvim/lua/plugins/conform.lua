local request_timeout_ms = 2000

local function is_typescript_buffer(bufnr)
  return vim.tbl_contains({
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
  }, vim.bo[bufnr].filetype)
end

local function get_client(bufnr, name) return vim.lsp.get_clients({ bufnr = bufnr, name = name })[1] end

local function notify_stage_error(stage, err)
  vim.notify(("%s failed: %s"):format(stage, tostring(err)), vim.log.levels.WARN)
end

local function execute_command(client, bufnr, command, stage)
  if type(command) == "string" then command = { command = command } end
  local response, err =
    client:request_sync("workspace/executeCommand", command, request_timeout_ms, bufnr)
  if not response then
    notify_stage_error(stage, err or "request timed out")
    return false
  end
  if response.err then
    notify_stage_error(stage, response.err.message or response.err)
    return false
  end
  return true
end

local function resolve_action(client, bufnr, action, stage)
  if action.edit or action.command or not action.data then return action end
  if not client:supports_method("codeAction/resolve", bufnr) then return action end

  local response, err = client:request_sync("codeAction/resolve", action, request_timeout_ms, bufnr)
  if not response then
    notify_stage_error(stage, err or "resolve timed out")
    return action
  end
  if response.err then
    notify_stage_error(stage, response.err.message or response.err)
    return action
  end
  return response.result or action
end

local function apply_code_action(bufnr, client_name, kind, diagnostics, stage)
  local client = get_client(bufnr, client_name)
  if not client then return false end

  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  params.context = {
    only = { kind },
    diagnostics = diagnostics or {},
  }

  local response, err =
    client:request_sync("textDocument/codeAction", params, request_timeout_ms, bufnr)
  if not response then
    notify_stage_error(stage, err or "request timed out")
    return false
  end
  if response.err then
    notify_stage_error(stage, response.err.message or response.err)
    return false
  end

  for _, candidate in ipairs(response.result or {}) do
    local candidate_kind = candidate.kind or ""
    if candidate_kind == kind or vim.startswith(candidate_kind, kind .. ".") then
      local action = resolve_action(client, bufnr, candidate, stage)
      if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding) end
      if action.command then execute_command(client, bufnr, action.command, stage) end
      return true
    end
  end
  return false
end

local function run_eslint(bufnr)
  local client = get_client(bufnr, "eslint")
  if not client then return end

  local applied = apply_code_action(
    bufnr,
    "eslint",
    "source.fixAll.eslint",
    vim.diagnostic.get(bufnr),
    "ESLint fix"
  )
  if not applied then
    execute_command(client, bufnr, {
      command = "eslint.executeAutofix",
      arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
    }, "ESLint fix")
  end
end

local function run_typescript_actions(bufnr)
  if not is_typescript_buffer(bufnr) then return end
  apply_code_action(bufnr, "vtsls", "source.addMissingImports.ts", {}, "Add missing imports")
  apply_code_action(bufnr, "vtsls", "source.removeUnused.ts", {}, "Remove unused imports")
end

local function run_stylelint(bufnr)
  if not vim.tbl_contains({ "css", "scss", "sass" }, vim.bo[bufnr].filetype) then return end

  local client = get_client(bufnr, "stylelint_lsp")
  if not client then return end
  local response, err = client:request_sync(
    "textDocument/formatting",
    vim.lsp.util.make_formatting_params {},
    request_timeout_ms,
    bufnr
  )
  if not response then
    notify_stage_error("Stylelint format", err or "request timed out")
    return
  end
  if response.err then
    notify_stage_error("Stylelint format", response.err.message or response.err)
    return
  end
  vim.lsp.util.apply_text_edits(response.result or {}, bufnr, client.offset_encoding)
end

local function run_conform(bufnr)
  local ok, formatted = pcall(require("conform").format, {
    async = false,
    lsp_format = "fallback",
    bufnr = bufnr,
  })
  if not ok or formatted == false then notify_stage_error("Conform format", formatted) end
end

local function fix_and_format()
  local bufnr = vim.api.nvim_get_current_buf()
  run_eslint(bufnr)
  run_typescript_actions(bufnr)
  run_stylelint(bufnr)
  run_conform(bufnr)
end

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lf",
        fix_and_format,
        mode = "",
        desc = "Fix all (ESLint + TS + Stylelint + Format)",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        html = { "eslint", "prettierd" },
        htmlangular = { "eslint", "prettierd" },
        css = { "prettierd", "prettier", stop_after_first = true },
        dart = { "dart_format" },
        scss = { "prettierd", "prettier", stop_after_first = true },
        graphql = { "prettierd", "prettier", stop_after_first = true },
        json = { "jq" },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        yaml = { "prettierd" },
      },
    },
  },
}
