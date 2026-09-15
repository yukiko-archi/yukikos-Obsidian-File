# アーキテクト・プラス WordPress更新準備

このフォルダは、アーキテクト・プラスHPをCodexからWordPress REST APIで更新するための作業場所。

## フォルダ

- `drafts/`: 更新原稿や下書き用Markdownを置く。
- `media/`: アップロード予定画像を置く。
- `backups/`: APIで取得した更新前データを保存する。
- `scripts/`: API接続確認・バックアップ取得・下書き作成スクリプト。

## 確認済み情報

- 公開サイト: https://www.ys-lamp.com/architect-plus/
- WordPressログイン: https://www.ys-lamp.com/architect-plus/ap/login_78662plus.php
- Notion情報源: https://app.notion.com/p/280f6e2297f4809cbe7be7c9ca069dea?source=copy_link
- まさいさんより資料: https://drive.google.com/drive/u/3/folders/10AqG6IM1WZ53KyRcJDpBY0Bh46aFw-1N

## 最初に必要な情報

- WordPressユーザー名
- Application Password
- 更新対象の種類: 投稿、固定ページ、施工事例など

## 環境変数

秘密情報はファイルに書かず、PowerShellの環境変数で渡す。

```powershell
$env:ARCHITECT_PLUS_WP_BASE_URL = "https://www.ys-lamp.com/architect-plus/"
$env:ARCHITECT_PLUS_WP_USER = "codex-user"
$env:ARCHITECT_PLUS_WP_APP_PASSWORD = "xxxx xxxx xxxx xxxx xxxx xxxx"
```


## 公開API確認結果

2026-08-29に認証なしで https://www.ys-lamp.com/architect-plus/wp-json/ へ接続確認済み。

- Site name: アーキテクト・プラス
- Site URL: https://www.ys-lamp.com/architect-plus/ap
- 利用可能namespace: wp/v2 ほか
- 投稿・固定ページ・メディア・カテゴリのRESTルートあり
- 公開取得できた一覧: backups/20260829_213702_public_inventory.md
## 作業順

1. `wp-api-check.ps1` で認証確認。
2. `wp-backup-content.ps1` で投稿・固定ページの一覧をバックアップ。
3. 更新依頼を `更新依頼テンプレート.md` に沿って作る。
4. `wp-create-draft-post.ps1` で下書きを作成。
5. プレビュー確認後に公開する。

## スラッグ方針

- 下書き作成時に、英数字とハイフンの分かりやすいスラッグを必ず設定する。
- 日本語タイトルをそのままURLにしない。
- 例: `garage-secret-base-renovation`, `cat-friendly-home-renovation-abe`

## 注意

- 初回は公開まで自動化しない。
- 既存ページ更新の前には、必ずバックアップを取る。
- Application Passwordは、WordPressのユーザープロフィール画面で作成し、不要になったら取り消す。