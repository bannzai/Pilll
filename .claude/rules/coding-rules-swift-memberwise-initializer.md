---
paths:
  - "**/*.swift"
---
# memberwise initializerを積極的に使う

Swiftで`struct`を定義する時のルール。

## ルール

- `struct`の初期化には、自動生成されるmemberwise initializerを優先して使う
- 同じ引数・代入だけの`init`を手書きしない
- モジュール外に公開するpublic APIとして`public init`を定義するのはOK（auto-generated memberwise initはinternalのため）
- public インタフェース以外で`init`を定義する場合は、なぜ必要だったのかをコメントに書く（カスタムバリデーション、内部で値を決定する、privateにしたい、など）

## 悪い例

```swift
struct User {
    let id: String
    let name: String

    // 自動生成と同じ内容をわざわざ書いている
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
```

```swift
struct Email {
    let value: String

    // 理由コメントなしのカスタムinit
    init?(_ raw: String) {
        guard raw.contains("@") else { return nil }
        self.value = raw
    }
}
```

## 良い例

```swift
// 自動生成のmemberwise initializerをそのまま使う
struct User {
    let id: String
    let name: String
}
```

```swift
// public APIはauto-generated memberwise initがinternalなため、明示的にpublic initを書く必要がある
public struct User {
    public let id: String
    public let name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
```

```swift
struct Email {
    let value: String

    // "@"を含むかのバリデーションを通した値だけを受け入れたいため、failable initにしている
    init?(_ raw: String) {
        guard raw.contains("@") else { return nil }
        self.value = raw
    }
}
```
