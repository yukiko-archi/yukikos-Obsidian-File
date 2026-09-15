param(
    [Parameter(Mandatory = $true)][int]$PostId,
    [Parameter(Mandatory = $true)][string]$Slug
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

$baseUrl = "https://www.ys-lamp.com/architect-plus/".TrimEnd('/')
$user = "codex-draft"
Write-Host "WordPressユーザー名: $user"
$secure = Read-Host "Application Password" -AsSecureString
$appPassword = [System.Net.NetworkCredential]::new('', $secure).Password
$headers = @{
    Authorization = Get-BasicAuthHeader -User $user -Password $appPassword
    "Content-Type" = "application/json; charset=utf-8"
}

try {
    $body = @{ slug = $Slug } | ConvertTo-Json -Depth 5
    $result = Invoke-RestMethod -Method Post -Uri "$baseUrl/wp-json/wp/v2/posts/$PostId" -Headers $headers -Body $body
    Write-Host "OK: スラッグを更新しました。"
    Write-Host "ID: $($result.id)"
    Write-Host "Slug: $($result.slug)"
    Write-Host "Link: $($result.link)"
}
catch {
    Show-ErrorDetail $_
    exit 1
}