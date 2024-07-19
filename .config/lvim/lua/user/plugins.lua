local M = {}

M.config = function ()
  lvim.plugins = {
    "nvim-treesitter/nvim-treesitter-angular",

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
        "Gedit"
      },
      ft = { "fugitive" }
    },

    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
      config = function()
        require('typescript-tools').setup({
          settings = {
            separate_diagnostic_server = false,
          }
        })
      end
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
          delete_buffers = true
        }
      },
    },

    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
      },
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      config = function()
        require("noice").setup({
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
            progress = {
              enabled = false,
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = false,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = true,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
          },
          routes = {
            {
              view = "notify",
              filter = { event = "msg_showmode" }
            },
          },
        })
      end
    },

    {
      'nvimdev/lspsaga.nvim',
      config = function()
        require('lspsaga').setup({
          definition = {
            width = 0.8,
            height = 0.8,
          },
          symbol_in_winbar = {
            enable = false,
            show_file = false,
          },
          lightbulb = {
            enable = false,
          },
        })
      end,
      dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
      }
    },

    {
      "folke/flash.nvim",
      event = "VeryLazy",
      config = function()
        require('flash').setup({
          label = {
            min_pattern_length = 2,
            rainbow = {
              enabled = true,
              shade = 5
            },
          },
          modes = {
            search = {
              enabled = true,
            },
          },
        })
      end,
      keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "Z",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
      },
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
          adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        })
      end,
    },

    {
      "ThePrimeagen/harpoon",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        config = function()
          require("telescope").load_extension("harpoon")
        end,
      },
      config = function()
        require("harpoon").setup({
          global_settings = {
            save_on_toggle = false,
            save_on_change = true,
            enter_on_sendcmd = false,
            excluded_filetypes = { "harpoon" },
            mark_branch = false,
          },
        })
      end,
    },

    {
      "stevearc/oil.nvim",
      event = "VeryLazy",
      opts = {},
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("oil").setup({
          default_file_explorer = true,
          skip_confirm_for_simple_edits = true,
          view_options = {
            show_hidden = true,
            natural_order = true,
            is_always_hidden = function(name, _)
              return name == ".." or name == ".git"
            end,
          },
          win_options = {
            wrap = true,
          },
          float = {
            padding = 10,
          }
        })
      end,
    },

    {
      'stevearc/aerial.nvim',
      opts = {},
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
      },
      config = function()
        require("aerial").setup({
        })
      end,
    },

    {
      "Wansmer/treesj",
      event = "VeryLazy",
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        require('treesj').setup({
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
      config = function()
        require("nvim-treesitter.configs").setup({
          textobjects = {
            select = {
              enable = true,
              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
                ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
                ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
                ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

                ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
                ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

                ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
                ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

                ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
                ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

                ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
                ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

                ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
              },
            },
          },
        })
      end,
    },

    -- {
    --   "karb94/neoscroll.nvim",
    --   event = "WinScrolled",
    --   config = function()
    --     require('neoscroll').setup({
    --       mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
    --         '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    --       hide_cursor = true,
    --       stop_eof = true,
    --       use_local_scrolloff = false,
    --       respect_scrolloff = false,
    --       cursor_scrolls_alone = true,
    --       easing_function = "sine",
    --       pre_hook = nil,
    --       post_hook = nil,
    --     })
    --   end
    -- },

    {
      "nacro90/numb.nvim",
      config = true,
    },

    {
      "kevinhwang91/nvim-bqf",
      event = { "BufRead", "BufNew" },
      config = function()
        require("bqf").setup({
          auto_enable = true,
          preview = {
            win_height = 12,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
          },
          func_map = {
            vsplit = "<C-v>",
            ptogglemode = "z,",
            stoggleup = "",
          },
          filter = {
            fzf = {
              action_for = { ["ctrl-s"] = "split" },
              extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
            },
          },
        })
      end,
    },

    {
      "romgrk/nvim-treesitter-context",
      config = function()
        require("treesitter-context").setup {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
          trim_scope = 'outer',
        }
      end
    },

    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
    },

    {
      'pwntester/octo.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require "octo".setup({
          enable_builtin = true,
          default_remote = { "github", "origin" },
        })
        vim.cmd([[hi OctoEditable guibg=none]])
      end,
      keys = {
        { "<leader>O", "<cmd>Octo<cr>", desc = "Octo" },
      }
    },

    -- {
    --   "echasnovski/mini.animate",
    --   config = function()
    --     require("mini.animate").setup({
    --       scroll = { enable = false }
    --     })
    --   end,
    -- },

    {
      "echasnovski/mini.move",
      config = function()
        require("mini.move").setup({
          mappings = {
            left = '<M-H>',
            right = '<M-L>',
            down = '<M-J>',
            up = '<M-K>',
            line_left = '<M-H>',
            line_right = '<M-L>',
            line_down = '<M-J>',
            line_up = '<M-K>',
          },
          options = {
            reindent_linewise = true,
          },
        })
      end,
    },

    {
      "echasnovski/mini.indentscope",
      config = function()
        require("mini.indentscope").setup({
          symbol = "│"
        })
      end,
    },

    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/neotest-jest",
        "nvim-neotest/nvim-nio",
      },
      config = function()
        require('neotest').setup({
          adapters = {
            require("neotest-jest")({
              jestCommand = require('neotest-jest.jest-util').getJestCommand(vim.fn.expand '%:p:h') .. ' --watch --coverage false',
              jestConfigFile = function(file)
                if string.find(file, "/libs|apps/") then
                  return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
                end

                return vim.fn.getcwd() .. "/jest.config.ts"
              end,
            }),
          }
        })
      end
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
      build = function() vim.fn["mkdp#util#install"]() end,
    },

    -- lazy.nvim:
    {
      "smoka7/multicursors.nvim",
      event = "VeryLazy",
      dependencies = {
        'nvimtools/hydra.nvim',
      },
      opts = {},
      cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
      keys = {
        {
          mode = { 'v', 'n' },
          '<Leader>m',
          '<cmd>MCstart<cr>',
          desc = 'Create a selection for selected text or word under the cursor',
        },
      },
    }

  }
end

return M
