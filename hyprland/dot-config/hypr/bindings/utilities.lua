-- Utility bindings (migrated from bindings/utilities.conf)
---@module 'hl'

local function d(desc) return { description = desc } end

-- Menus
hl.bind("SUPER + SPACE",       hl.dsp.exec_cmd("omarchy-launch-walker"),             d("Launch apps"))
hl.bind("SUPER + CTRL + E",    hl.dsp.exec_cmd("omarchy-launch-walker -m symbols"),  d("Emoji picker"))
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd("omarchy-menu"),                      d("Omarchy menu"))
hl.bind("SUPER + ESCAPE",      hl.dsp.exec_cmd("omarchy-menu system"),               d("Power menu"))
hl.bind("XF86PowerOff",        hl.dsp.exec_cmd("omarchy-menu system"),               { locked = true, description = "Power menu" })
hl.bind("SUPER + K",           hl.dsp.exec_cmd("omarchy-menu-keybindings"),          d("Show key bindings"))
hl.bind("XF86Calculator",      hl.dsp.exec_cmd("gnome-calculator"),                  d("Calculator"))

-- Aesthetics
hl.bind("SUPER + SHIFT + SPACE",        hl.dsp.exec_cmd("omarchy-toggle-waybar"),   d("Toggle top bar"))
hl.bind("SUPER + CTRL + SPACE",         hl.dsp.exec_cmd("omarchy-theme-bg-next"),   d("Next background in theme"))
hl.bind("SUPER + SHIFT + CTRL + SPACE", hl.dsp.exec_cmd("omarchy-menu theme"),      d("Pick new theme"))
hl.bind("SUPER + BACKSPACE",            hl.dsp.window.set_prop({ prop = "opaque", value = "toggle" }), d("Toggle window transparency"))

-- Notifications
hl.bind("SUPER + ALT + COMMA",       hl.dsp.exec_cmd("makoctl dismiss"),                            d("Dismiss last notification"))
hl.bind("SUPER + SHIFT + COMMA",     hl.dsp.exec_cmd("makoctl dismiss --all"),                      d("Dismiss all notifications"))
hl.bind("SUPER + CTRL + COMMA",      hl.dsp.exec_cmd("omarchy-toggle-notification-silencing"),      d("Toggle silencing notifications"))
hl.bind("SUPER + ALT + COMMA",       hl.dsp.exec_cmd("makoctl invoke"),                             d("Invoke last notification"))
hl.bind("SUPER + SHIFT + ALT + COMMA", hl.dsp.exec_cmd("makoctl restore"),                          d("Restore last notification"))

-- Toggle idling / nightlight
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("omarchy-toggle-idle"),      d("Toggle locking on idle"))
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("omarchy-toggle-nightlight"), d("Toggle nightlight"))

-- Control Apple Display brightness
hl.bind("CTRL + F1",         hl.dsp.exec_cmd("omarchy-cmd-apple-display-brightness -5000"),  d("Apple Display brightness down"))
hl.bind("CTRL + F2",         hl.dsp.exec_cmd("omarchy-cmd-apple-display-brightness +5000"),  d("Apple Display brightness up"))
hl.bind("SHIFT + CTRL + F2", hl.dsp.exec_cmd("omarchy-cmd-apple-display-brightness +60000"), d("Apple Display full brightness"))

-- Captures
hl.bind("PRINT",         hl.dsp.exec_cmd("omarchy-capture-screenshot"),                       d("Screenshot"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("sleep 2 && omarchy-capture-screenshot fullscreen"), d("Screenshot"))
hl.bind("ALT + PRINT",   hl.dsp.exec_cmd("omarchy-menu screenrecord"),                        d("Screenrecording"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"),                d("Color picker"))

-- File sharing
hl.bind("CTRL + SUPER + S", hl.dsp.exec_cmd("omarchy-menu share"), d("Share"))
