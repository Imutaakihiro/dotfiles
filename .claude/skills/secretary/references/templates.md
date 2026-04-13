# Secretary テンプレート集

`.secretary/` フォルダ生成時に使用するカテゴリ別テンプレート。
オンボーディング Step 2d の言語設定に応じて、日本語版または英語版を使い分ける。

---

## テンプレート選択ロジック

Step 2c で選択されたカテゴリに対応するテンプレートを使用する。
各カテゴリフォルダに `_template.md` を配置する。

---

## 1. デイリーTODO

### 日本語版

```markdown
---
date: "{{YYYY-MM-DD}}"
type: daily
---

# {{YYYY-MM-DD}} ({{DAY_OF_WEEK}})

## 最優先
- [ ]

## 通常
- [ ]

## 余裕があれば
- [ ]

## 完了
- [x] (完了したらここに移動)

## メモ・振り返り
-
```

### English

```markdown
---
date: "{{YYYY-MM-DD}}"
type: daily
---

# {{YYYY-MM-DD}} ({{DAY_OF_WEEK}})

## High Priority
- [ ]

## Normal
- [ ]

## Low Priority
- [ ]

## Completed
- [x] (move here when done)

## Notes / Reflections
-
```

---

## 2. アイデア

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
status: draft
tags: []
---

# [アイデアタイトル]

## 概要
どんなアイデア？

## 課題・背景
どんな問題を解決する？

## 解決策
どうやって実現する？

## ネクストステップ
- [ ]
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
status: draft
tags: []
---

# [Idea Title]

## Overview
What is this idea about?

## Problem / Background
What problem does this solve?

## Proposed Solution
How would this work?

## Next Steps
- [ ]
```

---

## 3. リサーチ

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
status: in-progress
tags: []
---

# [リサーチタイトル]

## 目的
なぜ調査するのか？

## 調査内容

### 情報源 1
- URL:
- 要点:

### 情報源 2
- URL:
- 要点:

## 結論
調査結果のまとめと推奨事項。

## 参考リンク
-
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
status: in-progress
tags: []
---

# [Research Title]

## Purpose
Why are we researching this?

## Findings

### Source 1
- URL:
- Key points:

### Source 2
- URL:
- Key points:

## Conclusion
Summary of findings and recommendations.

## References
-
```

---

## 4. ナレッジ

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
topic: ""
tags: []
---

# [トピック]

## ポイント
-

## 詳細


## 参考リンク
-

## メモ
-
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
topic: ""
tags: []
---

# [Topic]

## Key Points
-

## Details


## Reference Links
-

## Notes
-
```

---

## 5. Inbox（クイックキャプチャ）

### 日本語版

```markdown
---
date: "{{YYYY-MM-DD}}"
type: inbox
---

# Inbox - {{YYYY-MM-DD}}

## キャプチャ

- **{{HH:MM}}** |
```

### English

```markdown
---
date: "{{YYYY-MM-DD}}"
type: inbox
---

# Inbox - {{YYYY-MM-DD}}

## Captures

- **{{HH:MM}}** |
```

---

## 6. 週次レビュー

### 日本語版

```markdown
---
week: "{{YYYY}}-W{{WW}}"
period: "{{START_DATE}} ~ {{END_DATE}}"
type: review
---

# 週次レビュー: {{YYYY}}-W{{WW}}

## 完了したタスク
- [x] 今週のデイリーファイルから完了項目を集める

## うまくいったこと
-

## 改善できること
-

## 学び・気づき
-

## 来週の目標
- [ ]

## 持ち越し（未完了）
- [ ]
```

### English

```markdown
---
week: "{{YYYY}}-W{{WW}}"
period: "{{START_DATE}} ~ {{END_DATE}}"
type: review
---

# Weekly Review: {{YYYY}}-W{{WW}}

## Completed Tasks
- [x] Gather completed items from this week's daily files

## What Went Well
-

## What Could Be Improved
-

## Learnings
-

## Next Week's Goals
- [ ]

## Carried Over (Incomplete)
- [ ]
```

---

## 7. 議事録

### 日本語版

```markdown
---
date: "{{YYYY-MM-DD}}"
attendees: []
tags: []
---

# MTG: [タイトル]

## アジェンダ
1.

## 議事内容
-

## アクションアイテム
- [ ] @誰 - 何を - いつまでに

## 決定事項
-
```

### English

```markdown
---
date: "{{YYYY-MM-DD}}"
attendees: []
tags: []
---

# Meeting: [Title]

## Agenda
1.

## Discussion Notes
-

## Action Items
- [ ] @who - what - by when

## Decisions Made
-
```

---

## 8. クライアント管理

### 日本語版

```markdown
---
client: ""
created: "{{YYYY-MM-DD}}"
status: active
---

# クライアント: [名前]

## 連絡先
- 名前:
- メール:
- 会社:

## プロジェクト
-

## コミュニケーション履歴

### {{YYYY-MM-DD}}
-

## メモ
-
```

### English

```markdown
---
client: ""
created: "{{YYYY-MM-DD}}"
status: active
---

# Client: [Name]

## Contact Info
- Name:
- Email:
- Company:

## Projects
-

## Communication Log

### {{YYYY-MM-DD}}
-

