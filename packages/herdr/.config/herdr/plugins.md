# Herdr plugins

Install these plugins manually after installing Herdr. Some provide actions bound in `config.toml`; others expose their own commands or picker.

- **Herdr-Nvim** (`chmarax.herdr-nvim`) — [`ChmaraX/herdr-nvim`](https://github.com/ChmaraX/herdr-nvim). Provides the Neovim sidebar and file picker. Install Neovim to use these features. Current installed version: `1.2.0`.
- **herdr-sesh** (`fedeya.herdr-sesh`) — [`fedeya/herdr-sesh`](https://github.com/fedeya/herdr-sesh). Replaces `fullerzz.sesh`; provides an fzf-based workspace picker and an action to jump to the previous workspace. It does not require Go. Current installed version: `0.2.0`.
- **Vim Navigator** (`local.vim-navigator`) — [`bojackduy/nvim-herdr-navigation`](https://github.com/bojackduy/nvim-herdr-navigation), subdirectory `herdr-vim-navigator`. Provides Vim-aware `Ctrl-h/j/k/l` pane navigation. Current installed version: `0.1.0`.
- **herdr-pluck** (`rmarganti.herdr-pluck`) — [`rmarganti/herdr-pluck`](https://github.com/rmarganti/herdr-pluck). Provides actions to copy a visible token or open a visible URL.
- **Herdr Plus** (`cloudmanic.herdr-plus`) — [`cloudmanic/herdr-plus`](https://github.com/cloudmanic/herdr-plus). Provides the projects action, bound to `prefix+up`.
- **Herdr Customize** (`herdr-customize`) — provides the customize action, bound to `prefix+t`.

- **Herdr Gitview** (`chmarax.gitview`) — [`ChmaraX/herdr-gitview`](https://github.com/ChmaraX/herdr-gitview). Shows changed files and diffs in a two-pane Git view; Enter opens the selected file in Neovim. Bound to `prefix+f` (sidebar) and `prefix+shift+f` (dedicated tab). Current installed version: `0.5.0`.
- **Herdr Plugin Manager** (`ray.plugin-manager`) — [`speardragon/herdr-plugin-manager`](https://github.com/speardragon/herdr-plugin-manager). Opens a popup to browse, install, update, enable/disable, and uninstall plugins. Bound to `prefix+alt+p`. Current installed version: `0.6.0`.
- **herdr-workflows** (`herdr-workflows`) — [`aorumbayev/herdr-workflows`](https://github.com/aorumbayev/herdr-workflows). Runs reusable YAML workflows, including shell commands, agent prompts, and Herdr API actions. Bound to `prefix+k`. Current installed version: `0.15.1` (Linux/macOS).
The recorded versions are informational; check for newer compatible releases when setting up another machine.
