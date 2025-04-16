local M = {}

M.config = function()
  local Snacks = require("snacks")

  lvim.keys.insert_mode["jk"] = "<esc>"
  lvim.keys.normal_mode["tg"] = "gT"

  lvim.lsp.buffer_mappings.normal_mode["gd"] = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" }
  lvim.lsp.buffer_mappings.normal_mode["gD"] = { "<cmd>Lspsaga goto_definition<cr>", "Go to definition" }
  lvim.lsp.buffer_mappings.normal_mode["gy"] = { "<cmd>Lspsaga goto_type_definition<cr>", "Go to type definition" }
  lvim.lsp.buffer_mappings.normal_mode["K"] = {
    function ()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.cmd("Lspsaga hover_doc")
      end
    end,
    "Hover Documentation"
  }
  lvim.lsp.buffer_mappings.normal_mode["gl"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diagnostic" }
  lvim.lsp.buffer_mappings.normal_mode["gL"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Previous diagnostic" }
  lvim.lsp.buffer_mappings.normal_mode["gb"] = { "<cmd>Lspsaga show_buf_diagnostics<cr>", "Buffer diagnostics" }
  lvim.lsp.buffer_mappings.normal_mode["gc"] = { "<cmd>Lspsaga show_cursor_diagnostics<cr>", "Cursor diagnostics" }
  lvim.lsp.buffer_mappings.normal_mode["gw"] =
  { "<cmd>Lspsaga show_workspace_diagnostics<cr>", "Workspace diagnostics" }
  lvim.lsp.buffer_mappings.normal_mode["]]"] = {
    function()
      Snacks.words.jump(vim.v.count1)
    end,
    "Next reference",
  }
  lvim.lsp.buffer_mappings.normal_mode["[["] = {
    function()
      Snacks.words.jump(-vim.v.count1)
    end,
    "Previous reference",
  }

  lvim.lsp.buffer_mappings.normal_mode["gj"] = {
    function()
      require("lua.user.plugins_config.flash").jump()
    end,

  }
  lvim.lsp.buffer_mappings.normal_mode["<leader>,"] = {
    function()
      require("lua.user.plugins_config.flash").jump()
    end,
    "Flash",
  }

  -- vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
  vim.keymap.set("n", "-", function() require("oil").open_float() end, { desc = "Open parent directory" })

  lvim.builtin.which_key.mappings["c"] = {
    function()
      Snacks.bufdelete()
    end,
    "Close buffer",
  }

  lvim.builtin.which_key.mappings["W"] = {
    "<cmd>wall<cr>",
    "Save all",
  }

  lvim.builtin.which_key.mappings["X"] = {
    "<cmd>xall<cr>",
    "Save all and quit",
  }

  lvim.builtin.which_key.mappings[";"] = {
    "<cmd>checkt<cr>",
    "Checktime",
  }

  lvim.builtin.which_key.mappings["Lw"] = {
    "<cmd>tabe ~/dotfiles/.wezterm.lua<cr>",
    "Wezterm Config",
  }

  lvim.builtin.which_key.mappings["Ls"] = {
    name = "Snippets",
    {
      r = { "<cmd>source ~/.config/lvim/lua/user/snippets/snippets.lua<cr>", "Reload snippets" },
      e = { "<cmd>vs ~/dotfiles/.config/lvim/lua/user/snippets/snippets.lua<cr>", "Edit snippets" },
    },
  }

  -- Git
  lvim.builtin.which_key.mappings["g"] = {
    name = "Git",
    -- g = { "<cmd>lua require 'lvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
    g = {
      function()
        Snacks.lazygit()
      end,
      "Lazygit",
    },
    L = {
      function()
        Snacks.lazygit.log()
      end,
      "Full log",
    },
    l = {
      function()
        Snacks.lazygit.log_file()
      end,
      "Log file",
    },
    B = {
      function()
        Snacks.gitbrowse()
      end,
      "Browse",
    },
    f = { "<cmd>Git<cr>", "Fugitive" },
    h = { "<cmd>Octo pr list<cr>", "List Pull Requests" },
    a = { "<cmd>Git blame<cr>", "Blame all file" },
    j = { "<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>", "Prev Hunk" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
    o = { function () Snacks.picker.git_status() end, "Status" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = { "<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Git Diff" },
    b = {
      name = "Blame",
      l = {
        function()
          Snacks.git.blame_line()
        end,
        "Snacks Blame",
      },
      b = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
      B = { "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", "Blame Line (full)" },
    },
  }

  -- LSP
  lvim.builtin.which_key.mappings["l"] = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { function () Snacks.picker.diagnostics_buffer() end, "Buffer Diagnostics" },
    w = { function () Snacks.picker.diagnostics() end, "Diagnostics" },
    f = {
      function()
        if vim.bo.filetype == 'typescript' then
          vim.cmd("EslintFixAll")
        elseif vim.bo.filetype == "htmlangular" then
          vim.lsp.buf.format()
          require("conform").format({})
        -- elseif vim.bo.filetype == "scss" then
        --   vim.lsp.buf.format()
        else
          require("conform").format({})
        end
      end,
      "Format",
    },
    i = { "<cmd>LspInfo<cr>", "Info" },
    I = { "<cmd>Mason<cr>", "Mason Info" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
    l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { function () Snacks.picker.lsp_symbols() end, "Document Symbols" },
    S = {
      function () Snacks.picker.lsp_workspace_symbols() end,
      "Workspace Symbols",
    },
    e = { function () Snacks.picker.qflist() end, "Telescope Quickfix" },
    u = { function () Snacks.picker.lsp_references() end, "References" },
    m = { "<cmd>TSToolsAddMissingImports<cr>", "Missing Imports" },
    x = { "<cmd>TSToolsRemoveUnusedImports<cr>", "Unused Imports" },
    c = {
      function()
        require("lint").try_lint()
      end,
      "Trigger Nvim linting",
    },
  }

  lvim.builtin.which_key.mappings["bx"] = {
    "<cmd>BufferLineCloseOthers<cr>",
    "Close others",
  }

  lvim.builtin.which_key.mappings["bp"] = {
    "<cmd>BufferLineTogglePin<cr>",
    "Toggle Pin",
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
    f = { "<cmd>Lspsaga finder<cr>", "Finder" },
  }

  lvim.builtin.which_key.mappings["f"] = {
    "<cmd>lua require('telescope').extensions.menufacture.git_files()<cr>",
    "Find Git file",
  }

  -- Telescope

  lvim.builtin.which_key.mappings["f"] = { function () Snacks.picker.git_files() end, "Find Git files" }

  lvim.builtin.which_key.mappings["s"] = {
    name = "Search",
    c = { function () Snacks.picker.colorschemes() end, "Colorscheme" },
    f = { "<cmd>lua require('telescope').extensions.menufacture.find_files()<cr>", "Find File" },
    z = { "<cmd>lua require('telescope').extensions.menufacture.grep_string()<cr>", "Find string under cursor" },
    h = { function () Snacks.picker.help() end, "Find Help" },
    H = { function () Snacks.picker.highlights() end, "Find highlight groups" },
    M = { function () Snacks.picker.man() end, "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    t = { "<cmd>lua require('telescope').extensions.menufacture.live_grep()<cr>", "Text" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { function () Snacks.picker.commands() end, "Commands" },
    l = { "<cmd>Telescope resume<cr>", "Resume last search" },
    -- s = { "<cmd>Telescope possession list theme=ivy<cr>", "Sessions" },
    s = { "<cmd>SessionSearch<cr>", "Sessions" },
    ["/"] = { function () Snacks.picker.search_history() end, "Search history" },
    p = {
      "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },
    g = {
      name = "Git",
      g = { "<cmd>lua require('telescope').extensions.menufacture.git_files()<cr>", "Git Files" },
      c = { "<cmd>Telescope git_bcommits<cr>", "Commit for buffer" },
      b = { "<cmd>Telescope git_branches<cr>", "Switch branch" },
    },
    q = {
      name = "Quickfix",
      q = { "<cmd>Telescope quickfix<cr>", "QuickFix" },
      h = { "<cmd>Telescope quickfixhistory<cr>", "QuickFix History" },
    },
    b = {
      name = "Buffers",
      s = { function () Snacks.picker.buffers({ hidden = true }) end, "All Buffers" },
      b = { function () Snacks.picker.buffers() end, "Tab's Buffers" },
      f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
    },
  }

  lvim.builtin.which_key.mappings["a"] = {
    name = "Flash and Aerial",
    s = { function() require("flash").jump() end, "Flash jump", },
    t = { function() require("flash").treesitter() end, "Flash Treesitter", },
    r = { function() require("flash").treesitter_search() end, "Flash Treesitter Search", },
    e = { function() require("flash").remote() end, "Flash Remote", },
    a = { "<cmd>AerialToggle<cr>", "Aerial Toggle" },
    j = { function() require("aerial").snacks_picker({
      layout = {
        preset = "dropdown",
        preview = false,
      },
    }) end, "Aerial Jump", },
  }

  lvim.builtin.which_key.mappings["r"] = {
    name = "Spectre",
    t = { "<cmd>lua require('spectre').toggle()<cr>", "Toggle Spectre" },
    s = { "<cmd>lua require('spectre').open_visual({ select_word = true })<cr>", "Search current word" },
    v = { "<cmd>lua require('spectre').open_visual()<cr>", "Search visual" },
    r = { "<cmd>lua require('spectre').open_file_search({ select_word = true })<cr>", "Search on current file" },
  }

  local harpoon = require("harpoon")
  lvim.builtin.which_key.mappings["o"] = {
    name = "Harpoon",
    a = {
      function()
        harpoon:list():add()
      end,
      "Add to list",
    },
    d = {
      function()
        harpoon:list():remove()
      end,
      "Remove from list",
    },
    n = {
      function()
        harpoon:list():next()
      end,
      "Next mark",
    },
    p = {
      function()
        harpoon:list():prev()
      end,
      "Previous mark",
    },
    m = {
      function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      "Toggle list",
    },
    t = { "<cmd>Telescope harpoon marks<cr>", "Search marks" },
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

  lvim.builtin.which_key.mappings["n"] = {
    name = "Obsidian",
    n = { "<cmd>ObsidianNewFromTemplate<cr>", "New note" },
    t = { "<cmd>ObsidianTags<cr>", "Tags" },
    e = { "<cmd>ObsidianExtractNote<cr>", "Extract into note" },
    r = { "<cmd>ObsidianRename<cr>", "Rename" },
    q = { "<cmd>ObsidianQuickSwitch<cr>", "Switch" },
    s = { "<cmd>ObsidianSearch<cr>", "Search" },
    d = { "<cmd>ObsidianDailies<cr>", "Dailies" },
    l = {
      name = "Links",
      {
        l = { "<cmd>ObsidianLink<cr>", "Link to a note" },
        b = { "<cmd>ObsidianBacklinks<cr>", "Search back links" },
        f = { "<cmd>ObsidianFollowLink<cr>", "Follow note link" },
      },
    },
  }

  lvim.builtin.which_key.mappings["u"] = {
    name = "Snacks",
    z = {
      function()
        Snacks.toggle.zen():toggle()
      end,
      "Zen mode",
    },
    o = {
      function()
        Snacks.toggle.zoom():toggle()
      end,
      "Zoom",
    },
    n = {
      function()
        Snacks.notifier.show_history()
      end,
      "Notification history",
    },
    d = {
      function()
        Snacks.toggle.dim():toggle()
      end,
      "Dim",
    },
    g = {
      function()
        Snacks.lazygit()
      end,
      "Lazygit",
    },
    s = {
      function()
        Snacks.scratch()
      end,
      "Scratch",
    },
    S = {
      function()
        Snacks.scratch.select()
      end,
      "Scratch select",
    },
    j = {
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      "Next reference",
    },
    k = {
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      "Previous reference",
    },
  }

  function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
      return text
    else
      return ""
    end
  end

  local keymap = vim.keymap.set
  local tb = require("telescope.builtin")
  local opts = { noremap = true, silent = true }

  keymap("n", "<space>z", ":Telescope current_buffer_fuzzy_find<cr>", opts)
  keymap("v", "<space>z", function()
    local text = vim.getVisualSelection()
    tb.current_buffer_fuzzy_find({ default_text = text })
  end, opts)

  keymap("n", "<space>G", ":Telescope live_grep<cr>", opts)
  keymap("v", "<space>G", function()
    local text = vim.getVisualSelection()
    tb.live_grep({ default_text = text })
  end, opts)
end

return M
