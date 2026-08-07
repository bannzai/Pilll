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
  - "**/*.cpp"
  - "**/*.dart"
---
# クラスより関数を優先する

すべてのプログラミング言語に共通するルール。

## ルール

- class, struct, enumを使わなくて済むなら使わない。関数で済むなら関数にする
- やむを得ない時にだけclassを使う（継承が必要、フレームワークが要求する等）
- primitiveな用途（JSONデコード、generics関数に渡す型定義など）にはstruct/enumを使う

## 悪い例

```typescript
class UserService {
  formatName(user: User): string {
    return `${user.firstName} ${user.lastName}`;
  }
}
```

```python
class MathHelper:
    @staticmethod
    def add(a: int, b: int) -> int:
        return a + b
```

## 良い例

```typescript
function formatUserName(user: User): string {
  return `${user.firstName} ${user.lastName}`;
}
```

```python
def add(a: int, b: int) -> int:
    return a + b
```

## structを使う場面の例

```go
// JSONデコード用の型定義
type APIResponse struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}
```

```swift
// Codable準拠のデータ型
struct APIResponse: Codable {
    let id: Int
    let name: String
}
```
