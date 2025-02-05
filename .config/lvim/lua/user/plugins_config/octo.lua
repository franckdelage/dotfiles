local M = {}

M.config = function()
	require("octo").setup({
		enable_builtin = true,
		default_remote = { "github", "origin" },
		suppress_missing_scope = {
			projects_v2 = true,
		},
	})
	vim.cmd([[hi OctoEditable guibg=none]])
end

return M
