return {
  "smit4k/snapshot.nvim",
  config = function()
    require("snapshot").setup({
        -- Optional config settings, defaults shown below
        snapshot_dir = "~/Pictures/nvim-snapshots", -- Reccomended: directory where snapshot images are saved to
        --padding = 25,
        --line_height = 28,
        --font_size = 24,
        --shadow = true,
        --line_numbers = false,
        --start_line = 1,
        --border_radius = 5,
        outer_background = "#00000000", -- use #00000000 for transparent
        --outer_padding = 15,
        --clipboard = true,
    })
  end,
}
