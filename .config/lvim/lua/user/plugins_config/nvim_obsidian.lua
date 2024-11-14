local M = {}

M.config = function ()
  local obsidian = require("obsidian");

  obsidian.setup({
    workspaces = {
      {
        name = "SecondBrain",
        path = "~/Drive/SecondBrain",
      },
    },
    notes_subdir = "RoughNotes",

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    new_notes_location = "notes_subdir",

    note_id_func = function(title)
      return title
    end,
    note_frontmatter_func = function(note)
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
      -- This is equivalent to the default behavior.
      local path = spec.dir / tostring(spec.title)
      return path:with_suffix(".md")
    end,

    daily_notes = {
      folder = "Dailies",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily-notes" },
      template = "Full Note.md"
    },

    -- Optional, for templates (see below).
    templates = {
      folder = "Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({"open", url})  -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,
  })
end

return M
