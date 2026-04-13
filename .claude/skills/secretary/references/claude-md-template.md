# CLAUDE.md 生成テンプレート

オンボーディング時に `.secretary/CLAUDE.md` を生成するためのテンプレート。
`{{...}}` で囲まれた変数はオンボーディングで収集したユーザー固有の値に置換される。

---

## テンプレート

````markdown
# Secretary - パーソナル管理システム

## ユーザープロフィール

- **役割**: {{USER_ROLE}}
- **ワークスタイル**: {{WORK_STYLE}}
- **言語**: {{LANGUAGE}}
- **作成日**: {{CREATED_DATE}}

## ディレクトリ構成

```
.secretary/
{{DIRECTORY_TREE}}
```

### 各フォルダの目的

{{FOLDER_DESCRIPTIONS}}

## ファイル命名規則

- **日次ファイル**: `YYYY-MM-DD.md`（例: `2026-03-07.md`）
- **トピックファイル**: `descriptive-kebab-case-title.md`（例: `api-redesign-plan.md`）
- **テンプレート**: `_template.md`（各カテゴリフォルダに1つ。変更しない）
- **レビュー**: 週次は `YYYY-WXX.md`、月次は `YYYY-MM.md`

## TODO形式

タスクは以下の形式で記述する:

```markdown
- [ ] タスク内容 | 優先度: 高/通常/低 | 期限: YYYY-MM-DD
- [x] 完了タスク | 優先度: 通常 | 完了: YYYY-MM-DD
```

優先度レベル:
- **高**: 今日中にやる / 重要
- **通常**: 今週中にやる
- **低**: 余裕があれば / いつか

## コンテンツ追加ルール

1. **まずinboxへ**: どこに入れるか迷ったら `inbox/` に入れる
2. **テンプレートを使う**: 新規ファイル作成時は必ず `_template.md` をコピーして使う
3. **上書き禁止**: 既存の日次ファイルには追記のみ、置き換えない
4. **タイムスタンプ**: ファイルに追記する際はタイムスタンプを付ける
5. **1トピック1ファイル**: ideas/, research/, knowledge/ ではトピックごとにファイルを分ける

## レビューサイクル

- **デイリー**: 1日の始まりと終わりにTODOファイルを確認
- **ウィークリー**: 毎週日曜か月曜に `reviews/` に週次レビューを生成
- **マンスリー**（任意）: 完了項目のレビューとアーカイブ

## クイックコマンド一覧

`/secretary` を既存セットアップで実行した場合:

| コマンド | 動作 |
|---------|------|
| "タスク追加 [内容]" | 今日のTODOファイルにタスクを追加 |
| "今日のタスク" | 今日の日次ファイルを表示 |
| "メモ [内容]" | inboxにクイックキャプチャ |
| "アイデア [タイトル]" | テンプレートからアイデアファイルを新規作成 |
| "調査 [タイトル]" | テンプレートからリサーチファイルを新規作成 |
| "週次レビュー" | 週次レビューを生成 |
| "ダッシュボード" | 全体概要を表示 |
| "受信箱整理" | inboxの整理を支援 |
| "カテゴリ追加 [名前]" | 新しいカテゴリフォルダを追加 |

## パーソナライズメモ

{{PERSONALIZATION_NOTES}}
````

---

## 変数リファレンス

| 変数 | ソース | 説明 |
|------|--------|------|
| `{{USER_ROLE}}` | Step 2a | ユーザーの役割・職業 |
| `{{WORK_STYLE}}` | Step 2b | 日常のルーティン要約 |
| `{{LANGUAGE}}` | Step 2d | ja / en / bilingual |
| `{{CREATED_DATE}}` | 自動 | オンボーディング実施日 |
| `{{DIRECTORY_TREE}}` | Step 3 | 確認済みフォルダツリー |
| `{{FOLDER_DESCRIPTIONS}}` | Step 3 | 選択カテゴリから生成 |
| `{{PERSONALIZATION_NOTES}}` | Step 2 | ユーザーからの追加コンテキスト |

---

## フォルダ説明スニペット

`{{FOLDER_DESCRIPTIONS}}` を生成する際に使用:

| カテゴリ | 説明（日本語） | Description (EN) |
|---------|---------------|------------------|
| todos | デイリータスク管理。1日1ファイル。 | Daily task management. One file per day. |
| ideas | アイデアの記録と発展。1アイデア1ファイル。 | Capture and develop ideas. One file per idea. |
| research | 調査・リサーチの記録。1トピック1ファイル。 | In-depth investigation and findings. One file per topic. |
| knowledge | 永続的なナレッジノート。トピック別に整理。 | Permanent reference notes. Organized by topic. |
| inbox | 未整理の思いつきをクイックキャプチャ。後で整理。 | Quick capture for unprocessed thoughts. Sort later. |
| reviews | 週次・月次のレビューファイル。 | Weekly and monthly review files. |
| meetings | 議事録とアクションアイテム。 | Meeting notes and action items. |
| clients | クライアント情報とコミュニケーション履歴。 | Client information and communication logs. |
| content-plan | コンテンツ制作パイプライン。プラットフォーム別に整理。 | Content creation pipeline. Organized by platform. |
| reading-list | 読みたい本・読書中・読了の管理。 | Books and articles to read, currently reading, and finished. |
| journal | 日記・振り返り。 | Daily diary and reflections. |
| debugging | バグレポートと調査ログ。 | Bug reports and investigation logs. |
| projects | プロジェクト別の計画と進捗管理。 | Project-specific planning and tracking. |
| finances | 財務管理と請求書。 | Financial tracking and invoices. |
