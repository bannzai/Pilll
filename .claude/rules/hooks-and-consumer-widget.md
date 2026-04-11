---
paths:
  - "lib/**/*.dart"
---

# Hooks・Widget の状態管理ルール

## 1. useState の動作メカニズム

- `useState(initialData)` は内部で `ValueNotifier<T>` を **1回だけ** 生成する
- `initialData` は `ValueNotifier` の **生成時のみ** 使われ、以降の `build()` 呼び出しでは **完全に無視される**
- `StatefulWidget` に例えると `initState` で初期化するのと同じ。`didUpdateWidget` に相当するメカニズムは `useState` にはない
- `ValueNotifier.value` への代入が `useState` の唯一の状態更新手段であり、代入すると `HookWidget` が再ビルドされる
- つまり `useState(x)` と書いたとき、`x` が build のたびに変わっても、`useState` が返す `ValueNotifier` の `.value` は最初に渡した値のまま変わらない

**したがって `useState` は「Widget 内部で完結するローカル状態」にのみ使用する。**

使ってよい例: UI の表示切替フラグ、テキスト入力値、タブのインデックスなど、外部データソースに由来しない値。

使ってはいけない場面: 外部から流れてくるデータ（Provider の値、親から渡された引数、Stream の結果など）をそのまま `useState` の `initialData` に渡すこと。一度しか読まれないため、以降の更新が反映されなくなる。

## 2. HookConsumerWidget と ConsumerWidget の選択

- `HookConsumerWidget` は flutter_hooks の hooks（`useState`, `useEffect`, `useTextEditingController` 等）を使用するためのベースクラス
- hooks を使わないウィジェットでは `ConsumerWidget` を使う
- `HookConsumerWidget` を使っているのに hooks を使っていない場合は `ConsumerWidget` で十分

**判断基準:** Widget の `build` 内で `useState`, `useEffect`, `useMemoized` などの hook 呼び出しが 1つもなければ `ConsumerWidget` にする。`ConsumerWidget` であれば `useState` を誤用する余地自体がなくなる。

## 3. ref.watch によるデータ取得と「データの流れの切断」の回避

Riverpod の `ref.watch(provider)` はプロバイダーの値が変わると自動的にウィジェットを再ビルドする。この再ビルドにより、`build()` メソッド内で取得した値は常に最新になる。

**「データの流れの切断」が起きるメカニズム（疑似コード）:**

```dart
// NG: useState で外部データをコピーして切断が発生するパターン
class ParentWidget extends HookConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    // Firestoreストリームから最新のアイテム一覧を取得
    final items = ref.watch(shoppingListItemsProvider).valueOrNull ?? [];
    // 子に引数として渡す
    return ChildList(items: items);
  }
}

class ChildList extends HookConsumerWidget {
  final List<Item> items;
  const ChildList({required this.items});

  Widget build(BuildContext context, WidgetRef ref) {
    // ここで useState に入れてしまう
    final localItems = useState(items);
    // localItems.value は初回の items のまま。
    // 親が再ビルドされて新しい items が渡されても、useState は無視する。
    // → アイテムを追加しても画面に反映されない
    return ListView(children: localItems.value.map(...).toList());
  }
}
```

```dart
// OK: 子が ref.watch で直接購読する
class ParentWidget extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return ChildList(groupID: groupID, shoppingListID: shoppingListID);
  }
}

class ChildList extends ConsumerWidget {
  final String groupID;
  final String shoppingListID;
  const ChildList({required this.groupID, required this.shoppingListID});

  Widget build(BuildContext context, WidgetRef ref) {
    // 子自身がプロバイダーを直接 watch → 値が変わるたびに子が再ビルドされる
    final items = ref.watch(shoppingListItemsProvider(
      groupID: groupID, shoppingListID: shoppingListID,
    )).valueOrNull ?? [];
    return ListView(children: items.map(...).toList());
  }
}
```

**この切断を防ぐ原則:**

- 子 Widget でデータの最新性が必要なら、**子自身が `ref.watch` でプロバイダーを直接購読する**。引数経由で受け取って `useState` にコピーしない
- 引数で受け取ったデータをそのまま `build()` 内で使うだけなら問題ない（`useState` に入れず直接参照すれば、親の再ビルドのたびに最新値が渡される）
- `useState` に入れてよいのは、**そのデータを Widget 内部でユーザー操作によって変更する必要がある場合**のみ（例: 選択中のリストID、フォームの入力値）
