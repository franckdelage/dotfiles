return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        numbers = 'none',
        indicator = {
          icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'icon',
        },
        name_formatter = function(buf)
          return buf.name
        end,
        truncate_names = false,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        -- get_element_icon = function(element)
        --   local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
        --   return icon, hl
        -- end,
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        separator_style = 'slant',
      },
    }

    vim.keymap.set('n', '<leader>bx', '<cmd>BufferLineCloseOthers<cr>', { desc = 'Close others' })
    vim.keymap.set('n', '<leader>bj', '<cmd>BufferLinePick<cr>', { desc = 'Pick' })
    vim.keymap.set('n', '<leader>be', '<cmd>BufferLinePickClose<cr>', { desc = 'Pick and close' })
  end,
}
