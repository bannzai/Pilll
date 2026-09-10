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
