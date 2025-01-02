local M = {}

M.config = function ()
  require("blink.cmp").setup({
    keymap = {
      preset = 'default',
      ['<Enter>'] = { 'accept', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
    },
    completion = {
      menu = {
        border = 'rounded',
        draw = {
          padding = 2,
          treesitter = { "lsp" },
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name', gap = 2 } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = 'rounded' }
      },
      list = {
        selection = 'auto_insert',
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    snippets = {
      expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction) require('luasnip').jump(direction) end,
    },
    sources = {
      default = { 'lsp', 'path', 'luasnip', 'snippets', 'buffer' },
    },
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
  })
end

return M
