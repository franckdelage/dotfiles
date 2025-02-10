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

  vim.api.nvim_create_autocmd('BufRead', {
    callback = function()
      vim.cmd[[ silent! foldclose! ]]
      local bufnr = vim.api.nvim_get_current_buf()
      -- make sure buffer is attached
      vim.wait(100, function() require'ufo'.attach(bufnr) end)
      if require'ufo'.hasAttached(bufnr) then
        local winid = vim.api.nvim_get_current_win()
        local method = vim.wo[winid].foldmethod
        if method == 'diff' or method == 'marker' then
          require'ufo'.closeAllFolds()
          return
        end
        -- getFolds returns a Promise if providerName == 'lsp', use vim.wait in this case
        local ok, ranges = pcall(require'ufo'.getFolds, bufnr, 'treesitter')
        if ok and ranges then
          if require'ufo'.applyFolds(bufnr, ranges) then
            require'ufo'.openAllFolds()
          end
        end
      end
    end
  })
end

return M
