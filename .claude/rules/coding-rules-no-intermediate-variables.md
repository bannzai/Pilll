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
# 中間変数を使わない

すべてのプログラミング言語に共通するルール。

## ルール

- 値を一度しか参照しない中間変数を定義しない
- 式をそのまま引数や返り値として使う

## 悪い例

```go
body := response.Body
defer body.Close()
```

```typescript
const body = response.body;
return body;
```

```python
result = db.query(sql)
return result
```

## 良い例

```go
defer response.Body.Close()
```

```typescript
return response.body;
```

```python
return db.query(sql)
```
