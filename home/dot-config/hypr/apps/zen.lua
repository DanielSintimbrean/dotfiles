-- Zen gives login popups the same initial title as normal windows. Wait for
-- the first page title so existing browser windows stay tiled.
local zen_windows_opening = {}
local function float_google_login(window)
  if not window or not zen_windows_opening[window.address] then return end
  local title = window.title or ""
  if title == "" or title == "Zen Browser" or title:match("^about:.*Zen Browser$") then return end
  zen_windows_opening[window.address] = nil
  if title:find("Cuentas de Google", 1, true) or title:find("Google Accounts", 1, true) then
    hl.dispatch(hl.dsp.window.float({ action = "on", window = window }))
    hl.dispatch(hl.dsp.window.resize({ x = 800, y = 850, window = window }))
    hl.dispatch(hl.dsp.window.center({ window = window }))
  end
end
hl.on("window.open", function(window)
  if window and window.class == "zen" then
    zen_windows_opening[window.address] = true
    float_google_login(window)
  end
end)
hl.on("window.title", float_google_login)
hl.on("window.close", function(window)
  if window then zen_windows_opening[window.address] = nil end
end)
