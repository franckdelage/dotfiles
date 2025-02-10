local M = {}

M.config = function ()
  vim.g.maplocalleader = ","

  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.wrap = true
  vim.g.python_host_prog = '~/.pyenv/versions/2.7.18/bin/python2'
  vim.g.python3_host_prog = '~/.pyenv/versions/3.9.13/bin/python'
  vim.opt.conceallevel = 1

  -- use treesitter folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

	vim.opt.foldcolumn = "0" -- '0' is not bad
	vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
	vim.opt.foldlevelstart = 99
	vim.opt.foldenable = true
end

return M
