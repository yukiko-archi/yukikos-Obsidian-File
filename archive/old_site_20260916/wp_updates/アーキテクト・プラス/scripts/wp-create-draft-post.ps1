param(
    [Parameter(Mandatory = $true)][string]$Title,
    [Parameter(Mandatory = $true)][string]$ContentFile,
    [string]$Status = "draft"
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

if (-not (Test-Path -LiteralPath $ContentFile)) {
    throw "本文ファイルが見つかりません: $ContentFile"
}

$baseUrl = $baseUrl.TrimEnd('/')
$headers = @{
    Authorization = Get-BasicAuthHeader -User $user -Password $appPassword
    "Content-Type" = "application/json; charset=utf-8"
}

$content = Get-Content -LiteralPath $ContentFile -Raw -Encoding UTF8
$body = @{
    title = $Title
    content = $content
    status = $Status
} | ConvertTo-Json -Depth 20

$result = Invoke-RestMethod -Method Post -Uri "$baseUrl/wp-json/wp/v2/posts" -Headers $headers -Body $body
Write-Host "OK: 下書きを作成しました。"
Write-Host "ID: $($result.id)"
Write-Host "Link: $($result.link)"