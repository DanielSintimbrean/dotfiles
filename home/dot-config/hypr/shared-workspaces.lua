-- Keep Omarchy's workspace bindings, with one shared set of workspace IDs.
require("default.hypr.helpers")

local workspaces = {}

function workspaces.focus(workspace)
  return hl.dsp.focus({ workspace = tostring(workspace), on_current_monitor = true })
end

function workspaces.move_window(workspace, follow)
  return hl.dsp.window.move({ workspace = tostring(workspace), follow = follow ~= false })
end

function workspaces.move_to_monitor(direction)
  return hl.dsp.workspace.move({ monitor = direction })
end

function workspaces.move_window_to_monitor(direction)
  return hl.dsp.window.move({ monitor = direction })
end

o.workspaces = workspaces
return workspaces
