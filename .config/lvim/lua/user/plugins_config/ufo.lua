local M = {}

M.config = function()
  vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
  vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
  vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
  vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

	require("ufo").setup({
		open_fold_hl_timeout = 150,
		close_fold_kinds_for_ft = {
			default = { "imports", "comment" },
			json = { "array" },
			c = { "comment", "region" },
		},
		preview = {
			win_config = {
				border = { "", "─", "", "", "", "─", "", "" },
				winhighlight = "Normal:Folded",
				winblend = 0,
			},
			mappings = {
				scrollU = "<C-u>",
				scrollD = "<C-d>",
				jumpTop = "[",
				jumpBot = "]",
			},
		},
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
	})
end

return M
