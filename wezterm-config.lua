-- that content should be copied by script to $HOME/.wezterm.lua
-- see for reference https://wezfurlong.org/wezterm/config/files.html
-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- full screen on startup
wezterm.on('gui-attached', function(domain)
  -- maximize all displayed windows on startup
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():toggle_fullscreen()
    end
  end
end)

-- This will hold the configuration.
local config = wezterm.config_builder()

-- configure theme
config.hide_tab_bar_if_only_one_tab = true
local modifiedCattpuccinMocha = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']
modifiedCattpuccinMocha.background = '#1d2021'
config.color_schemes = {
  ['Catppuccin Mocha'] = modifiedCattpuccinMocha,
}
config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'Batman'
-- config.font = wezterm.font("Mononoki Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}) -- C:\WINDOWS\FONTS\HACKNERDFONT-REGULAR.TTF, DirectWrite
-- config.font = wezterm.font("Hack Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}) -- C:\WINDOWS\FONTS\HACKNERDFONT-REGULAR.TTF, DirectWrite
config.font = wezterm.font("BitstromWera Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" }) -- C:\WINDOWS\FONTS\HACKNERDFONT-REGULAR.TTF, DirectWrite
config.font_size = 13.0
local pwsh = 'C:\\Program Files\\PowerShell\\7\\pwsh.exe'
config.default_prog = { pwsh }

config.keys = {
  -- reload config
  {
    key = 'r',
    mods = 'ALT|SHIFT',
    action = act.ReloadConfiguration,
  },

  -- This will create a new split and run the top program inside it
  {
    key = '_',
    mods = 'ALT|SHIFT',
    action = act.SplitVertical {
      args = { pwsh },
    },
  },

  -- This will create a new split and run the top program inside it
  {
    key = '+',
    mods = 'ALT|SHIFT',
    action = act.SplitHorizontal {
      args = { pwsh },
    },
  },

  -- This will close the current tab
  {
    key = 'w',
    mods = 'ALT|SHIFT',
    action = act.CloseCurrentPane { confirm = false },
  },

  -- paste from the clipboard
  {
    key = 'V',
    mods = 'CTRL',
    action = act.PasteFrom 'Clipboard'
  },

  -- activate pane by direction
  {
    key = 'h',
    mods = 'ALT|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'ALT|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'ALT|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'ALT|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },

  -- full screen mode toggle
  {
    key = 'n',
    mods = 'CTRL|SHIFT',
    action = act.ToggleFullScreen,
  },

  -- current pane full screen toggle
  {
    key = 'f',
    mods = 'ALT|SHIFT',
    action = act.TogglePaneZoomState,
  },
}

return config
