$env.NVIM_APPNAME = 'nvim'
$env.XDG_CONFIG_HOME = 'C:\InstalledByMe\xdg_config'
$env.XDG_DATA_HOME = 'C:\InstalledByMe\xdg_config'
$env.XDG_CACHE_HOME = 'C:\InstalledByMe\xdg_cache'

let win_tools_dir = 'C:\InstalledByMe\xdg_config\nvim\win-cli-tools'
if ($win_tools_dir | path exists) {
  $env.PATH = ($env.PATH | append $win_tools_dir)
}
