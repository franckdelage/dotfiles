return {
  'chrisgrieser/nvim-origami',
  event = 'VeryLazy',
  opts = {
    useLspFoldsWithTreesitterFallback = { enabled = true },
    pauseFoldsOnSearch = true,
    foldtext = {
      enabled = true,
      lineCount = { template = ' 󰁂 %d ', hlgroup = 'MoreMsg' },
      diagnosticsCount = true,
      gitsignsCount = true,
    },
    autoFold = { enabled = false },
    foldKeymaps = { setup = true },
  },
}
-- vim: ts=2 sts=2 sw=2 et
