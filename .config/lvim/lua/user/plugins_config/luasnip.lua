local M = {}

M.config = function ()
  local ls = require "luasnip"
  local types = require "luasnip.util.types"

  -- TODO: Think about `locally_jumpable`, etc.
  -- Might be nice to send PR to luasnip to use filters instead for these functions ;)

  vim.snippet.expand = ls.lsp_expand

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.snippet.active = function(filter)
    filter = filter or {}
    filter.direction = filter.direction or 1

    if filter.direction == 1 then
      return ls.expand_or_jumpable()
    else
      return ls.jumpable(filter.direction)
    end
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  vim.snippet.jump = function(direction)
    if direction == 1 then
      if ls.expandable() then
        return ls.expand_or_jump()
      else
        return ls.jumpable(1) and ls.jump(1)
      end
    else
      return ls.jumpable(-1) and ls.jump(-1)
    end
  end

  vim.snippet.stop = ls.unlink_current

  -- ================================================
  --      My Configuration
  -- ================================================
  ls.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    override_builtin = true,
    store_selection_keys = "<Tab>",
    enable_autosnippets = true,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "<-", "Error"} },
        },
      },
    },
  }

  for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/user/snippets/*.lua", true)) do
    loadfile(ft_path)()
  end

  vim.keymap.set({ "i", "s" }, "<c-k>", function()
    return vim.snippet.active { direction = 1 } and vim.snippet.jump(1)
  end, { silent = true })

  vim.keymap.set({ "i", "s" }, "<c-j>", function()
    return vim.snippet.active { direction = -1 } and vim.snippet.jump(-1)
  end, { silent = true })

  vim.keymap.set({ "i" }, "<c-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })
end

return M
