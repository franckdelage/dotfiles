local M = {}

local function load_current_theme()
  if vim.uv.os_uname().sysname ~= "Linux" then
    return nil
  end

  local theme_path = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")
  if vim.fn.filereadable(theme_path) ~= 1 then
    return nil
  end

  local ok, theme_specs = pcall(dofile, theme_path)
  if not ok or type(theme_specs) ~= "table" then
    vim.notify("Could not load the active Omarchy Neovim theme", vim.log.levels.WARN)
    return nil
  end

  local colorscheme
  local theme_options
  local plugins = {}

  for _, spec in ipairs(theme_specs) do
    if type(spec) == "table" and spec[1] == "LazyVim/LazyVim" then
      theme_options = spec.opts or {}
      colorscheme = theme_options.colorscheme
    elseif type(spec) == "table" then
      table.insert(plugins, spec)
    end
  end

  if type(colorscheme) ~= "string" or #plugins == 0 then
    return nil
  end

  plugins[1].lazy = false
  plugins[1].priority = plugins[1].priority or 1000

  if colorscheme == "everforest" and theme_options.background then
    vim.g.everforest_background = theme_options.background
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    once = true,
    callback = function()
      local applied, err = pcall(vim.cmd.colorscheme, colorscheme)
      if not applied then
        vim.notify("Could not apply Omarchy Neovim colorscheme: " .. err, vim.log.levels.WARN)
      end
    end,
  })

  return {
    colorscheme = colorscheme,
    plugins = plugins,
  }
end

M.current = load_current_theme()

return M
