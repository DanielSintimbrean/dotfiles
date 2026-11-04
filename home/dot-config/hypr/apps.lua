-- Load personal app rules, one file per app.
local paths = require("default.hypr.paths")
require("default.hypr.require_all").files(paths.config_home .. "/hypr/apps/", "hypr.apps")
