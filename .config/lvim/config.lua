-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


------------------------------------------------------------------------------------------------------------
-- SETTINGS
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.g.python_host_prog = '~/.pyenv/versions/2.7.18/bin/python2'
vim.g.python3_host_prog = '~/.pyenv/versions/3.9.13/bin/python'

vim.g['test#javascript#runner'] = 'nx'
vim.g['test#strategy'] = 'floaterm'

------------------------------------------------------------------------------------------------------------
-- DISABLED CORE PLUGINS
lvim.builtin.breadcrumbs.active = false

------------------------------------------------------------------------------------------------------------
-- KEYBINDINGS
lvim.keys.insert_mode["jk"] = "<esc>"
lvim.keys.normal_mode["tg"] = "gT"

lvim.lsp.buffer_mappings.normal_mode["gd"] = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" }
lvim.lsp.buffer_mappings.normal_mode["gD"] = { "<cmd>Lspsaga goto_definition<cr>", "Go to definition" }
lvim.lsp.buffer_mappings.normal_mode["gy"] = { "<cmd>Lspsaga goto_type_definition<cr>", "Go to type definition" }
lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation" }
lvim.lsp.buffer_mappings.normal_mode["gl"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diagnostic" }
lvim.lsp.buffer_mappings.normal_mode["gL"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Next diagnostic" }

lvim.lsp.buffer_mappings.normal_mode["gj"] = { function() require("flash").jump() end, "Flash" }
lvim.lsp.buffer_mappings.normal_mode["<leader>,"] = { function() require("flash").jump() end, "Flash" }

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

lvim.builtin.which_key.mappings["gf"] = {
  "<cmd>Git<cr>", "Fugitive"
}

-- LSP
lvim.builtin.which_key.mappings["lm"] = {
  "<cmd>TSToolsAddMissingImports<cr>", "Missing Imports"
}
lvim.builtin.which_key.mappings["lu"] = {
  "<cmd>Telescope lsp_references<cr>", "References"
}
lvim.builtin.which_key.mappings["lx"] = {
  "<cmd>TSToolsRemoveUnusedImports<cr>", "Unused Imports"
}

lvim.builtin.which_key.mappings["bx"] = {
  "<cmd>BufferLineCloseOthers<cr>", "Close others"
}

lvim.builtin.which_key.mappings["v"] = {
  name = "Projectionist",
  t = { "<cmd>Vtemplate<cr>", "Template" },
  c = { "<cmd>Vcomponent<cr>", "Component" },
  s = { "<cmd>Vspec<cr>", "Spec" },
  a = { "<cmd>Vscss<cr>", "Stylesheet" },
}

lvim.builtin.which_key.mappings["t"] = {
  name = "Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
  c = { "<cmd>TroubleClose<cr>", "Close" },
}

lvim.builtin.which_key.mappings["y"] = {
  name = "LSP Saga",
  d = { "<cmd>Lspsaga peek_definition<cr>", "Peek Definition" },
  D = { "<cmd>Lspsaga goto_definition<cr>", "Go to Definition" },
  y = { "<cmd>Lspsaga goto_type_definition<cr>", "Go to type Definition" },
  h = { "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation" },
  a = { "<cmd>Lspsaga code_action<cr>", "Code Actions" },
  e = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Diagnostic Next" },
  E = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Diagnostic Previous" },
  t = { "<cmd>Lspsaga term_toggle<cr>", "Terminal" },
  r = { "<cmd>Lspsaga rename<cr>", "Rename symbol" },
}

lvim.builtin.which_key.mappings["f"] = {
  "<cmd>lua require('telescope').extensions.menufacture.git_files()<cr>", "Switch branch"
}

lvim.builtin.which_key.mappings["s"] = {
  name = "Search",
  B = { "<cmd>Telescope git_branches<cr>", "Switch branch" },
  b = { "<cmd>Telescope scope buffers<cr>", "Buffers" },
  c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
  f = { "<cmd>lua require('telescope').extensions.menufacture.find_files()<cr>", "Find File" },
  g = { "<cmd>lua require('telescope').extensions.menufacture.git_files()<cr>", "Git Files" },
  z = { "<cmd>lua require('telescope').extensions.menufacture.grep_string()<cr>", "Find string under cursor" },
  h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
  H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
  M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
  r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
  R = { "<cmd>Telescope registers<cr>", "Registers" },
  t = { "<cmd>lua require('telescope').extensions.menufacture.live_grep()<cr>", "Text" },
  k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
  C = { "<cmd>Telescope commands<cr>", "Commands" },
  l = { "<cmd>Telescope resume<cr>", "Resume last search" },
  s = { "<cmd>Telescope possession list<cr>", "Sessions" },
  p = {
    "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
    "Colorscheme with Preview",
  },
}

lvim.builtin.which_key.mappings["a"] = {
  name = "Flash and Aerial",
  s = { function() require("flash").jump() end, "Flash jump" },
  t = { function() require("flash").treesitter() end, "Flash Treesitter" },
  r = { function() require("flash").treesitter_search() end, "Flash Treesitter Search" },
  e = { function() require("flash").treesitter_search() end, "Flash Remote" },
  a = { "<cmd>AerialToggle<cr>", "Aerial Toggle" },
}

lvim.builtin.which_key.mappings["r"] = {
  name = "Spectre",
  t = { "<cmd>lua require('spectre').toggle()<cr>", "Toggle Spectre" },
  s = { "<cmd>lua require('spectre').open_visual({ select_word = true })<cr>", "Search current word" },
  v = { "<cmd>lua require('spectre').open_visual()<cr>", "Search visual" },
  r = { "<cmd>lua require('spectre').open_file_search({ select_word = true })<cr>", "Search on current file" },
}

lvim.builtin.which_key.mappings["o"] = {
  name = "Harpoon",
  m = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Toggle mark" },
  n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Next mark" },
  p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Previous mark" },
  s = { "<cmd>Telescope harpoon marks<cr>", "Search marks" },
}

lvim.builtin.which_key.mappings["k"] = {
  name = "Test",
  n = { "<cmd>TestNearest<cr>", "Nearest" },
  f = { "<cmd>TestFile<cr>", "File" },
  s = { "<cmd>TestSuite<cr>", "Suite" },
  l = { "<cmd>TestLast<cr>", "Last" },
  c = { "<cmd>TestClass<cr>", "Class" },
  v = { "<cmd>TestVisit<cr>", "Visit" },
}

function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
		return text
	else
		return ''
	end
end


local keymap = vim.keymap.set
local tb = require('telescope.builtin')
local opts = { noremap = true, silent = true }

keymap('n', '<space>z', ':Telescope current_buffer_fuzzy_find<cr>', opts)
keymap('v', '<space>z', function()
	local text = vim.getVisualSelection()
	tb.current_buffer_fuzzy_find({ default_text = text })
end, opts)

keymap('n', '<space>G', ':Telescope live_grep<cr>', opts)
keymap('v', '<space>G', function()
	local text = vim.getVisualSelection()
	tb.live_grep({ default_text = text })
end, opts)

------------------------------------------------------------------------------------------------------------
-- OPTIONS
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tsserver" })
lvim.lsp.automatic_servers_installation = false
lvim.colorscheme = "catppuccin-frappe"
lvim.format_on_save.enabled = false
lvim.builtin.telescope.theme = "ivy"
lvim.builtin.treesitter.matchup.enable = true
---@diagnostic disable-next-line: unused-local
lvim.builtin.telescope.defaults.path_display = function(opts, path)
  local tail = require("telescope.utils").path_tail(path)
  return string.format("%s (%s)", tail, path)
end

lvim.builtin.project.patterns = { ".git" }

lvim.builtin.bufferline.options.always_show_bufferline = true
lvim.builtin.bufferline.options.truncate_names = false

lvim.builtin.nvimtree.setup.view.width = 50

lvim.builtin.indentlines.options.show_current_context = false

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    name = "eslint_d",
    filetypes = { "typescript", "javascript", "html" }
  },
  { name = "stylelint" },
}

