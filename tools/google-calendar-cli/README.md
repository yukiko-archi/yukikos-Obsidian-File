# Google Calendar CLI (Gemini CLI連携用)

Gemini CLIから直接呼び出せる、Google CalendarのCRUD（追加・更新・削除・一覧）用CLIです。

## 1) 事前準備（Google Cloud）

1. [Google Cloud Console](https://console.cloud.google.com/) でプロジェクト作成
2. `Google Calendar API` を有効化
3. OAuth同意画面を設定（Externalでも可）
4. 「認証情報」->「OAuth クライアントID」-> `Desktop app` を作成
5. ダウンロードしたJSONを `tools/google-calendar-cli/credentials.json` に保存

## 2) ローカルセットアップ

```bash
cd tools/google-calendar-cli
npm install
node calendar-cli.js auth
```

`auth` 実行時にURLが表示されるのでブラウザで許可してください。  
成功すると `token.json` が作成されます。

## 3) 使い方

### 一覧取得
```bash
node calendar-cli.js list --from "2026-05-10T00:00:00+09:00" --to "2026-05-11T00:00:00+09:00"
```

### 予定追加
```bash
node calendar-cli.js add --title "打ち合わせ" --start "2026-05-11T14:00:00+09:00" --end "2026-05-11T15:00:00+09:00" --description "現場確認" --location "オンライン"
```

### 予定更新
```bash
node calendar-cli.js update --id "<eventId>" --start "2026-05-11T16:00:00+09:00" --end "2026-05-11T17:00:00+09:00"
```

### 予定削除
```bash
node calendar-cli.js delete --id "<eventId>"
```

## 4) Gemini CLIでの運用例

- 「`tools/google-calendar-cli` で、明日14:00-15:00の予定を追加して」
- 「タイトルが打ち合わせのイベントを一覧して、該当IDを16:00開始に更新して」
- 「イベントID `xxxx` を削除して」

## 補足

- デフォルト対象カレンダーは `primary`。  
  別カレンダーは `--calendar "<calendarId>"` を指定してください。
- `credentials.json` と `token.json` は機密情報なので共有しないでください。
