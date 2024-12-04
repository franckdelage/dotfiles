local M = {}

M.config = function ()
  lvim.keys.insert_mode["jk"] = "<esc>"
  lvim.keys.normal_mode["tg"] = "gT"

  lvim.lsp.buffer_mappings.normal_mode["gd"] = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" }
  lvim.lsp.buffer_mappings.normal_mode["gD"] = { "<cmd>Lspsaga goto_definition<cr>", "Go to definition" }
  lvim.lsp.buffer_mappings.normal_mode["gy"] = { "<cmd>Lspsaga goto_type_definition<cr>", "Go to type definition" }
  lvim.lsp.buffer_mappings.normal_mode["K"] = { "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation" }
  lvim.lsp.buffer_mappings.normal_mode["gl"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Next diagnostic" }
  lvim.lsp.buffer_mappings.normal_mode["gL"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Previous diagnostic" }
  lvim.lsp.buffer_mappings.normal_mode["gb"] = { "<cmd>Lspsaga show_buf_diagnostics<cr>", "Buffer diagnostics" }
  lvim.lsp.buffer_mappings.normal_mode["gc"] = { "<cmd>Lspsaga show_cursor_diagnostics<cr>", "Cursor diagnostics" }
  lvim.lsp.buffer_mappings.normal_mode["gw"] = { "<cmd>Lspsaga show_workspace_diagnostics<cr>", "Workspace diagnostics" }

  lvim.lsp.buffer_mappings.normal_mode["gj"] = { function() require("lua.user.plugins_config.flash").jump() end, "Flash" }
  lvim.lsp.buffer_mappings.normal_mode["<leader>,"] = { function() require("lua.user.plugins_config.flash").jump() end, "Flash" }

  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

  lvim.builtin.which_key.mappings[";"] = {
    "<cmd>checkt<cr>", "Checktime"
  }

  lvim.builtin.which_key.mappings["gf"] = {
    "<cmd>Git<cr>", "Fugitive"
  }

  lvim.builtin.which_key.mappings["ga"] = {
    "<cmd>Git blame<cr>", "Blame all file"
  }

  lvim.builtin.which_key.mappings["Lw"] = {
    "<cmd>tabe ~/dotfiles/.wezterm.lua<cr>", "Wezterm Config"
  }

  lvim.builtin.which_key.mappings["Ls"] = {
    name = "Snippets",
    {
      r = { "<cmd>source ~/.config/lvim/lua/user/snippets/snippets.lua<cr>", "Reload snippets" },
      e = { "<cmd>vs ~/dotfiles/.config/lvim/lua/user/snippets/snippets.lua<cr>", "Edit snippets" },
    }
  }

  -- LSP
  lvim.builtin.which_key.mappings["l"] = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    d = { "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>", "Buffer Diagnostics" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    -- f = { "<cmd>lua require('lvim.lsp.utils').format()<cr>", "Format" },
    f = { function() require("conform").format({}) end, "Format" },
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
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
    e = { "<cmd>Telescope quickfix<cr>", "Telescope Quickfix" },
    u = { "<cmd>Telescope lsp_references<cr>", "References" },
    m = { "<cmd>TSToolsAddMissingImports<cr>", "Missing Imports" },
    x = { "<cmd>TSToolsRemoveUnusedImports<cr>", "Unused Imports" },
    c = { function() require("lint").try_lint() end, "Trigger Nvim linting" },
  }

  lvim.builtin.which_key.mappings["bx"] = {
    "<cmd>BufferLineCloseOthers<cr>", "Close others"
  }

  lvim.builtin.which_key.mappings["bp"] = {
    "<cmd>BufferLineTogglePin<cr>", "Toggle Pin"
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
    "<cmd>lua require('telescope').extensions.menufacture.git_files()<cr>", "Find Git file"
  }

  -- Telescope
  lvim.builtin.which_key.mappings["s"] = {
    name = "Search",
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    f = { "<cmd>lua require('telescope').extensions.menufacture.find_files()<cr>", "Find File" },
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
    p = { "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", "Colorscheme with Preview" },
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
      s = { "<cmd>Telescope scope buffers<cr>", "All Buffers" },
      b = { "<cmd>Telescope buffers<cr>", "Tab's Buffers" },
      f = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Fuzzy find" },
    },
  }

  lvim.builtin.which_key.mappings["a"] = {
    name = "Flash and Aerial",
    s = { function() require("flash").jump() end, "Flash jump" },
    t = { function() require("flash").treesitter() end, "Flash Treesitter" },
    r = { function() require("flash").treesitter_search() end, "Flash Treesitter Search" },
    e = { function() require("flash").remote() end, "Flash Remote" },
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
end

return M
