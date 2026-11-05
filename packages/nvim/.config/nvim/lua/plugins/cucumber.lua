return {
  {
    name = 'cucumber-setup',
    dir = vim.fn.stdpath 'config',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      -- File type detection for Gherkin/Cucumber files
      vim.filetype.add {
        extension = {
          feature = 'cucumber',
        },
        filename = {
          ['*.feature'] = 'cucumber',
        },
        pattern = {
          ['.*%.feature$'] = 'cucumber',
        },
      }

      -- Additional Gherkin/Cucumber file patterns
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.feature', '*.story' },
        callback = function()
          vim.bo.filetype = 'cucumber'
        end,
      })

      -- Cucumber-specific settings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cucumber',
        callback = function()
          vim.bo.commentstring = '# %s'
          vim.bo.shiftwidth = 2
          vim.bo.tabstop = 2
          vim.bo.softtabstop = 2
          vim.bo.expandtab = true
        end,
      })

      -- Custom syntax highlighting for Cucumber keywords
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cucumber',
        callback = function()
          vim.cmd 'syntax match cucumberKeyword /^\\s*\\(Feature\\|Background\\|Scenario\\|Scenario Outline\\|Examples\\|Given\\|When\\|Then\\|And\\|But\\):/'
          vim.cmd 'syntax match cucumberTag /@\\w\\+/'
          vim.cmd 'syntax match cucumberComment /^\\s*#.*/'
          vim.cmd 'syntax region cucumberDocString start=/"""/ end=/"""/'
          vim.cmd 'syntax region cucumberDataTable start=/^\\s*|/ end=/$/'

          vim.cmd 'highlight link cucumberKeyword Keyword'
          vim.cmd 'highlight link cucumberTag Tag'
          vim.cmd 'highlight link cucumberComment Comment'
          vim.cmd 'highlight link cucumberDocString String'
          vim.cmd 'highlight link cucumberDataTable Special'
        end,
      })
    end,
  },
}
