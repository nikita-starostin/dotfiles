# ## Used modules:
# Terminal-Icons 
#		for icons
# PSReadLine 
#		for autocompletion of commands in powershell
# PSFzf 
#		for fuzzy find in the powershell
# oh-my-posh, replaced with starship
#		for nice prompt
#	starship
#	  for nice prompt
# ## Usefull paths
# C:\Program Files\LLVM\bin\clang.exe
#
# ## Tools that are used together in CLI
# - nvim
# - hurl - http client, required for nvim plugins
# - rg - ripgrep, required for nvim plugins
# - lf - file manager, nvim also integrated with it
# 

# Function to get current user_profile.ps1 directory
function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }

# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# terminal-Icons
Import-Module -Name Terminal-Icons

# PSReadline
Import-Module PSReadLine
Set-PsReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PsReadLineOption -PredictionSource History
Set-PsReadLineOption -PredictionViewStyle List
Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Cursor -ViModeChangeHandler $OnViModeChange

# PSFzf
Import-Module PSFzf
Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

# oh-my-posth terminal prompt, was used before, not using starship
# function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }
# $PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) 'starostin.omp.json'
# oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression

# starship - terminal prompt
function Invoke-Starship-TransientFunction {
  &starship module character
}
Invoke-Expression (&starship init powershell)
Enable-TransientPrompt
$ENV:STARSHIP_CONFIG = Join-Path (Get-ScriptDirectory) '../starship.toml'

# copy wezterm config to the right location
$WEZTERM_SOURCE = Join-Path (Get-ScriptDirectory) '../wezterm-config.lua'
$WEZTERM_TARGET = Join-Path $HOME '.wezterm.lua'
Write-Output "Copy from $WEZTERM_SOURCE to $WEZTERM_TARGET"
(Get-Content -path $WEZTERM_SOURCE) | Set-Content $WEZTERM_TARGET
# Write-Output "Wezterm copy config is commeted in the user_profile.ps1 to speed up load time"

# Setup environmet variables
$env:NVIM_APPNAME = 'nvim' # folder with lua for nvim config, the nvim config folder will be named as <nvim_appname> and it's data folder will be named as <nvim_appname>-data
$env:XDG_CONFIG_HOME = 'D:\actual_programs\xdg_config' # folder where to look for nvim_appname and it is related data folders
$env:XDG_DATA_HOME = 'D:\actual_programs\xdg_config' # folder where nvim going to store it's data in the nvim_data folder

# Aliases
Set-Alias chrome 'C:\Program Files\Google\Chrome\Application\chrome.exe'
Set-Alias o OpenWithNvim
Set-Alias vim nvim
Set-Alias od OpenDev
Set-Alias op OpenProjects
Set-Alias oc OpenConfig
Set-Alias cdb ChangeDirectoryBookmarks
Set-Alias cdbo ChangeDirectoryBookmarksOpen
Set-Alias cda ChangeDirectoryAll
Set-Alias cde ChangeDirectoryExtended
Set-Alias nuget D:\actual_programs\xdg_config\nvim\win-cli-tools\nuget.exe
Set-Alias kanata D:\actual_programs\xdg_config\nvim\kanata\kanata.exe
Set-Alias nlist NugetListPakckages
Set-Alias nadd DotnetAddPackage
Set-Alias dclean RemoveBinAndObj
Set-Alias sclean RemoveShada
Set-Alias cdbemulator RunCosmosDbEmulator
Set-Alias openssl StartOpenSsl

function RunCosmosDbEmulator() {
  Start-Process -FilePath "C:\Program Files\Azure Cosmos DB Emulator\Microsoft.Azure.Cosmos.Emulator.exe" -ArgumentList "/port=8092"
}

function StartOpenSsl() {
  $env:OPENSSL_CONF="D:\actual_programs\xdg_config\openssl-0.9.8k_X64\openssl.cnf"
  D:\actual_programs\xdg_config\openssl-0.9.8k_X64\bin\openssl.exe $args
}

function RemoveShada() {
  Remove-Item D:\actual_programs\xdg_config\nvim-data\shada -Recurse -Force
  Write-Host 'D:\actual_programs\xdg_config\nvim-data\shada has been removed'
}

function RemoveBinAndObj() {
  Remove-Item 'bin' -Recurse -Force
  Remove-Item 'obj' -Recurse -Force
  Write-Host 'Bin and obj folders removed'
}

function NugetListPakckages() {
  nuget list -Source https://pkgs.dev.azure.com/Paxton-Access/_packaging/Cloud/nuget/v3/index.json -PreRelease
}

function DotnetAddPackage() {
  $projectName = Get-ChildItem -Filter '*.csproj' -Recurse | Select-Object -ExpandProperty FullName | Invoke-Fzf
  $packageName = nuget list -Source https://pkgs.dev.azure.com/Paxton-Access/_packaging/Cloud/nuget/v3/index.json -PreRelease | Invoke-Fzf
  $projectNameInSingleQuotes = "'$projectName'"
  $packageNameInSingleQuotes = "'$packageName'"
  dotnet add $projectNameInSingleQuotes package $packageNameInSingleQuotes -source https://pkgs.dev.azure.com/Paxton-Access/_packaging/Cloud/nuget/v3/index.json -prerelease
}

function OpenWithNvim($path = ".") {
	Set-Location $path;
	nvim $path;
}

function OpenDev() {
	Get-ChildItem '~\OneDrive - Itransition Group\dev' | Invoke-Fzf | ForEach-Object { OpenWithNvim($_) }
}

function OpenProjects() {
	Get-ChildItem '~\OneDrive - Itransition Group\projects' | Invoke-Fzf | ForEach-Object { OpenWithNvim($_) }
}

function GetBookmarks() {
  $devProjectsOnDDrive = Get-ChildItem 'D:\dev' -Attributes Directory
  $projectsOnDDrive = Get-ChildItem 'D:\projects' -Attributes Directory
	$bookmarks = $projectsOnDDrive + $devProjectsOnDDrive + @(
		'C:\agents\dance-life',
    'D:\actual_programs\xdg_config\nvim',
    'D:\actual_programs\xdg_config\nvim\kanata'
	)

	return $bookmarks
}

function ChangeDirectoryBookmarks() {
	GetBookmarks | Invoke-Fzf | Set-Location
}

function ChangeDirectoryBookmarksOpen() {
	GetBookmarks | Invoke-Fzf | Set-Location | OpenWithNvim
}

function OpenConfig() {
	OpenWithNvim('D:\actual_programs\xdg_config\nvim')
}

function ChangeDirectoryAll() {
	Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
}

function ChangeDirectoryExtended() {
	Get-ChildItem . -Attributes Directory | Invoke-Fzf | Set-Location
}

function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function getProcessOnPort($port) {
  $process = Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
  $process
}

function killProcessOnPort($port) {
  $process = getProcessOnPort $port
  if ($process) {
    Stop-Process -Id $process.Id
  }
}

$t = $MyInvocation.MyCommand.Path
Write-Output "Completed setup from: $t"
