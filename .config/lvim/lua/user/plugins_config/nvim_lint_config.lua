local M = {}

M.config = function()
	local lint = require("lint")

	lint.linters_by_ft = {
		-- javascript = { "eslint" },
		-- typescript = { "eslint" },
		-- html = { "eslint" },
		-- htmlangular = { "eslint" },
		-- graphql = { "eslint" },
		css = { "stylelint" },
		scss = { "stylelint" },
		json = { "jsonlint" },
		jsonc = { "jsonlint" },
		lua = { "luacheck" },
	}

	local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
		group = lint_augroup,
		callback = function()
			lint.try_lint()
		end,
	})
end

return M
