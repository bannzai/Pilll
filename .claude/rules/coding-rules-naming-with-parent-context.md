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
# 変数名に親の型名をコンテキストとして含める

すべてのプログラミング言語に共通するルール。

## ルール

- 親の型名をコンテキストとして含めた命名にする

## 悪い例

```go
type AppUser struct {
	ID   int
	Name string
}

// 構造体名のコンテキストが失われている
userID := appUser.ID
userName := appUser.Name
```

```typescript
interface AppUser {
  id: number;
  name: string;
}

// 構造体名のコンテキストが失われている
const userId = appUser.id;
const userName = appUser.name;
```

## 良い例

```go
type AppUser struct {
	ID   int
	Name string
}

// 構造体名をそのまま含めた命名
appUserID := appUser.ID
appUserName := appUser.Name
```

```typescript
interface AppUser {
  id: number;
  name: string;
}

// 構造体名をそのまま含めた命名
const appUserId = appUser.id;
const appUserName = appUser.name;
```
