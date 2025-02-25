local M = {}

M.config = function()
	lvim.plugins = {
		-- "nvim-treesitter/nvim-treesitter-angular",

		"tpope/vim-projectionist",
		"tpope/vim-abolish",
		"tpope/vim-dispatch",
		"tpope/vim-eunuch",
		"tpope/vim-unimpaired",
		"tpope/vim-surround",
		"tpope/vim-repeat",

		"wellle/targets.vim",
		"mbbill/undotree",
		"MattesGroeger/vim-bookmarks",
		"arcticicestudio/nord-vim",
		"junegunn/fzf",
		"fladson/vim-kitty",

		{
			"tpope/vim-fugitive",
			cmd = {
				"G",
				"Git",
				"Gdiffsplit",
				"Gvdiffsplit",
				"Gread",
				"Gwrite",
				"Ggrep",
				"GMove",
				"GDelete",
				"GBrowse",
				"GRemove",
				"GRename",
				"Glgrep",
				"Gedit",
			},
			ft = { "fugitive" },
		},

		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
			config = function()
				require("typescript-tools").setup({
					settings = {
						separate_diagnostic_server = true,
					},
				})
			end,
		},

		{
			"folke/trouble.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},

		{
			"jedrzejboczar/possession.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				config = function()
					require("telescope").load_extension("possession")
				end,
			},
			opts = {
				autosave = {
					current = true,
				},
				plugins = {
					delete_buffers = true,
				},
			},
		},

		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
		},

		{
			"nvimdev/lspsaga.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter", -- optional
				"nvim-tree/nvim-web-devicons", -- optional
			},
		},

		{
			"folke/flash.nvim",
			event = "VeryLazy",
		},

		{
			"nvim-pack/nvim-spectre",
			config = true,
		},

		{
			"tiagovla/scope.nvim",
			config = function()
				require("scope").setup({})
				require("telescope").load_extension("scope")
			end,
		},

		{
			"folke/todo-comments.nvim",
			config = true,
		},

		{
			"mxsdev/nvim-dap-vscode-js",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
			config = function()
				require("dap-vscode-js").setup({
					adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
				})
			end,
		},

		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
		},

		{
			"stevearc/oil.nvim",
			event = "VeryLazy",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		{
			"stevearc/aerial.nvim",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
		},

		{
			"Wansmer/treesj",
			event = "VeryLazy",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("treesj").setup({
					use_default_keymaps = false,
				})
			end,
		},

		{
			"molecule-man/telescope-menufacture",
			dependencies = {
				"nvim-telescope/telescope.nvim",
			},
			config = function()
				require("telescope").load_extension("menufacture")
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
			},
			lazy = true,
		},

		{
			"nacro90/numb.nvim",
			config = true,
		},

		{
			"kevinhwang91/nvim-bqf",
			event = { "BufRead", "BufNew" },
		},

		{
			"romgrk/nvim-treesitter-context",
		},

		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
		},

		{
			"pwntester/octo.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				"nvim-tree/nvim-web-devicons",
			},
			keys = {
				{ "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
			},
		},

		{
			"echasnovski/mini.move",
		},

		{
			"echasnovski/mini.indentscope",
			config = function()
				require("mini.indentscope").setup({
					symbol = "│",
				})
			end,
		},

		{
			url = "https://github.com/franckdelage/vim-test.git",
			dependencies = {
				"voldikss/vim-floaterm",
			},
		},

		{
			"iamcco/markdown-preview.nvim",
			cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
			ft = { "markdown" },
			build = function()
				vim.fn["mkdp#util#install"]()
			end,
		},

		-- lazy.nvim:
		{
			"smoka7/multicursors.nvim",
			event = "VeryLazy",
			dependencies = {
				"nvimtools/hydra.nvim",
			},
			opts = {},
			cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
			keys = {
				{
					mode = { "v", "n" },
					"<Leader>m",
					"<cmd>MCstart<cr>",
					desc = "Create a selection for selected text or word under the cursor",
				},
			},
		},

		{
			"mfussenegger/nvim-lint",
			event = { "BufReadPre", "BufNewFile" },
		},

		{
			"stevearc/conform.nvim",
			event = { "BufReadPre", "BufNewFile" },
		},

		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {},
			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		},

		{
			"epwalsh/obsidian.nvim",
			version = "*",
			event = {
				"BufReadPre " .. vim.fn.expand("~") .. "/Drive/SecondBrain/*.md",
				"BufNewFile " .. vim.fn.expand("~") .. "/Drive/SecondBrain/*.md",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},

		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
		},

		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy", -- Or `LspAttach`
			priority = 1000, -- needs to be loaded in first
			config = function()
				require("tiny-inline-diagnostic").setup()
			end,
		},

		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},

		{
			"saghen/blink.cmp",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"mikavilpas/blink-ripgrep.nvim",
			},
			version = "*",
			opts_extend = { "sources.default" },
		},

		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		{
			"kevinhwang91/nvim-ufo",
			dependencies = { "kevinhwang91/promise-async" },
		},
	}
end

return M
