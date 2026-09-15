# アーキテクト・プラス_HP更新

## 開始日

2026-08-29

## 概要

アーキテクト・プラスのホームページ更新を、CodexからWordPress REST APIで進めるための案件メモ。

## 関係者

- アーキテクト・プラス
- 阿部さん
- Codex

## 現在の状態

- API更新の準備中。
- Notionから公開サイトURLとWordPressログインURLを確認済み。
- Application Password と更新対象種別は未確認。
- まずは下書き作成・既存ページ取得・バックアップ取得までを安全範囲にする。

## 決定事項

- WordPress管理画面の画面操作ではなく、WordPress REST APIで更新する。
- 認証情報はファイルに保存しない。
- `ARCHITECT_PLUS_WP_BASE_URL`、`ARCHITECT_PLUS_WP_USER`、`ARCHITECT_PLUS_WP_APP_PASSWORD` の環境変数から読む。
- 本番公開は、下書きまたはプレビュー確認後に行う。

## 次の行動

- WordPressユーザー名とApplication Passwordを確認する。
- WordPressでCodex用のApplication Passwordを作成する。
- `scripts/wp-api-check.ps1` で接続確認する。
- `scripts/wp-backup-content.ps1` で投稿・固定ページ一覧をバックアップする。

## 未確認・対応待ち

- 公開サイト: https://www.ys-lamp.com/architect-plus/ #確認済み
- WordPressログイン: https://www.ys-lamp.com/architect-plus/ap/login_78662plus.php #確認済み
- REST API root候補: https://www.ys-lamp.com/architect-plus/wp-json/ #未確認
- Codex用ユーザー名 #未確認
- Application Password #未確認
- 更新対象が投稿・固定ページ・施工事例などのカスタム投稿か #未確認

## 関連ファイル

- `wp_updates/アーキテクト・プラス/README.md`
- `wp_updates/アーキテクト・プラス/更新依頼テンプレート.md`
- `wp_updates/アーキテクト・プラス/.env.example`
- `wp_updates/アーキテクト・プラス/scripts/wp-api-check.ps1`
- `wp_updates/アーキテクト・プラス/scripts/wp-backup-content.ps1`
- `wp_updates/アーキテクト・プラス/scripts/wp-create-draft-post.ps1`

## キーワード

#ホームページ #WordPress #REST_API #アーキテクト・プラス #未確認 #対応待ち

## ログ

### 2026-08-29

- 内容: Notionページ https://app.notion.com/p/280f6e2297f4809cbe7be7c9ca069dea?source=copy_link を確認し、公開サイト https://www.ys-lamp.com/architect-plus/ とWordPressログイン https://www.ys-lamp.com/architect-plus/ap/login_78662plus.php を接続情報メモへ反映。
- 内容: CodexでWordPress REST API更新を行うための準備を開始。安全のため、まずは接続確認・バックアップ取得・下書き作成の範囲に限定する。
- 決定事項: 認証情報はファイルに保存せず、環境変数で扱う。
- 未確認: 管理画面URL、REST API URL、Application Password、更新対象種別。
- 次の行動: 接続情報がそろったらAPI接続確認を行う。
- キーワード: #ホームページ #WordPress #REST_API #未確認
### 2026-08-29 APIテスト投稿

- 内容: WordPress REST APIで認証確認を実施し、テスト記事を下書き作成。
- 認証確認: 成功。Authenticated user: アーキテクト・プラス / ID: 2。
- 作成結果: 投稿ID 2179、リンク https://www.ys-lamp.com/architect-plus/?p=2179。
- 公開状態: draft（下書き）。
- 注意: Application Passwordがチャットに貼られたため、確認後にWordPress側で削除し、必要なら新しいApplication Passwordを作り直す。
- 次の行動: 管理画面で下書き内容を確認し、不要なら削除または非公開のまま残す。
- キーワード: #WordPress #REST_API #テスト投稿 #対応済み

### 2026-08-29 codex-draft APIテスト投稿

