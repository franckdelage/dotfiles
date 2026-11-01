-- Personal keybindings and plugin integrations.

local home = os.getenv("HOME") or ""

hl.unbind("SUPER + SHIFT + CTRL + A")
o.bind("SUPER + SHIFT + CTRL + A", "Agent", "cd ~/Workspaces && omarchy-agent --pick")

o.bind("ALT + SHIFT + CTRL + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("ALT + SHIFT + CTRL + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("ALT + SHIFT + CTRL + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("ALT + SHIFT + CTRL + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

o.bind("ALT + SHIFT + CTRL + W", "Focus BenQ workspace 1", function()
  hl.dispatch(hl.dsp.focus({ monitor = "desc:BNQ BenQ RD320U 49R00664019" }))
  per_monitor_workspaces.focus_slot(1)()
end)
o.bind("ALT + SHIFT + CTRL + C", "Focus BenQ workspace 2", function()
  hl.dispatch(hl.dsp.focus({ monitor = "desc:BNQ BenQ RD320U 49R00664019" }))
  per_monitor_workspaces.focus_slot(2)()
end)
o.bind("ALT + SHIFT + CTRL + D", "Focus Iiyama workspace 1", function()
  hl.dispatch(hl.dsp.focus({ monitor = "desc:iiyama Corporation PL2741QS 12745623A1420" }))
  per_monitor_workspaces.focus_slot(1)()
end)
o.bind("ALT + SHIFT + CTRL + E", "Focus Iiyama workspace 2", function()
  hl.dispatch(hl.dsp.focus({ monitor = "desc:iiyama Corporation PL2741QS 12745623A1420" }))
  per_monitor_workspaces.focus_slot(2)()
end)

o.bind("SUPER + code:61", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + ALT + code:61", "Expand window left a little", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
o.bind("SUPER + CTRL + code:61", "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))

o.bind("SUPER + SHIFT + code:61", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
o.bind("SUPER + SHIFT + ALT + code:61", "Shrink window up a little", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
o.bind("SUPER + CTRL + SHIFT + code:61", "Shrink window up a lot", hl.dsp.window.resize({ x = 0, y = -300, relative = true }))

local screens_display_ctl = home ..
  "/.config/omarchy/plugins/im0001gt.screens/scripts/display-ctl"
o.bind("SUPER + SLASH", "Monitor scaling up", screens_display_ctl .. " scale up")
o.bind("SUPER + ALT + SLASH", "Monitor scaling down", screens_display_ctl .. " scale down")

local fathom = home ..
  "/.config/omarchy/plugins/io.github.mtolhuys.fathom/hypr/fathom.lua"
local file = io.open(fathom, "r")
if file then
  file:close()
  pcall(dofile, fathom)
end

o.bind("SUPER + N", "Notifications", "omarchy-shell jgarza.notification toggle")
pcall(dofile, home ..
  "/.config/omarchy/plugins/mmsbrggr.per-monitor-workspaces/hypr/init.lua")
