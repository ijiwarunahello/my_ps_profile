function touch($file) {
  if (Test-Path $file) {
    (Get-Item $file).LastWriteTime = Get-Date
  } else {
    Out-File -encoding Default $file
  }
}

Invoke-Expression (&starship init powershell)

function CustomListChildItems { Get-ChildItem $args[0] -force | Sort-Object -Property @{ Expression = 'LastWriteTime'; Descending = $true }, @{ Expression = 'Name'; Ascending = $true } | Format-Table -AutoSize -Property Mode, Length, LastWriteTime, Name }
sal ll CustomListChildItems

function CustomSudo {Start-Process powershell.exe -Verb runas}
sal sudo CustomSudo

function CustomHosts {start vim C:\Windows\System32\drivers\etc\hosts -verb runas}
sal hosts CustomHosts

Set-PSReadlineKeyHandler -Key 'Ctrl+u' -Function BackwardDeleteLine
Set-PSReadlineKeyHandler -Key 'Ctrl+k' -Function ForwardDeleteLine
Set-PSReadlineKeyHandler -Key 'Ctrl+b' -Function BackwardChar
Set-PSReadlineKeyHandler -Key 'Ctrl+f' -Function ForwardChar
Set-PSReadlineKeyHandler -Key 'Ctrl+d' -Function DeleteChar
Set-PSReadlineKeyHandler -Key 'Ctrl+h' -Function BackwardDeleteChar
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key 'Ctrl+a' -Function BeginningOfLine
Set-PSReadlineKeyHandler -Key 'Ctrl+e' -Function EndOfLine
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

function CustomChdirHome { cd ~ }
sal cdhome CustomChdirHome

function ReloadPath { $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") }
sal reload ReloadPath

Set-PSReadlineOption -BellStyle None

function cd-ls {
  param($path)
  try {
    set-location $path -erroraction "stop"
    ls
  }
  catch {"$_"}
}
Remove-Item alias:cd
sal cd cd-ls

function cd-up { cd .. }
sal .. cd-up

$activate_path = "./venv/Script/activate"
function fn-activate {
	.\.venv\Scripts\activate
}
sal activate fn-activate

function pwd-copy {
	(Get-Location).Path | clip
	echo "clip: " (Get-Location).Path
}
sal pwdcopy pwd-copy

# Load custom Profile
$customProfile = $PSScriptRoot + "\Microsoft.PowerShell_profile_custom.ps1"
if (Test-Path $customProfile) {
    . $customProfile
}
