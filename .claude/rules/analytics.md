---
paths:
  - "lib/features/**/*.dart"
  - "lib/**/components/*.dart"
---

# Analytics 規約

## イベント記録
- ユーザーインタラクションのコールバック先頭で `analytics.logEvent` を呼び出す

## 命名
- name は40文字以内

## パラメータ
- parameters にはスコープ内で自然に取得できるIDを含める
- key の命名は snake_case にする (Firebase/BigQuery の慣習に合わせる)
- value に動的な変数を渡す場合、key 名はその変数名を snake_case に変換したものにする (例: `final pillSheetID = ...;` → `{'pill_sheet_id': pillSheetID}`)

## 目的
- ユーザーの行動調査・不具合時の調査
- print でログも出るので開発時に最後に起きたイベントを確認しやすい

## 補足
- キャンセル・閉じるなども記録
- TextField系のonChangedのイベントは不要。onSubmittedは欲しい
