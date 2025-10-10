return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'mikavilpas/blink-ripgrep.nvim',
  },
  version = '*',
  opts_extend = { 'sources.default' },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
  end,
  opts = {
    keymap = {
      preset = 'default',
      ['<Enter>'] = { 'accept', 'fallback' },
      ['<C-e>'] = { 'cancel', 'fallback' },
      ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-s>'] = {
        function()
          require('blink.cmp').show { providers = { 'snippets' } }
        end,
      },
      ['<c-d>'] = {
        function()
          require('blink.cmp').show { providers = { 'lsp' } }
        end,
      },
      ['<c-t>'] = {
        function()
          require('blink.cmp').show { providers = { 'ripgrep' } }
        end,
      },
    },
    cmdline = {
      enabled = true,
      completion = {
        menu = {
          auto_show = true,
        },
        ghost_text = {
          enabled = false,
        },
      },
    },
    completion = {
      menu = {
        auto_show = function(ctx)
          return not vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype())
        end,
        border = 'rounded',
        draw = {
          padding = 2,
          treesitter = { 'lsp' },
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name', gap = 2 } },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        window = { border = 'rounded' },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono',
    },
    snippets = {
      preset = 'luasnip',
      expand = function(snippet)
        require('luasnip').lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require('luasnip').jumpable(filter.direction)
        end
        return require('luasnip').in_snippet()
      end,
      jump = function(direction)
        require('luasnip').jump(direction)
      end,
    },
    sources = {
      default = { 'snippets', 'lsp', 'path', 'buffer' },
      providers = {
        ripgrep = {
          module = 'blink-ripgrep',
          name = 'Ripgrep',
          ---@module "blink-ripgrep"
          ---@type blink-ripgrep.Options
          opts = {
            project_root_marker = { '.git', 'nx.json' },
          },
        },
      },
    },
    signature = {
      enabled = false,
      window = {
        border = 'rounded',
        show_documentation = false,
      },
    },
    fuzzy = {
      sorts = {
        'score',
        'kind',
        'sort_text',
      },
    },
  },
}
