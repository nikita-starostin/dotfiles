# ## Used modules:
# Terminal-Icons 
#		for icons
# PSReadLine 
#		for autocompletion of commands in powershell
# PSFzf 
#		for fuzzy find in the powershell
# oh-my-posh
#		for nice prompt
# ## Usefull paths
# C:\Program Files\LLVM\bin\clang.exe


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

# oh-my-posth
function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }
$PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) 'starostin.omp.json'
oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression

# Alias
Set-Alias o OpenWithNvim
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

# Utilities

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
		'C:\agents\dance-life'
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
