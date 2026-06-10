def main [] {
  let script_dir = (if ('FILE_PWD' in ($env | columns)) { $env.FILE_PWD } else { (pwd | get path) })
  let repo_root = ($script_dir | path dirname)

  let xdg_config_home = 'C:\InstalledByMe\xdg_config'
  let xdg_data_home = 'C:\InstalledByMe\xdg_config'
  let xdg_cache_home = 'C:\InstalledByMe\xdg_cache'

  let source_config = ($script_dir | path join 'config.nu')
  let source_env = ($script_dir | path join 'env.nu')
  let source_starship = ($repo_root | path join 'starship.toml')
  let source_wezterm = ($repo_root | path join 'wezterm-config.lua')

  let config_target = ($xdg_config_home | path join 'nushell' 'config.nu')
  let env_target = ($xdg_config_home | path join 'nushell' 'env.nu')
  let starship_target = ($xdg_config_home | path join 'nushell' 'starship.toml')
  let wezterm_target = ($nu.home-dir | path join '.wezterm.lua')
  let appdata_nu_dir = ($env.APPDATA | path join 'nushell')
  let appdata_config_target = ($appdata_nu_dir | path join 'config.nu')
  let appdata_env_target = ($appdata_nu_dir | path join 'env.nu')
  let appdata_starship_target = ($appdata_nu_dir | path join 'starship.toml')

  mkdir ($config_target | path dirname)
  mkdir ($env_target | path dirname)
  mkdir $appdata_nu_dir

  cp -f $source_config $config_target
  cp -f $source_env $env_target
  cp -f $source_config $appdata_config_target
  cp -f $source_env $appdata_env_target

  if ($source_starship | path exists) {
    cp -f $source_starship $starship_target
    cp -f $source_starship $appdata_starship_target
  }

  if ($source_wezterm | path exists) {
    cp -f $source_wezterm $wezterm_target
  }

  let starship_available = ((which starship | length) > 0)
  if $starship_available {
    let autoload_dir = ($xdg_data_home | path join 'nushell' 'vendor' 'autoload')
    let appdata_autoload_dir = ($nu.data-dir | path join 'vendor' 'autoload')
    mkdir $autoload_dir
    mkdir $appdata_autoload_dir
    ^starship init nu | save -f ($autoload_dir | path join 'starship.nu')
    ^starship init nu | save -f ($appdata_autoload_dir | path join 'starship.nu')
    print 'starship init script generated'
  } else {
    print 'starship not found, install it and rerun setup.nu'
  }

  ^setx NVIM_APPNAME 'nvim' | ignore
  ^setx XDG_CONFIG_HOME $xdg_config_home | ignore
  ^setx XDG_DATA_HOME $xdg_data_home | ignore
  ^setx XDG_CACHE_HOME $xdg_cache_home | ignore

  print $'copied config.nu -> ($config_target) and ($appdata_config_target)'
  print $'copied env.nu -> ($env_target) and ($appdata_env_target)'
  print $'copied starship.toml -> ($starship_target) and ($appdata_starship_target)'
  print $'copied wezterm-config.lua -> ($wezterm_target)'
  print 'persisted NVIM_APPNAME and XDG_* via setx for new sessions'
  print 'done: restart terminal apps to load the new configuration'
}
