-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


require("user.lua").config()
require("user.settings").config()
require("user.keymaps").config()
require("user.lvim_options").config()
require("user.null_ls").config()
require("user.blueweb").config()
require("user.dap").config()
require("user.plugins").config()

require("user.plugins_config.lualine").config()
require("user.plugins_config.nvim_lint_config").config()
require("user.plugins_config.conform_config").config()
require("user.plugins_config.noice").config()
require("user.plugins_config.lspsaga").config()
require("user.plugins_config.harpoon").config()
require("user.plugins_config.oil").config()
require("user.plugins_config.flash_config").config()
require("user.plugins_config.aerial").config()
require("user.plugins_config.tiny_inline_diagnostic").config()
require("user.plugins_config.snacks").config()
require("user.plugins_config.luasnip").config()
require("user.plugins_config.treesitter").config()
require("user.plugins_config.treesitter_textobjects").config()
require("user.plugins_config.treesitter_context").config()
require("user.plugins_config.bqf").config()
require("user.plugins_config.octo").config()
require("user.plugins_config.mini_move").config()
require("user.plugins_config.alpha").config()
require("user.plugins_config.nvim_obsidian").config()
