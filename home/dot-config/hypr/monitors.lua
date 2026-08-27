local function read_first_line(path)
  local file = io.open(path, "r")
  if not file then
    return ""
  end

  local value = file:read("*l") or ""
  file:close()
  return value:match("^%s*(.-)%s*$")
end

local monitor_profiles = {
  omarchy = {
    configure = function()
      hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
      hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "auto", scale = 1 })
      hl.monitor({ output = "DP-2", mode = "1920x1080@143.60", position = "0x-1080", scale = 1 })
      hl.env("GDK_SCALE", "1")
    end,
  },
  slimbook = {
    configure = function()
      hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
      hl.env("GDK_SCALE", "1")
    end,
  },
}

local hostname = read_first_line("/etc/hostname")
local profile = monitor_profiles[hostname]

if profile then
  profile.configure()
else
  -- Safe fallback for every machine without an explicit profile.
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
  hl.env("GDK_SCALE", "2")
end
