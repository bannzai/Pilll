---
paths:
  - "lib/**/*.dart"
---

# Hooks・Widget の状態管理ルール

- `useState` は Widget 内部で完結するローカル状態に使う。初期値は最初の生成時だけ読まれるため、Provider・親の引数・Stream の値をコピーすると以後の更新が反映されない。
- 子 Widget で最新データが必要なら、子自身が `ref.watch` で購読する。親から受け取る場合は `build` 内で引数を直接参照する。
- 選択状態やフォーム入力など、Widget 内でユーザーが変更する必要のある値は `useState` で保持してよい。
- hooks を使う Widget は `HookConsumerWidget`、使わない Widget は `ConsumerWidget` にする。
