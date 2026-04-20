---
paths:
  - "test/**/*.dart"
---

# テスト規約

- Widget Test で `find.text(L.xxx)` のようにローカライゼーション定数でマッチしない。Widget が同じ定数を使っているので A=A' テスト（定数が自分自身に等しいことを確認するだけ）になる
- 代わりに `find.byType(WidgetClass)` / `find.byIcon(Icons.xxx)` / `find.byType(Text), findsAtLeast(N)` など Widget の構造・存在でマッチする
- 「この条件の場合はこの Widget が表示される」というシナリオベースのテストを書く
