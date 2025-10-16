-- Alternatively, use `config = function() ... end` for full control over the configuration.
-- If you prefer to call `setup` explicitly, use:
--    {
--        'lewis6991/gitsigns.nvim',
--        config = function()
--            require('gitsigns').setup({
--                -- Your gitsigns configuration here
--            })
--        end,
--    }
--
-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`.
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- signs = {
      --   add = { text = '+' },
      --   change = { text = '~' },
      --   delete = { text = '_' },
      --   topdelete = { text = '‾' },
      --   changedelete = { text = '~' },
      -- },
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git change' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git change' })

        -- Actions
        -- visual mode
        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage hunk' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset hunk' })
        -- normal mode
        map('n', '<leader>gq', gitsigns.setqflist, { desc = 'Send to quickfix' })
        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
        map('n', '<leader>ghu', gitsigns.stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>gba', gitsigns.blame, { desc = 'Blame buffer' })
        map('n', '<leader>gbb', gitsigns.blame_line, { desc = 'Blame line' })
        map('n', '<leader>gbB', function() require('gitsigns').blame_line { full = true } end, { desc = 'Blame line full' })
        map('n', '<leader>gbt', gitsigns.toggle_current_line_blame, { desc = 'Toggle git show blame line' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff against index' })
        map('n', '<leader>gD', function() gitsigns.diffthis '@' end, { desc = 'Diff against last commit' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
