local M = {}

-- JSON language server
M.servers = {
  jsonls = {
    -- Si tu utilises Mason, la commande 'vscode-json-languageserver' est généralement mappée sur 'json-languageserver'
    cmd = { 'vscode-json-languageserver', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_patterns = { '.git' },
    name = 'jsonls',
    settings = {
      json = {
        -- Autorise la validation via les schémas
        validate = { enable = true },
        -- C'est ici que la magie du "$schema" opère
        schemas = {
          -- Tu peux forcer des schémas ici, mais laisser vide permet 
          -- au serveur de se concentrer sur le $schema présent dans tes fichiers.
        },
      },
    },
    -- Indispensable pour que le LSP puisse télécharger les schémas distants
    init_options = {
      provideFormatter = true,
    },
  },
}

return M
