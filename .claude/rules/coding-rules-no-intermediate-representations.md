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
# 中間表現を作らない

すべてのプログラミング言語に共通するルール。開発に必要なモデル構造をクリティカルに定義しているのは DB の Entity や外部 API・スキーマの定義（SSOT）であり、それらを加工・合成した中間表現の構造（型・class・struct）を作らない。

## ルール

- DB の Entity や外部 API の定義をそのまま使う。表示や処理の都合で詰め替えた構造を作らない
- 複数の SSOT からフィールドを寄せ集めた構造を作らない
- スキーマやクエリからコード生成できる型（GraphQL codegen、OpenAPI generator 等）は生成型をそのまま使う。同じ形を手書きした型・ラッパー型を作らない
- ドメイン契約として独立させたい場合も、SSOT 側の型の alias や Pick で寄せ、フィールドを二重定義しない

## 理由

- 余計な知識が増える。正しく理解すべきは SSOT のデータ構造であり、加工して個別最適化した構造は余計な知識とコードリーディングを増やす
- 二重定義が増える。「この中間表現のプロパティの実態は何か」を SSOT まで遡って調べる作業が繰り返し発生する
- クリティカルなデータ構造（DB・API）にフィールドの追加・削除があると、中間表現側も追随した更新が必要になる
- 逆に、中間表現があることで変更量が減るシチュエーションも存在するが限定的。あるかないかわからない将来の変更に備えて作らない

## 悪い例

```swift
// User と Group から表示用にフィールドを寄せ集めた中間表現
struct UserAndGroupContainer {
    let userID: String
    let groupID: String
    let userName: String
    let groupName: String
}
```

```typescript
// gql リテラルから生成できる型を手書きしている
interface ViewerQueryData {
  viewer: { login: string; avatarUrl: string };
}
```

```dart
// Firestore の User ドキュメントを表示用に詰め替えた中間表現
class UserViewData {
  final String name;
  final String iconUrl;
}
```

## 良い例

```swift
// SSOT の User / Group をそのまま渡す
func render(user: User, group: Group)
```

```typescript
// @graphql-codegen/cli + client-preset が gql リテラルから TypedDocumentNode を生成するため、
// クエリ結果の型を手書きしなくてよい
const { data } = useQuery(ViewerDocument);
```

```dart
// Firestore のドキュメント (entity) をそのまま使う
Text(user.name)
```

## 関連ルール

- 中間「変数」は `coding-rules-no-intermediate-variables.md`（同ディレクトリ）が対象（値を一度しか参照しない変数を作らない）。本ルールは構造（型・class）の二重定義が対象