## Notes
-
```

---

## 9. コンテンツ企画

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
platform: ""
status: draft
publish_date: ""
tags: []
---

# [コンテンツタイトル]

## プラットフォーム
ブログ / YouTube / SNS / その他

## ターゲット
誰に向けたコンテンツ？

## 構成
1.
2.
3.

## キーメッセージ


## 下書き・台本


## ステータス
- [ ] 構成
- [ ] 下書き
- [ ] レビュー
- [ ] 公開済み
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
platform: ""
status: draft
publish_date: ""
tags: []
---

# [Content Title]

## Platform
Blog / YouTube / Social / Other

## Target Audience
Who is this for?

## Outline
1.
2.
3.

## Key Message


## Draft / Script


## Status
- [ ] Outline
- [ ] Draft
- [ ] Review
- [ ] Published
```

---

## 10. 読書リスト

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
type: reading-list
---

# 読書リスト

## 読書中
| タイトル | 著者 | 開始日 | 進捗 |
|---------|------|-------|------|
|         |      |       |      |

## 読みたい
| タイトル | 著者 | 優先度 | 追加日 |
|---------|------|-------|-------|
|         |      |       |       |

## 読了
| タイトル | 著者 | 読了日 | 評価 | メモ |
|---------|------|-------|------|------|
|         |      |       |      |      |
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
type: reading-list
---

# Reading List

## Currently Reading
| Title | Author | Started | Progress |
|-------|--------|---------|----------|
|       |        |         |          |

## To Read
| Title | Author | Priority | Added |
|-------|--------|----------|-------|
|       |        |          |       |

## Finished
| Title | Author | Finished | Rating | Notes |
|-------|--------|----------|--------|-------|
|       |        |          |        |       |
```

---

## 11. 日記・ジャーナル

### 日本語版

```markdown
---
date: "{{YYYY-MM-DD}}"
mood: ""
type: journal
---

# {{YYYY-MM-DD}} ({{DAY_OF_WEEK}})

## 今日のハイライト
-

## 考えたこと
-

## 感謝
-
```

### English

```markdown
---
date: "{{YYYY-MM-DD}}"
mood: ""
type: journal
---

# {{YYYY-MM-DD}} ({{DAY_OF_WEEK}})

## Today's Highlights
-

## Thoughts
-

## Gratitude
-
```

---

## 12. デバッグログ（開発者向け）

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
status: open
tags: []
---

# [バグ・問題のタイトル]

## 症状
何が起きている？

## 期待する動作
本来どうなるべき？

## 再現手順
1.

## 調査

### 仮説 1
-

### 発見
-

## 解決策
-

## 再発防止
今後どう防ぐ？
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
status: open
tags: []
---

# [Bug / Issue Title]

## Symptom
What is happening?

## Expected Behavior
What should happen?

## Reproduction Steps
1.

## Investigation

### Hypothesis 1
-

### Findings
-

## Solution
-

## Prevention
How to prevent this in the future?
```

---

## 13. 汎用テンプレート

ユーザーが追加するカスタムカテゴリ用のフォールバック。

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
tags: []
---

# [タイトル]

## 内容
-

## メモ
-
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
tags: []
---

# [Title]

## Content
-

## Notes
-
```

---

## 14. OKR / 目標管理

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
period: ""
type: okr
---

# OKR: [期間]

## Objective（目指す状態）


## Key Results
- [ ] KR1:
- [ ] KR2:
- [ ] KR3:

## 週次チェックイン

### {{YYYY-MM-DD}}
- 進捗:
- 課題:
- 次のアクション:
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
period: ""
type: okr
---

# OKR: [Period]

## Objective


## Key Results
- [ ] KR1:
- [ ] KR2:
- [ ] KR3:

## Weekly Check-in

### {{YYYY-MM-DD}}
- Progress:
- Blockers:
- Next Actions:
```

---

## 15. Belief Building コンテンツ企画

### 日本語版

```markdown
---
created: "{{YYYY-MM-DD}}"
belief_stage: ""
platform: ""
status: draft
---

# コンテンツ企画: [タイトル]

## Belief ステージ
- [ ] B-1: 問題理解・共感（Cold→Warm）
- [ ] B-2: 他の選択肢の評価・差別化準備
- [ ] B-3: ユニークなアプローチ（最重要）
- [ ] B-4: オファーの価値・購入決断
- [ ] B-5: 新しい人生のビジョン

## ターゲット
- 現状:
- 悩み:
- 仮想敵:

## Movie Scene（具体的な場面描写）


## Claim（1文の断言）


## Proof
- Ethos（権威）:
- Pathos（感情）:
- Logos（論理）:

## 構成
1.
2.
3.

## ステータス
- [ ] 企画
- [ ] 下書き
- [ ] レビュー
- [ ] 公開済み
```

### English

```markdown
---
created: "{{YYYY-MM-DD}}"
belief_stage: ""
platform: ""
status: draft
---

# Content Plan: [Title]

## Belief Stage
- [ ] B-1: Problem Awareness & Empathy (Cold→Warm)
- [ ] B-2: Evaluating Alternatives
- [ ] B-3: Unique Approach (Most Critical)
- [ ] B-4: Offer Value & Purchase Decision
- [ ] B-5: New Life Vision

## Target Audience
- Current State:
- Pain Points:
- Enemy (external):

## Movie Scene


## Claim (1-sentence assertion)


## Proof
- Ethos (Authority):
- Pathos (Emotion):
- Logos (Logic):

## Outline
1.
2.
3.

## Status
- [ ] Planning
- [ ] Draft
- [ ] Review
- [ ] Published
```
