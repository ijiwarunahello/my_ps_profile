# パラメータ定義
param (
    [string]$profileFileName = "Microsoft.PowerShell_profile.ps1", # 共通プロファイルファイル名
    [string]$customProfileFileName = "Microsoft.PowerShell_profile_custom.ps1" # カスタムプロファイルファイル名
)

# ローカルでのリポジトリの場所（スクリプトを実行しているフォルダ）
$localRepoDir = $PSScriptRoot

# プロファイルのパス
$profilePath = $PROFILE

# カスタムプロファイルのパス
$customProfilePath = Join-Path -Path (Split-Path -Parent $profilePath) -ChildPath $customProfileFileName

# 既存のプロファイルがある場合、かつ*.oldファイルが存在しない場合、*.oldにリネーム
if ((Test-Path -Path $profilePath) -and !(Test-Path -Path "$profilePath.old")) {
    Rename-Item -Path $profilePath -NewName "$profilePath.old" -Force
}

# シンボリックリンクが既に存在する場合、それを削除
if ((Get-Item -Path $profilePath -ErrorAction SilentlyContinue) -and (Get-ItemProperty -Path $profilePath).LinkType) {
    Remove-Item -Path $profilePath -Force
}

# プロファイルへのシンボリックリンクの作成
New-Item -ItemType SymbolicLink -Path $profilePath -Target "$localRepoDir\$profileFileName"

# カスタムプロファイルについても同様の処理
if ((Test-Path -Path $customProfilePath) -and !(Test-Path -Path "$customProfilePath.old")) {
    Rename-Item -Path $customProfilePath -NewName "$customProfilePath.old" -Force
}

if ((Get-Item -Path $customProfilePath -ErrorAction SilentlyContinue) -and (Get-ItemProperty -Path $customProfilePath).LinkType) {
    Remove-Item -Path $customProfilePath -Force
}

New-Item -ItemType SymbolicLink -Path $customProfilePath -Target "$localRepoDir\$customProfileFileName"
