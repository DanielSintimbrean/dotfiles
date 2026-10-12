-- Appearance is otherwise owned by Omarchy so theme and layout updates keep working.

-- Omarchy dims the focused window to 0.985. Keep it fully opaque and leave the
-- inactive opacity at the Omarchy default.
o.window({ tag = "default-opacity" }, { opacity = "1.0 0.96" })

-- Keep all compositor transitions instant.
for _, leaf in ipairs({
  "global",
  "border",
  "windows",
  "windowsIn",
  "windowsOut",
  "fadeIn",
  "fadeOut",
  "fade",
  "fadeSwitch",
  "layers",
  "layersIn",
  "layersOut",
  "fadeLayersIn",
  "fadeLayersOut",
  "workspaces",
  "specialWorkspace",
}) do
  hl.animation({ leaf = leaf, enabled = false })
end

-- Opt another application in to Omarchy's standard transparency.
-- Find its class with: hyprctl clients
-- o.transparent_window("my-app")
-- o.transparent_window("my-app", "0.9 0.85") -- Custom active/inactive opacity.
