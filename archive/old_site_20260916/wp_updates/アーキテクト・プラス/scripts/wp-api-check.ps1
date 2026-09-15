param()

$ErrorActionPreference = "Stop"

function Get-BasicAuthHeader {
    param([string]$User, [string]$Password)
    $pair = "${User}:${Password}"
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($pair)
    return "Basic " + [Convert]::ToBase64String($bytes)
}

function Show-ErrorDetail {
    param($ErrorRecord)
    Write-Host "ERROR: $($ErrorRecord.Exception.Message)"
    if ($ErrorRecord.ErrorDetails -and $ErrorRecord.ErrorDetails.Message) {
        Write-Host $ErrorRecord.ErrorDetails.Message
    }
    if ($ErrorRecord.Exception.Response) {
        Write-Host "Status: $([int]$ErrorRecord.Exception.Response.StatusCode)"
    }
}

$baseUrl = $env:ARCHITECT_PLUS_WP_BASE_URL
$user = $env:ARCHITECT_PLUS_WP_USER
$appPassword = $env:ARCHITECT_PLUS_WP_APP_PASSWORD

if ([string]::IsNullOrWhiteSpace($baseUrl) -or [string]::IsNullOrWhiteSpace($user) -or [string]::IsNullOrWhiteSpace($appPassword)) {
    throw "環境変数 ARCHITECT_PLUS_WP_BASE_URL, ARCHITECT_PLUS_WP_USER, ARCHITECT_PLUS_WP_APP_PASSWORD を設定してください。"
}

$baseUrl = $baseUrl.TrimEnd('/')
$headers = @{ Authorization = Get-BasicAuthHeader -User $user -Password $appPassword }

try {
    Write-Host "REST API root確認: $baseUrl/wp-json/"
    $root = Invoke-RestMethod -Method Get -Uri "$baseUrl/wp-json/"
    Write-Host "Site: $($root.name)"

    Write-Host "認証確認: $baseUrl/wp-json/wp/v2/users/me?context=edit"
    $me = Invoke-RestMethod -Method Get -Uri "$baseUrl/wp-json/wp/v2/users/me?context=edit" -Headers $headers
    Write-Host "Authenticated user: $($me.name) / ID: $($me.id)"
    Write-Host "OK: WordPress REST APIへ接続できました。"
}
catch {
    Show-ErrorDetail $_
    exit 1
}