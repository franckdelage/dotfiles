local is_linux = vim.uv.os_uname().sysname == "Linux"

return {
  "milanglacier/minuet-ai.nvim",
  enabled = is_linux,
  event = "InsertEnter",
  config = function()
    if not vim.env.OPENROUTER_API_KEY or vim.env.OPENROUTER_API_KEY == "" then
      vim.notify(
        "OPENROUTER_API_KEY is missing. Add it to ~/.zshrc.local and restart Neovim.",
        vim.log.levels.WARN
      )
      return
    end

    require("minuet").setup {
      provider = "openai_compatible",
      request_timeout = 2.5,
      throttle = 1500,
      debounce = 600,
      provider_options = {
        openai_compatible = {
          api_key = "OPENROUTER_API_KEY",
          end_point = "https://openrouter.ai/api/v1/chat/completions",
          model = "deepseek/deepseek-v4-flash",
          name = "OpenRouter",
          optional = {
            max_tokens = 56,
            top_p = 0.9,
            provider = {
              sort = "throughput",
            },
            reasoning_effort = "none",
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = { "*" },
        auto_trigger_ignore_ft = {
          "yaml",
          "help",
          "gitrebase",
          "hgcommit",
          "svn",
          "cvs",
        },
        show_on_completion_menu = false,
        keymap = {
          accept = "<C-h>",
          accept_line = "<M-i>",
          accept_n_lines = "<M-w>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
    }
  end,
}
