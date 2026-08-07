---
paths:
  - "**/*.go"
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "**/*.py"
  - "**/*.swift"
  - "**/*.kt"
  - "**/*.rb"
  - "**/*.rs"
  - "**/*.java"
  - "**/*.c"
  - "**/*.cpp"
  - "**/*.h"
  - "**/*.dart"
---
# デフォルト値には選定根拠を書く

すべてのプログラミング言語に共通するルール。

## ルール

- Optionalのフォールバック、関数引数のデフォルト値、定数として定義する既定値など、既定の挙動を決める固定値には、その値を選んだ根拠をコメントで書く
- 根拠には、出典、制約、実測結果、仕様上の意図など、後から値の妥当性を検証できる情報を書く
- 値そのものやコードを読めば分かる挙動はコメントで繰り返さない。書くのは「何をしているか」ではなく「なぜその値なのか」とする（`coding-rules-single-source-info.md` を参照）

## 悪い例

```swift
let fixedTimeSeconds = schedule.timeLimit?.timeIntervalSeconds ?? 3600
```

```typescript
const timeoutMs = config.timeoutMs ?? 30000;
```

```go
retries := cfg.Retries
if retries == 0 {
	retries = 3
}
```

## 良い例

```swift
// Focus Dayの価値判定には、未設定時も標準的な集中セッション相当の使用時間が必要なため。
// ユーザーがtime limitを設定すると実際の値で上書きされる。
let fixedTimeSeconds = schedule.timeLimit?.timeIntervalSeconds ?? 3600
```

```typescript
// 外部APIの実測レスポンスタイム（p99）に余裕を持たせるため。
const timeoutMs = config.timeoutMs ?? 30000;
```

```go
// サービスのSLAで許容されている最大リトライ回数に合わせるため。
retries := cfg.Retries
if retries == 0 {
	retries = 3
}
```