local code_actions = require "lvim.lsp.null-ls.code_actions"
code_actions.setup {
  {
    name = "eslint_d",
    filetypes = { "typescript", "javascript", "html" }
  },
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "eslint_d" },
  -- { name = "prettierd" },
}


------------------------------------------------------------------------------------------------------------
-- ANGULAR
require("lvim.lsp.manager").setup("angularls")
local util = require('lspconfig.util')

-- local project_library_path = "/Users/franckdelage/Developer/bw-blueweb"
local angularls_library_path = "~/.nvm/versions/node/v20.12.1/lib/node_modules"
-- local angularls_library_path = "/Users/franckdelage/.local/share/lvim/mason/packages/angular-language-server/node_modules/@angular/language-server/node_modules/@angular/language-service"
local cmd = { "ngserver", "--stdio", "--tsProbeLocations", angularls_library_path, "--ngProbeLocations", angularls_library_path }

require 'lspconfig'.angularls.setup {
  cmd = cmd,
  root_dir = util.root_pattern('angular.json', 'nx.json'),
  on_new_config = function(new_config)
    new_config.cmd = cmd
  end,
}

-- local util = require 'lspconfig/util'

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
-- This defaults to the vim cwd, but will get overwritten by the resolved root of the file.
-- local function get_probe_dir(root_dir)
--   local project_root = util.find_node_modules_ancestor(root_dir)

--   return project_root and (project_root .. '/node_modules') or ''
-- end

-- local default_probe_dir = get_probe_dir(vim.fn.getcwd())

-- require 'lspconfig'.angularls.setup {
--   cmd = {
--     'angularls',
--     '--stdio',
--     '--tsProbeLocations', default_probe_dir,
--     '--ngProbeLocations', default_probe_dir
--   };
--   filetypes = {'typescript', 'html', 'typescriptreact', 'typescript.tsx'};
--   -- Check for angular.json or .git first since that is the root of the project.
--   -- Don't check for tsconfig.json or package.json since there are multiple of these
--   -- in an angular monorepo setup.
--   root_dir = util.root_pattern('nx.json', 'angular.json', '.git');
--   on_new_config = function(new_config, new_root_dir)
--     local new_probe_dir = get_probe_dir(new_root_dir)

--     -- We need to check our probe directories because they may have changed.
--     new_config.cmd = {
--       'angularls',
--       '--stdio',
--       '--tsProbeLocations', new_probe_dir,
--       '--ngProbeLocations', new_probe_dir
--     }
--   end
-- }

-- END ANGULAR

require("lspconfig").emmet_language_server.setup({})

require("lvim.lsp.manager").setup("graphql-lsp")
require 'lspconfig'.graphql.setup {
  cmd = { "graphql-lsp", "server", "-m", "stream" },
  filetypes = { "graphql", "graphql.ts" },
  root_dir = util.root_pattern('.git', '.graphqlconfig'),
}

require("dap").configurations["typescript"] = {
  {
    type = "pwa-chrome",
    name = "Attach - Remote Debugging",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
  {
    type = "pwa-chrome",
    name = "Launch Chrome",
    request = "launch",
    url = "https://localhost.airfrance.fr/en",
  },
}

------------------------------------------------------------------------------------------------------------
-- PLUGINS
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
      require("dap-vscode-js").setup({
        global_settings = {
          save_on_toggle = false,
          save_on_change = true,
          enter_on_sendcmd = false,
          excluded_filetypes = { "harpoon" },
          mark_branch = true,
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

}
