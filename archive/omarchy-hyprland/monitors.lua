-- Monitor layout for this machine; managed alongside im0001gt.screens.
local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

hl.monitor({
  output = "desc:BNQ BenQ RD320U 49R00664019",
  mode = "3840x2160@60",
  position = "1440x1120",
  scale = 1,
  vrr = 0,
})
hl.monitor({
  output = "desc:iiyama Corporation PL2741QS 12745623A1420",
  mode = "2560x1440@59.95",
  position = "0x0",
  scale = 1,
  transform = 3,
  vrr = 0,
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.config({ misc = { vrr = 0 }, render = { cm_auto_hdr = 0 } })
