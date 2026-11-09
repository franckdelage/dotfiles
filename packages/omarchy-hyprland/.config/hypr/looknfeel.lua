-- Avoid the Hyprcursor re-enable crash during Omarchy 4.5 startup.
hl.env("XCURSOR_THEME", "Adwaita")

-- Nouveau on this GPU does not display the hardware cursor plane reliably.
hl.config({
  cursor = {
    enable_hyprcursor = false,
    no_hardware_cursors = true,
  },
})

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
