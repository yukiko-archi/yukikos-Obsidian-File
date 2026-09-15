# ホームページ管理ログ

## 2026-08-29

- 旧ローカルアーカイブ内の `projects/docs/homepage_management_log.md` を確認。ちとせメタバースデザイン合同会社のHPは、過去ログ上ではWordPressではなく静的サイトとして作成し、GitHub Pagesで公開した記録がある。
- 確認できた公開情報: `https://yukiko-archi.github.io/yukikos-Obsidian-File/`、独自ドメイン `archi.chitose-d.net`。
- 2026-06-17にGoogleアナリティクス測定ID `G-WPB19868VH` とGoogleサーチコンソール所有権確認タグを設置し、GitHub Pagesへ反映済み。サーチコンソール所有権確認は完了済み。アナリティクスの実データ確認は旧ログ上で `#未確認`。
- 今回、Codexでホームページ更新を自動化する方針として、アーキテクト・プラスはWordPress REST API、ちとせメタバースデザイン合同会社はGitHub Pages/静的ファイル更新として分けて扱うことを整理した。
- 詳細メモ: [[wordpress_api_update_plan]] #未確認 #対応待ち
## 2026-08-29

- [[現在地]] / [[homepage_management_log]]：旧ローカルバックアップ `projects/docs` から、ちとせメタバースデザイン合同会社HPの静的サイト本体とHP関連メモを現行NAS側 `projects/docs/` へ復元。対象はHTML、`css/`、`js/`、`img/`、`CNAME`、設計メモ、関連Markdown。既存の現行ログは上書きせず、旧ログ全文は `homepage_management_log_旧ローカル_20260829.md` として別名保存した。 #対応済み

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：アーキテクト・プラスHPをWordPress REST APIで更新する準備を実施。`wp_updates/アーキテクト・プラス/` に `drafts/`、`media/`、`backups/`、`scripts/` を作成し、更新依頼テンプレート、環境変数例、API接続確認・バックアップ取得・下書き作成スクリプトを配置。構文チェックはOK。次の行動：管理画面URL、WordPressユーザー名、Application Password、更新対象種別を確認する。 #WordPress #REST_API #未確認 #対応待ち

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：Notion「ホームページ・インスタ管理」を確認し、アーキテクト・プラス/アーキテクト・プラスの公開サイト https://www.ys-lamp.com/architect-plus/、WordPressログインURL、関連資料Driveリンクを接続情報メモへ反映。REST API root https://www.ys-lamp.com/architect-plus/wp-json/ は認証なしでStatus 200、wp/v2 有効を確認。公開取得できる固定ページ・投稿・カテゴリ一覧を wp_updates/アーキテクト・プラス/backups/20260829_213702_public_inventory.md に保存。次の行動：WordPressユーザー名とApplication Passwordを確認して認証付きバックアップを取る。 #WordPress #REST_API #対応待ち

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：更新対象名を「アーキテクト・プラス」に修正し、作業フォルダを `wp_updates/アーキテクト・プラス/` に変更。テスト投稿本文 `drafts/2026-08-29_API投稿テスト.md` を作成。WordPressへの投稿実行は、WordPressユーザー名とApplication Password待ち。 #WordPress #REST_API #対応待ち

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：WordPress REST APIの認証確認に成功し、テスト記事「API投稿テスト（Codex）」を下書き作成。投稿IDは2179、リンクは https://www.ys-lamp.com/architect-plus/?p=2179。Application Passwordがチャットに貼られたため、確認後にWordPress側で削除し、必要なら再発行する。 #WordPress #REST_API #テスト投稿 #対応済み
C:\Users\inaka

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：`codex-draft` ユーザーのApplication PasswordでWordPress REST API認証確認に成功。Authenticated userは「ライターコーデックス」/ ID 3。テスト記事「API投稿テスト（Codex）」を下書き作成（投稿ID 2182、リンク https://www.ys-lamp.com/architect-plus/?p=2182）。Application Passwordがチャットに貼られたため、確認後に削除・再発行推奨。 #WordPress #REST_API #テスト投稿 #対応済み

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：ブログ記事「秘密基地のように使えるガレージを持つ暮らし」を作成し、WordPress REST APIで下書き投稿。投稿IDは2183、リンクは https://www.ys-lamp.com/architect-plus/?p=2183。原稿は `wp_updates/アーキテクト・プラス/drafts/2026-08-29_秘密基地のように使えるガレージ.md`。公開は管理者確認後。 #WordPress #REST_API #ブログ下書き #対応済み

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：ブログ記事「猫と暮らす家へ。スタッフ阿部自宅のリフォーム事例」を作成し、WordPress REST APIで下書き投稿。投稿IDは2184、リンクは https://www.ys-lamp.com/architect-plus/?p=2184。原稿は `wp_updates/アーキテクト・プラス/drafts/2026-08-29_猫と暮らす阿部自宅リフォーム.md`。内容は猫用自宅リフォーム、構造用合板の壁、耐震性にもつながる考え方。公開は管理者確認後。 #WordPress #REST_API #ブログ下書き #対応済み

## 2026-08-29

- [[アーキテクト・プラス_HP更新]]：今後のWordPress下書き作成では、毎回英数字とハイフンの分かりやすいスラッグを設定する運用に変更。既存下書きの投稿ID2183は `garage-secret-base-renovation`、投稿ID2184は `cat-friendly-home-renovation-abe` に更新。 #WordPress #REST_API #スラッグ #対応済み

## 2026-08-31

- [[アーキテクト・プラス_HP更新]]：スタッフ阿部の趣味ブログ「倉敷で着物と浴衣を楽しむ、スタッフ阿部の趣味の話」を作成し、WordPress REST APIで下書き投稿。投稿IDは2187、スラッグは `kurashiki-kimono-yukata-staff-abe`、リンクは https://www.ys-lamp.com/architect-plus/?p=2187。原稿は `wp_updates/アーキテクト・プラス/drafts/2026-08-31_倉敷で着物と浴衣を楽しむ.md`。公開は管理者確認後。 #WordPress #REST_API #ブログ下書き #対応済み
