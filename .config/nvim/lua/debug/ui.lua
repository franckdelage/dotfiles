-- DAP UI and Virtual Text configuration
local M = {}

function M.setup_ui(dap, dapview)
  ---@module 'dap-view'
  ---@type dapview.Config
  dapview.setup {
    winbar = {
      controls = {
        enabled = true,
      },
    },
    windows = {
      size = 0.3,
    },
    auto_toggle = true,
  }

  -- Setup virtual text
  require('nvim-dap-virtual-text').setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
    ---@diagnostic disable-next-line: unused-local
    display_callback = function(variable, _buf, _stackframe, _node, options)
      if options.virt_text_pos == 'inline' then
        return ' = ' .. variable.value
      else
        return variable.name .. ' = ' .. variable.value
      end
    end,
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
  }
end

function M.setup_icons()
  -- Change breakpoint icons
  vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
  vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
  local breakpoint_icons = vim.g.have_nerd_font
      and { Breakpoint = '●', BreakpointCondition = '◉', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '▶' }
    or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
  for type, icon in pairs(breakpoint_icons) do
    local tp = 'Dap' .. type
    local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
  end
end

return M
