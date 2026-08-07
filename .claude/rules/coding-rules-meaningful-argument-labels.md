# 引数ラベルは実態に即した名前にする

すべてのプログラミング言語で守るルール（Swift の引数ラベル、named arguments を持つ言語全般）。

## ルール

- `for:` / `with:` / `in:` / `at:` のような前置詞だけの引数ラベルを付けない。呼び出し側で何を渡しているのか実態がわからなくなるだけ
- ラベルには渡す値の実態を表す名詞を使う（`date:` / `template:` / `index:` / `line:` など）
- 特別な理由なく第一引数のラベルを `_` で省略しない。省略する場合（標準 API のミラー等）は理由をコメントに書く

## 悪い例

```swift
EditorDateText.caption(for: entry.date)
startOfMonth(for: date)
private func start(_ template: JournalTemplate)
```

```typescript
function format(v: string) {}
```

## 良い例

```swift
editorDateText(date: entry.date)
startOfMonth(date: date)
private func start(template: JournalTemplate)
```

```typescript
function format(dateText: string) {}
```

## 出典

- 起票元: https://github.com/bannzai/nikki/pull/10#discussion_r3635935819 （`caption(for:)` のレビュー指摘）
