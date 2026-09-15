param(
    [string]$OutDir = "..\backups"
)

$ErrorActionPreference = "Stop"

function Get-BasicAuthHeader {
    param([string]$User, [string]$Password)
    $pair = "${User}:${Password}"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
    return "Basic " + [Convert]::ToBase64String($bytes)
}

$baseUrl = $env:ARCHITECT_PLUS_WP_BASE_URL
$user = $env:ARCHITECT_PLUS_WP_USER
$appPassword = $env:ARCHITECT_PLUS_WP_APP_PASSWORD

if ([string]::IsNullOrWhiteSpace($baseUrl) -or [string]::IsNullOrWhiteSpace($user) -or [string]::IsNullOrWhiteSpace($appPassword)) {
    throw "環境変数 ARCHITECT_PLUS_WP_BASE_URL, ARCHITECT_PLUS_WP_USER, ARCHITECT_PLUS_WP_APP_PASSWORD を設定してください。"
}

$baseUrl = $baseUrl.TrimEnd('/')
$headers = @{ Authorization = Get-BasicAuthHeader -User $user -Password $appPassword }
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$resolvedOut = Join-Path $PSScriptRoot $OutDir
New-Item -ItemType Directory -Force -Path $resolvedOut | Out-Null

$targets = @(
    @{ Name = "posts"; Url = "$baseUrl/wp-json/wp/v2/posts?context=edit&per_page=100" },
    @{ Name = "pages"; Url = "$baseUrl/wp-json/wp/v2/pages?context=edit&per_page=100" }
)

foreach ($target in $targets) {
    Write-Host "取得中: $($target.Name)"
    $data = Invoke-RestMethod -Method Get -Uri $target.Url -Headers $headers
    $path = Join-Path $resolvedOut "$stamp`_$($target.Name).json"
    $data | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $path -Encoding utf8
    Write-Host "保存: $path"
}

Write-Host "OK: バックアップ取得が完了しました。"