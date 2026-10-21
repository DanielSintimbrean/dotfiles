-- Omarchy owns the defaults. This repository only adds personal overrides.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Replace the per-monitor manager before it registers startup and hotplug hooks.
package.loaded["default.hypr.monitor-workspaces"] = require("hypr.shared-workspaces")
require("default.hypr.omarchy")

require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.workspaces")
require("hypr.looknfeel")
require("hypr.autostart")

require("default.hypr.toggles")
pcall(require, "/home/danields/.config/hypr/openwhispr-binds.lua")
