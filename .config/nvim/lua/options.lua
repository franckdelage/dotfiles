-- Configuration d'options améliorée pour Angular/HTML
-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true

--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

vim.opt.laststatus = 3

-- 🔧 CONFIGURATION DE DÉTECTION DE TYPES DE FICHIERS AMÉLIORÉE
vim.filetype.add {
  pattern = {
    -- Angular HTML templates
    ['.*%.component%.html'] = 'htmlangular',
    ['.*%.component%.spec%.html'] = 'htmlangular',
    -- Angular templates dans des dossiers spécifiques
    ['.*/templates/.*%.html'] = 'htmlangular',
    ['.*/angular/.*%.html'] = 'htmlangular',
    -- Fichiers HTML dans des projets Angular (basé sur la présence d'angular.json)
    ['.*%.html'] = function(path, bufnr)
      -- Vérifier si on est dans un projet Angular
      local angular_json = vim.fs.find('angular.json', { 
        path = path, 
        upward = true 
      })[1]
      if angular_json then
        return 'htmlangular'
      end
      return 'html'
    end,
  },
  extension = {
    mdx = 'markdown',
    -- Extensions TypeScript Angular
    ts = 'typescript',
    tsx = 'typescriptreact',
  },
  filename = {
    -- Fichiers de configuration Angular
    ['angular.json'] = 'jsonc',
    ['nx.json'] = 'jsonc',
    ['project.json'] = 'jsonc',
    ['tsconfig.json'] = 'jsonc',
    ['tsconfig.*.json'] = 'jsonc',
  },
}

-- 🔧 AMÉLIORATION DU WRAPPING ET DE L'INDENTATION
vim.wo.wrap = true
vim.wo.linebreak = true
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.expandtab = true -- Utiliser des espaces au lieu de tabs

-- 🔧 CONFIGURATION SPÉCIFIQUE POUR ANGULAR/HTML
-- Améliorer la gestion des fichiers HTML volumineux
vim.opt.synmaxcol = 300 -- Limite la syntaxe highlighting sur les lignes très longues
vim.opt.lazyredraw = true -- Améliore les performances lors du scrolling

-- Configuration pour les projets Angular/TypeScript
vim.g["test#javascript#runner"] = "nx"
vim.g["test#strategy"] = "floaterm"

-- 🔧 AUTOCMDS POUR ANGULAR/HTML
local angular_group = vim.api.nvim_create_augroup('AngularConfig', { clear = true })

-- Auto-détection améliorée pour les fichiers HTML Angular
vim.api.nvim_create_autocmd('BufRead', {
  group = angular_group,
  pattern = '*.html',
  callback = function()
    local path = vim.fn.expand('%:p')
    -- Vérifier si le fichier contient des directives Angular
    local content = vim.fn.readfile(path, '', 50) -- Lire les 50 premières lignes
    local is_angular = false
    
    for _, line in ipairs(content) do
      -- Chercher des patterns Angular typiques
      if line:match('@%w+') or 
         line:match('%*ng%w+') or 
         line:match('%[%(%w+%)%]') or 
         line:match('{{.*}}') or
         line:match('(click)') or 
         line:match('(change)') or
         line:match('%[routerLink%]') then
        is_angular = true
        break
      end
    end
    
    if is_angular then
      vim.bo.filetype = 'htmlangular'
    end
  end,
})

-- Configuration spécifique pour les fichiers HTML Angular
vim.api.nvim_create_autocmd('FileType', {
  group = angular_group,
  pattern = 'htmlangular',
  callback = function()
    -- Configuration spécifique pour HTML Angular
    vim.bo.commentstring = '<!-- %s -->'
    vim.opt_local.iskeyword:append('-') -- Permet de naviguer dans les mots avec des tirets
    
    -- Améliorer l'indentation pour les templates Angular
    vim.opt_local.indentexpr = ''
    vim.opt_local.smartindent = true
    vim.opt_local.autoindent = true
  end,
})

-- Configuration pour TypeScript dans les projets Angular
vim.api.nvim_create_autocmd('FileType', {
  group = angular_group,
  pattern = { 'typescript', 'typescriptreact' },
  callback = function()
    -- Configuration spécifique pour TypeScript Angular
    vim.opt_local.iskeyword:append('-')
  end,
})

-- vim: ts=2 sts=2 sw=2 et

