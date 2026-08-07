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
# 定義にはdocumentコメントを書く

すべてのプログラミング言語に共通するルール。

## ルール

- 構造の定義（class, struct, enum, property）をした場合はdocumentコメントを書く
- 関数の定義をした場合はdocumentコメントを書く

## 悪い例

```go
type User struct {
	ID   int
	Name string
}

func CreateUser(name string) *User {
	return &User{Name: name}
}
```

```typescript
interface User {
  id: number;
  name: string;
}

function createUser(name: string): User {
  return { id: 0, name };
}
```

## 良い例

```go
// User はアプリケーションのユーザーを表す。
type User struct {
	// ID はユーザーの一意な識別子。
	ID int
	// Name はユーザーの表示名。
	Name string
}

// CreateUser は指定された名前で新しいUserを作成する。
func CreateUser(name string) *User {
	return &User{Name: name}
}
```

```typescript
/** アプリケーションのユーザーを表す。 */
interface User {
  /** ユーザーの一意な識別子。 */
  id: number;
  /** ユーザーの表示名。 */
  name: string;
}

/** 指定された名前で新しいUserを作成する。 */
function createUser(name: string): User {
  return { id: 0, name };
}
```
