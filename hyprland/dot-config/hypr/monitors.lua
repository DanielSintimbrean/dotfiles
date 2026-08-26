local function machine_name()
  local hostname_file = io.open("/etc/hostname", "r")
  if not hostname_file then
    return ""
  end

  local hostname = hostname_file:read("*l") or ""
  hostname_file:close()
  return hostname:match("^%s*(.-)%s*$")
end

local monitor_profiles = {
  omarchy = function()
    hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
    hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "auto", scale = 1 })
    hl.monitor({ output = "DP-2", mode = "1920x1080@143.60", position = "0x-1080", scale = 1 })
    hl.env("GDK_SCALE", "1")
  end,
}

local configure_monitors = monitor_profiles[machine_name()]
if configure_monitors then
  configure_monitors()
else
  -- Safe fallback for every machine without an explicit profile.
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
  hl.env("GDK_SCALE", "2")
end
