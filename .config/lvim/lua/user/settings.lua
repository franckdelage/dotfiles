local M = {}

M.config = function ()
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.wrap = true
  vim.g.python_host_prog = '~/.pyenv/versions/2.7.18/bin/python2'
  vim.g.python3_host_prog = '~/.pyenv/versions/3.9.13/bin/python'
end

return M