- 内容: `codex-draft` ユーザーのApplication PasswordでWordPress REST API認証確認を実施し、テスト記事を下書き作成。
- 認証確認: 成功。Authenticated user: ライターコーデックス / ID: 3。
- 作成結果: 投稿ID 2182、リンク https://www.ys-lamp.com/architect-plus/?p=2182。
- 公開状態: draft（下書き）。
- 注意: Application Passwordがチャットに貼られたため、確認後にWordPress側で削除し、必要なら新しいApplication Passwordを作り直す。
- 次の行動: 投稿ID 2182の下書きを確認し、不要なら削除。今後は下書き投稿用の安全な認証受け渡し方法を決める。
- キーワード: #WordPress #REST_API #テスト投稿 #codex-draft #対応済み

### 2026-08-29 実記事下書き作成

- 内容: ブログ記事「秘密基地のように使えるガレージを持つ暮らし」を作成し、`codex-draft` ユーザーでWordPress REST APIから下書き投稿。
- 原稿: `wp_updates/アーキテクト・プラス/drafts/2026-08-29_秘密基地のように使えるガレージ.md`
- 作成結果: 投稿ID 2183、リンク https://www.ys-lamp.com/architect-plus/?p=2183。
- 公開状態: draft（下書き）。
- カテゴリ: お知らせ（ID 9）。
- 次の行動: 管理画面で内容を確認し、必要ならタイトル・本文・カテゴリを調整する。公開は管理者確認後。
- キーワード: #WordPress #REST_API #ブログ下書き #ガレージ #対応済み

### 2026-08-29 猫用リフォーム記事下書き作成

- 内容: ブログ記事「猫と暮らす家へ。スタッフ阿部自宅のリフォーム事例」を作成し、`codex-draft` ユーザーでWordPress REST APIから下書き投稿。
- 原稿: `wp_updates/アーキテクト・プラス/drafts/2026-08-29_猫と暮らす阿部自宅リフォーム.md`
- 作成結果: 投稿ID 2184、リンク https://www.ys-lamp.com/architect-plus/?p=2184。
- 公開状態: draft（下書き）。
- カテゴリ: 施工事例（ID 1）。
- 内容メモ: 猫と暮らすための自宅リフォーム、ビスが打てる構造用合板の壁、設計・施工方法次第で耐震性向上にもつながる点を記載。
- 次の行動: 管理画面で内容を確認し、必要ならタイトル・本文・カテゴリ・アイキャッチを調整する。公開は管理者確認後。
- キーワード: #WordPress #REST_API #ブログ下書き #猫 #リフォーム #構造用合板 #耐震 #対応済み

### 2026-08-29 スラッグ運用ルール追加

- 内容: 今後のWordPress下書き作成では、毎回英数字とハイフンの分かりやすいスラッグを設定する方針にした。
- 更新済み: 投稿ID 2183 のスラッグを `garage-secret-base-renovation` に変更。
- 更新済み: 投稿ID 2184 のスラッグを `cat-friendly-home-renovation-abe` に変更。
- 関連スクリプト: `wp-create-draft-interactive.ps1` に `-Slug` 引数を追加、`wp-update-post-slug-interactive.ps1` を作成。
- キーワード: #WordPress #REST_API #スラッグ #対応済み

### 2026-08-31 スタッフ阿部の着物・浴衣ブログ下書き作成

- 内容: ブログ記事「倉敷で着物と浴衣を楽しむ、スタッフ阿部の趣味の話」を作成し、`codex-draft` ユーザーでWordPress REST APIから下書き投稿。
- 原稿: `wp_updates/アーキテクト・プラス/drafts/2026-08-31_倉敷で着物と浴衣を楽しむ.md`
- 作成結果: 投稿ID 2187、リンク https://www.ys-lamp.com/architect-plus/?p=2187。
- スラッグ: `kurashiki-kimono-yukata-staff-abe`
- 公開状態: draft（下書き）。
- カテゴリ: お知らせ（ID 9）。
- 内容メモ: スタッフ阿部の趣味ブログとして、倉敷美観地区を着物や浴衣で歩く楽しさ、友達とのビールやランチ、娘が浴衣を着て花火に行った話、いつか娘のデートで着付けできるかもしれない気持ちを記載。
- 次の行動: 管理画面で内容を確認し、必要ならタイトル・本文・カテゴリ・アイキャッチを調整する。公開は管理者確認後。
- キーワード: #WordPress #REST_API #ブログ下書き #スタッフ阿部 #着物 #浴衣 #倉敷 #対応済み
