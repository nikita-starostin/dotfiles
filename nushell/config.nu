$env.config = ($env.config | merge {
  show_banner: false
  edit_mode: vi
  shell_integration: {
    osc133: false
  }
  completions: ($env.config.completions | merge {
    algorithm: fuzzy
    case_sensitive: false
    quick: true
    partial: true
    use_ls_colors: true
  })
})

$env.STARSHIP_CONFIG = ($nu.default-config-dir | path join 'starship.toml')

const NUGET_SOURCE = 'https://pkgs.dev.azure.com/Paxton-Access/_packaging/Cloud/nuget/v3/index.json'
const WIN_TOOLS_DIR = 'C:\InstalledByMe\xdg_config\nvim\win-cli-tools'

def dirs-in [base: string] {
  if ($base | path exists) {
    ls $base | where type == dir | get name
  } else {
    []
  }
}

def fzf-pick [items: list<string>] {
  if ($items | is-empty) {
    return null
  }

  let selected = ($items | str join (char nl) | ^fzf | str trim)
  if $selected == '' { null } else { $selected }
}

def --env open-with-nvim [path: string = '.'] {
  cd $path
  ^nvim $path
}

def --env open-dev [] {
  let base = ($env.HOME | path join 'OneDrive - Itransition Group' 'dev')
  let picked = (fzf-pick (dirs-in $base))
  if $picked != null {
    open-with-nvim $picked
  }
}

def --env open-projects [] {
  let base = ($env.HOME | path join 'OneDrive - Itransition Group' 'projects')
  let picked = (fzf-pick (dirs-in $base))
  if $picked != null {
    open-with-nvim $picked
  }
}

def get-bookmarks [] {
  let extra = [
    'C:\InstalledByMe\xdg_config\nvim'
    'C:\InstalledByMe\xdg_config\nvim\kanata'
  ]

  (dirs-in 'C:\projects') ++ (dirs-in 'C:\dev') ++ $extra
}

def --env change-directory-bookmarks [] {
  let picked = (fzf-pick (get-bookmarks))
  if $picked != null {
    cd $picked
  }
}

def --env change-directory-bookmarks-open [] {
  let picked = (fzf-pick (get-bookmarks))
  if $picked != null {
    open-with-nvim $picked
  }
}

def --env open-config [] {
  open-with-nvim 'C:\InstalledByMe\xdg_config\nvim'
}

def --env change-directory-all [] {
  let dirs = (glob '**' | where {|item| ($item | path type) == dir } | each {|item| $item | path expand })
  let picked = (fzf-pick $dirs)
  if $picked != null {
    cd $picked
  }
}

def --env change-directory-extended [] {
  let dirs = (ls | where type == dir | get name)
  let picked = (fzf-pick $dirs)
  if $picked != null {
    cd $picked
  }
}

def --wrapped chrome [...args] {
  run-external 'C:\Program Files\Google\Chrome\Application\chrome.exe' ...$args
}

def --wrapped nuget [...args] {
  run-external ($WIN_TOOLS_DIR | path join 'nuget.exe') ...$args
}

def --wrapped run-yt-dlp [...args] {
  run-external ($WIN_TOOLS_DIR | path join 'yt-dlp.exe') ...$args
}

def --wrapped run-youtube-dl [...args] {
  run-external ($WIN_TOOLS_DIR | path join 'youtube-dl.exe') ...$args
}

def run-cosmos-db-emulator [] {
  run-external 'C:\Program Files\Azure Cosmos DB Emulator\Microsoft.Azure.Cosmos.Emulator.exe' '/port=8092'
}

def --wrapped start-openssl [...args] {
  with-env {
    OPENSSL_CONF: 'D:\actual_programs\xdg_config\openssl-0.9.8k_X64\openssl.cnf'
  } {
    run-external 'D:\actual_programs\xdg_config\openssl-0.9.8k_X64\bin\openssl.exe' ...$args
  }
}

def remove-shada [] {
  let shada_path = 'D:\actual_programs\xdg_config\nvim-data\shada'
  if ($shada_path | path exists) {
    rm -r -f $shada_path
    print $'($shada_path) has been removed'
  }
}

def remove-bin-and-obj [] {
  if ('bin' | path exists) { rm -r -f bin }
  if ('obj' | path exists) { rm -r -f obj }
  print 'bin and obj folders removed'
}

def nuget-list-packages [] {
  nuget list -Source $NUGET_SOURCE -PreRelease
}

def dotnet-add-package [] {
  let project = (fzf-pick (glob '**/*.csproj'))
  if $project == null {
    return
  }

  let package_line = (fzf-pick (nuget-list-packages | lines))
  if $package_line == null {
    return
  }

  let package_name = ($package_line | split row ' ' | first)
  ^dotnet add $project package $package_name -source $NUGET_SOURCE -prerelease
}

def get-process-on-port [port: int] {
  let pattern = $':($port)\s'
  let line = (^netstat -ano -p tcp | lines | where {|item| $item =~ $pattern } | get 0?)

  if $line == null {
    null
  } else {
    let pid = ($line | str trim | split row -r '\\s+' | last | into int)
    {
      pid: $pid
      process: (^tasklist /FI $'PID eq ($pid)' | lines | get 3?)
    }
  }
}

def kill-process-on-port [port: int] {
  let process_info = (get-process-on-port $port)
  if $process_info != null {
    run-external taskkill /PID ($process_info.pid | into string) /F
  }
}

def rld [] {
  ^nu 'C:\InstalledByMe\xdg_config\nvim\nushell\setup.nu'
}

alias o = open-with-nvim
alias pip = ^python -m pip
alias vim = nvim
alias od = open-dev
alias op = open-projects
alias oc = open-config
alias cdb = change-directory-bookmarks
alias cdbo = change-directory-bookmarks-open
alias cda = change-directory-all
alias cde = change-directory-extended
alias nlist = nuget-list-packages
alias nadd = dotnet-add-package
alias dclean = remove-bin-and-obj
alias sclean = remove-shada
alias cdbemulator = run-cosmos-db-emulator
alias openssl = start-openssl
alias yt-dlp = run-yt-dlp
alias youtube-dl = run-youtube-dl
