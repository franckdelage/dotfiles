local M = {}

-- Lua language server
M.servers = {
  lua = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_patterns = { '.git', 'lua/' },
    name = 'lua_ls',
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (LuaJIT for Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize common globals
          globals = { 'vim', 'Snacks', 'reload', 'describe', 'it', 'before_each', 'after_each' },
          disable = {
            'missing-fields',
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            '${3rd}/luv/library',
            vim.fn.stdpath('data') .. '/lazy/snacks.nvim/lua',
            vim.fn.stdpath('config') .. '/lua',
          },
        },
        completion = {
          callSnippet = 'Replace',
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
}

return M
