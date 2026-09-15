$ErrorActionPreference = "Stop"

function Read-RequiredText {
    param([string]$Prompt)
    $value = Read-Host $Prompt
    if ([string]::IsNullOrWhiteSpace($value)) {
        throw "$Prompt が空です。"
    }
    return $value.Trim()
}

Write-Host "アーキテクト・プラス WordPress API テスト投稿"
Write-Host "Application Passwordは通常のログインパスワードではなく、プロフィール画面で発行したものを使います。"
Write-Host "スペース入り表示のまま貼り付けてOKです。"
Write-Host ""

$env:ARCHITECT_PLUS_WP_BASE_URL = "https://www.ys-lamp.com/architect-plus/"
$env:ARCHITECT_PLUS_WP_USER = "codex-draft"
Write-Host "WordPressユーザー名: codex-draft"
$secure = Read-Host "Application Password" -AsSecureString
$env:ARCHITECT_PLUS_WP_APP_PASSWORD = [System.Net.NetworkCredential]::new('', $secure).Password

Write-Host ""
Write-Host "1) API認証確認を実行します..."
& (Join-Path $PSScriptRoot 'wp-api-check.ps1')

Write-Host ""
Write-Host "2) テスト記事を下書き作成します..."
$contentFile = Join-Path (Split-Path $PSScriptRoot -Parent) 'drafts\2026-08-29_API投稿テスト.md'
& (Join-Path $PSScriptRoot 'wp-create-draft-post.ps1') -Title 'API投稿テスト（Codex）' -ContentFile $contentFile -Status draft

Write-Host ""
Write-Host "完了しました。この画面を閉じずに、表示されたIDとLinkを確認してください。"