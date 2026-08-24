local parsers = {
  "bash",
  "c",
  "diff",
  "dart",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  "typescript",
  "tsx",
  "javascript",
  "json",
  "graphql",
  "css",
  "scss",
  "sql",
  "toml",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function() require("nvim-treesitter").install(parsers):wait(300000) end,
    config = function()
      -- Parsers are installed only when the plugin is installed or updated. Normal startup
      -- only enables highlighting for available parsers.
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Enable Treesitter highlighting when a parser is available",
        group = vim.api.nvim_create_augroup("PersonalTreesitter", { clear = true }),
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
