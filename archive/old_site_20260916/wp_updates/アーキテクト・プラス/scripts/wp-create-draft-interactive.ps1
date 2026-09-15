param(
    [Parameter(Mandatory = $true)][string]$Title,
    [Parameter(Mandatory = $true)][string]$ContentFile,
    [int[]]$Categories = @(9),
    [string]$Status = "draft",
    [string]$Slug = ""
)

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

$env:ARCHITECT_PLUS_WP_BASE_URL = "https://www.ys-lamp.com/architect-plus/"
$env:ARCHITECT_PLUS_WP_USER = "codex-draft"
Write-Host "WordPressユーザー名: codex-draft"
$secure = Read-Host "Application Password" -AsSecureString
$appPassword = [System.Net.NetworkCredential]::new('', $secure).Password

try {
    $baseUrl = $env:ARCHITECT_PLUS_WP_BASE_URL.TrimEnd('/')
    $headers = @{
        Authorization = Get-BasicAuthHeader -User $env:ARCHITECT_PLUS_WP_USER -Password $appPassword
        "Content-Type" = "application/json; charset=utf-8"
    }

    Write-Host "1) API認証確認..."
    $me = Invoke-RestMethod -Method Get -Uri "$baseUrl/wp-json/wp/v2/users/me?context=edit" -Headers $headers
    Write-Host "Authenticated user: $($me.name) / ID: $($me.id)"

    Write-Host "2) 下書き投稿作成..."
    $content = Get-Content -LiteralPath $ContentFile -Raw -Encoding UTF8
    $bodyData = @{
        title = $Title
        content = $content
        status = $Status
        categories = $Categories
    }
    if (-not [string]::IsNullOrWhiteSpace($Slug)) {
        $bodyData.slug = $Slug
    }
    $body = $bodyData | ConvertTo-Json -Depth 20

    $result = Invoke-RestMethod -Method Post -Uri "$baseUrl/wp-json/wp/v2/posts" -Headers $headers -Body $body
    Write-Host "OK: 下書きを作成しました。"
    Write-Host "ID: $($result.id)"
    Write-Host "Slug: $($result.slug)"
    Write-Host "Link: $($result.link)"
}
catch {
    Show-ErrorDetail $_
    exit 1
}