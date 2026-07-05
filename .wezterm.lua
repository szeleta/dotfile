-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
-- config.color_scheme = 'AdventureTime'
config.window_background_opacity = 0.65

config.show_new_tab_button_in_tab_bar = false

config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

config.window_background_gradient = {
  colors = { "#000000" },
}

-- Use Git Bash as the default shell instead of cmd.exe
config.default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l' }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

-- Label tabs with the SSH domain's host name instead of the shell/process
-- name when the pane belongs to an SSH domain, styled with background colors
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#3F3F46"
  local foreground = "#FFFFFF"

  if tab.is_active then
    background = "#0369A1"
    foreground = "#FFFFFF"
  end

  local pane = tab.active_pane
  local domain = pane.domain_name
  local raw_title
  if domain and domain ~= "local" then
    -- default_ssh_domains() names domains like "SSH:host" / "SSHMUX:host";
    -- strip the prefix so the tab just shows the host name
    raw_title = domain:gsub("^SSH:", ""):gsub("^SSHMUX:", "")
  else
    raw_title = pane.title
  end

  local title = "   " .. wezterm.truncate_right(raw_title, max_width - 1) .. "   "

  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)


-- Show the SSH domain launcher automatically when a new window starts
-- (RLogin-like session picker), in addition to the right-click Launcher Menu
-- wezterm.on('gui-startup', function(cmd)
--   local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
--   window:gui_window():perform_action(
--     wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' },
--     pane
--   )
-- end)

-- Also show the domain launcher when spawning a new tab (overrides the
-- default CTRL+SHIFT+T / SUPER+T "SpawnTab" binding)
config.keys = {
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' },
  },
  {
    key = 't',
    mods = 'SUPER',
    action = wezterm.action.ShowLauncherArgs { flags = 'DOMAINS' },
  },
}

-- Finally, return the configuration to wezterm:
return config
