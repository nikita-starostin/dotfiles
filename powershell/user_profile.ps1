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
(Get-Content -path $WEZTERM_SOURCE) | Set-Content $WEZTERM_TARGET

# setup env variable to use glazewm (window tile manager for windows)
$GLAZEWM_CONFIG_PATH = Join-Path (Get-ScriptDirectory) 'glazewm-config.yaml'
$GLAZEWM_ENV_NAME = 'GLAZEWM_CONFIG_PATH'
[Environment]::SetEnvironmentVariable($GLAZEWM_ENV_NAME, $GLAZEWM_CONFIG_PATH, [System.EnvironmentVariableTarget]::User)

# Alias
Set-Alias o OpenWithNvim
Set-Alias vim nvim
Set-Alias rd rider64.exe
Set-Alias od OpenDev
Set-Alias op OpenProjects
Set-Alias oc OpenConfig
Set-Alias cdb ChangeDirectoryBookmarks
Set-Alias cdbo ChangeDirectoryBookmarksOpen
Set-Alias cda ChangeDirectoryAll
Set-Alias cde ChangeDirectoryExtended
Set-Alias nuget C:\Users\n.starostin\AppData\Local\nvim\win-cli-tools\nuget.exe
Set-Alias nlist NugetListPakckages
Set-Alias nadd DotnetAddPackage
Set-Alias dclean RemoveBinAndObj
Set-Alias sclean RemoveShada

# Utilities

function RemoveShada() {
  Remove-Item C:\Users\n.starostin\AppData\Local\nvim-data\shada -Recurse -Force
  Write-Host 'C:\Users\n.starostin\AppData\Local\nvim-data\shada has been removed'
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
	$devProjects = Get-ChildItem '~\OneDrive - Itransition Group\dev' -Attributes Directory
	$projects = Get-ChildItem '~\OneDrive - Itransition Group\projects' -Attributes Directory
	$danceLifeProjects = Get-ChildItem '~\OneDrive - Itransition Group\projects\dance-life'-Attributes Directory
	$bookmarks = $devProjects + $projects + $danceLifeProjects + @(
		'C:\agents\dance-life',
    'C:\users\n.starostin\Downloads'
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
	OpenWithNvim('~\AppData\Local\nvim')
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
