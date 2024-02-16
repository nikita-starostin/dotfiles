# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Use icons for dir/ls
Import-Module -Name Terminal-Icons

# Prompt
function Get-ScriptDirectory { Split-Path $MyInvocation.ScriptName }
$PROMPT_CONFIG = Join-Path (Get-ScriptDirectory) 'starostin.omp.json'
oh-my-posh --init --shell pwsh --config $PROMPT_CONFIG | Invoke-Expression

# PS Readline
Import-Module PSReadLine
Set-PsReadLineOption -EditMode Emacs
Set-PsReadLineOption -BellStyle None
Set-PsReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PsReadLineOption -PredictionSource History
Set-PsReadLineOption -PredictionViewStyle List
# Set-PsReadLineOption -EditMode Vi
# Set-PSReadLineOption -ViModeIndicator Cursor -ViModeChangeHandler $OnViModeChange

# Fzf
Import-Module PSFzf
Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

# Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias rd rider64.exe

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
