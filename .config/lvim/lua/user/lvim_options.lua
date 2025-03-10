local M = {}

M.config = function ()
  vim.diagnostic.config({ virtual_text = false, underline = true })

  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
  lvim.lsp.automatic_servers_installation = false
  
  lvim.builtin.bigfile.active = false

  lvim.builtin.cmp.active = false

  lvim.builtin.breadcrumbs.active = false

  lvim.colorscheme = "catppuccin-frappe"

  lvim.format_on_save.enabled = false

  lvim.builtin.treesitter.matchup.enable = true

  lvim.builtin.telescope.theme = "center"
  ---@diagnostic disable-next-line: unused-local
  lvim.builtin.telescope.defaults.path_display = function(opts, path)
    local tail = require("telescope.utils").path_tail(path)
    return string.format("%s (%s)", tail, path)
  end
  lvim.builtin.telescope.defaults.layout_strategy = "horizontal"
  lvim.builtin.telescope.defaults.sorting_strategy = "ascending"
  lvim.builtin.telescope.defaults.layout_config = {
    horizontal = {
      prompt_position = "top",
    },
  }

  lvim.builtin.project.patterns = { ".git" }

  lvim.builtin.bufferline.options.always_show_bufferline = true
  lvim.builtin.bufferline.options.truncate_names = false

  lvim.builtin.nvimtree.setup.view.width = 50

  lvim.builtin.indentlines.options.show_current_context = false

  lvim.transparent_window = true
end

return M
