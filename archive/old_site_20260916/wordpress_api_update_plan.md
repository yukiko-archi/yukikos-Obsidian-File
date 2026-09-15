# WordPress/API更新 運用メモ

## 目的

Codexからホームページ更新をできるだけ自動化する。

## 対象サイト

### アーキテクト・プラス

- 種別: WordPressサイト想定
- 更新方式: WordPress REST APIで進める
- 方針: まずは下書き作成または既存ページの取得確認まで。公開・本番更新は内容確認後に行う。
- 確認済み:
  - 公開サイト: $publicUrl 
  - WordPressログイン: $loginUrl 
  - Notion情報源: $sourceUrl 
- 未確認:
  - REST APIのベースURL
  - Codex用ユーザーまたはApplication Password
  - 更新対象が投稿・固定ページ・カスタム投稿のどれか

### ちとせメタバースデザイン合同会社

- 種別: 旧ログ上はWordPressではなく静的サイト
- 公開方式: GitHub Pages
- 公開URL: `https://yukiko-archi.github.io/yukikos-Obsidian-File/`
- 独自ドメイン: `archi.chitose-d.net`
- 更新方式: WordPress REST APIではなく、HTML/CSS/JavaScript等の静的ファイルを編集してGitHub Pagesへ反映する方針
- 旧ログ上の管理元: 旧ローカル `G:\docs` 相当
- 未確認:
  - 現在のGitHubリポジトリの正本
  - 現行NAS側に公開ファイルが移行済みか
  - GitHubへのpush権限

## 基本方針

- WordPressサイトはREST APIで更新する。
- 静的サイトはGit/GitHub Pages更新で扱う。
- 認証情報は通常パスワードではなく、WordPress Application PasswordやGitHub認証を使う。
- 最初は本番公開せず、下書き・プレビュー・差分確認を優先する。
- 更新後は `WORK_LOG.md` と `projects/docs/homepage_management_log.md` に記録する。

## WordPress API更新の安全手順

1. `GET /wp-json/` でREST APIが有効か確認する。
2. Application Passwordで `GET /wp-json/wp/v2/users/me` を確認する。
3. 投稿・固定ページ一覧を取得し、対象IDを確認する。
4. 更新前のJSONまたは本文をローカルに保存する。
5. 新規投稿は `status: draft` で作成する。
6. 既存ページ更新は、差分を確認してから実行する。
7. 公開または更新後に表示確認する。
8. 作業ログを追記する。

## 原稿置き場案

- `projects/docs/wp_updates/アーキテクト・プラス/`
- `projects/docs/wp_updates/ちとせメタバースデザイン/`

## 次の行動

- アーキテクト・プラスのWordPressユーザー名とApplication Passwordを確認する。 #未確認
- アーキテクト・プラス用のApplication Passwordを作成する。 #未確認
- ちとせメタバースデザイン合同会社HPの現行GitHubリポジトリ場所を確認する。 #未確認