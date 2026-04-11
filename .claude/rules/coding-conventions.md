---
paths:
  - "lib/**/*.dart"
---

# コーディング規約

- Entityのフィールド名は省略せず、長くても実態がわかる名前をつける（例: `sheetID` ではなく `pillSheetID`）
- FirestoreのDBに対して変更（書き込み・更新・削除）を行う場合は、`call` メソッドを持ったclassを提供するProviderを用意し、そのProvider経由で操作すること（例: `TakePill`, `RevertTakePill` など）
- 関数の引数は原則 `{required}` でラベルが呼び出し元につくようにする
- コンストラクタの引数も nullable であっても `required` をつける。ただしtimestamp等のメタデータフィールドは除く
- `ref.watch` は状態の同期に使う（例: `userProvider` 等のデータ/状態Provider）。`ref.read` は機能・操作を提供するProvider（`call` クラス等、アプリの表示に関係ないもの）に限定する
- エラーメッセージについては、基本的にそのまま表示する（`e.toString()` の加工・プレフィックス除去等はしない）
