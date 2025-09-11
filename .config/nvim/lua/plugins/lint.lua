return {
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        css = { 'stylelint' },
        scss = { 'stylelint' },
        json = { 'jsonlint' },
        jsonc = { 'jsonlint' },
        lua = { 'luacheck' },
      }

      -- Modify the default markdownlint configuration to use our config file
      local markdownlint = lint.linters.markdownlint
      if markdownlint then
        markdownlint.args = vim.list_extend({
          '--config', vim.fn.expand('~/.config/markdownlint/config.json')
        }, markdownlint.args or {})
      end

      lint.linters.luacheck = {
        cmd = "luacheck",
        name = "luacheck",
        stdin = true,
        args = {
          "--globals",
          "vim",
          "lvim",
          "Snacks",
          "reload",
          "--",
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
          source = "luacheck",
        }),
      }

      -- Debug function
      vim.api.nvim_create_user_command('LintDebug', function()
        print("Available linters for markdown:", vim.inspect(lint.linters_by_ft.markdown))
        print("Markdownlint config:", vim.inspect(lint.linters.markdownlint))
        print("Current buffer filetype:", vim.bo.filetype)
        lint.try_lint()
      end, {})

      -- Create autocommand which carries out the actual linting
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
