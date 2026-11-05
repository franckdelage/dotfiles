-- Simple Nx integration using Telescope and built-in terminal
-- More reliable than the nx.nvim plugin which has schema parsing issues

local function create_floating_terminal(cmd)
  -- Calculate floating window size (80% of screen)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Create floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Nx Command ',
    title_pos = 'center',
  })

  -- Start terminal in the buffer
  vim.fn.termopen(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.defer_fn(function()
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
          end
        end, 2000) -- Auto-close after 2 seconds if successful
      end
    end,
  })

  -- Set terminal mode
  vim.cmd 'startinsert'

  -- Add keybinding to close window
  vim.keymap.set('t', '<Esc>', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, desc = 'Close floating terminal' })

  vim.keymap.set('n', 'q', function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, desc = 'Close floating terminal' })
end

local function nx_graph()
  -- Open Nx dependency graph
  create_floating_terminal 'yarn nx graph'
end

local function nx_codegen()
  -- Run GraphQL codegen
  create_floating_terminal 'yarn graphql:generate'
end

local function nx_codegen_affected()
  -- Run GraphQL codegen for affected projects
  create_floating_terminal 'yarn graphql:generate-affected'
end

return {
  {
    "folke/snacks.nvim",
    keys = {
      { '<leader>nG', nx_graph, desc = 'Nx graph' },
      { '<leader>nc', nx_codegen, desc = 'GraphQL codegen' },
      { '<leader>nC', nx_codegen_affected, desc = 'GraphQL codegen affected' },
    },
  },
}
