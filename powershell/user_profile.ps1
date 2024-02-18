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
Set-Alias o nvim
Set-Alias rd rider64.exe
Set-Alias od OpenDev
Set-Alias op OpenProjects
Set-Alias oc OpenConfig
Set-Alias cdb ChangeDirectoryBookmarks
Set-Alias cda ChangeDirectoryAll
Set-Alias cde ChangeDirectoryExtended

# Utilities

function OpenWithNvim($path) {
	Set-Location $path;
	nvim $path;
}

function OpenDev() {
	Get-ChildItem '~\OneDrive - Itransition Group\dev' | Invoke-Fzf | ForEach-Object { OpenWithNvim($_) }
}

function OpenProjects() {
	Get-ChildItem '~\OneDrive - Itransition Group\projects' | Invoke-Fzf | ForEach-Object { OpenWithNvim($_) }
}

function ChangeDirectoryBookmarks() {
	$bookmarks = @(
		'~\OneDrive - Itransition Group\projects',
		'~\OneDrive - Itransition Group\projects\dance-life',
		'~\OneDrive - Itransition Group\projects\dm-devops',
		'~\OneDrive - Itransition Group\dev',
		'C:\agents\dance-life'
	)

	$bookmarks | Invoke-Fzf | Set-Location
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
