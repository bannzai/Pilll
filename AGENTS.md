# Pilll の開発指示

ピルの服用管理アプリ。依存関係は `pubspec.yaml`、Lint は `analysis_options.yaml` を参照する。

応答は日本語で行う。

## コーディング規約

- 内部状態の管理は可能な限り flutter_hooksを使用する
- 一時変数は宣言しない。少なくとも「わかりやすくなる」という主観的な目的では行わない。繰り返し使われるものや、長すぎる条件式をまとめる場合は検討する
- コンポーネント内で状態管理の完結を目指す。
- 親からの状態共有は ValueNotifier を子コンポーネント間で共有する。コールバックは使わない。もし使用したい場合は理由をコメントに書く
- ValueNotifierのaddListenerは基本的にわかりづらいのでやらない。許容するケースは SharedPreferences と同期をしたい時
- StateNotifier,ChangeNotifierは使わない
- Dart の引数・Provider・DB 操作の規約は `.claude/rules/coding-conventions.md` を参照する。

### ファイル構成・命名規則
- `lib/components/` は Atomic Design 構成を非推奨とし、用途に応じてパッケージを分ける。

### コード生成
- `flutter pub run build_runner build --delete-conflicting-outputs` を実行後、`dart format lib` を実行する。

### テスト
- テストファイルは `test/` ディレクトリに配置
- 日本語でのコメントを推奨
- MockitoによるMock生成を活用

### Git管理
- 自動生成ファイル（`*.g.dart`, `*.freezed.dart`）も commit 対象
- `git commit --amend` は禁止。修正が必要な場合は新しいコミットを積み上げる

### その他の重要事項
- **ライセンス**: 独自ライセンス（著作権保持、個人利用・PR許可）
- 翻訳は `translate-app-arb` skill とルートの `translate-app.config.json` に従う。
- ログ出力は `debugPrint` を使用する。
- Firebase の設定は `main.dev.dart` / `main.prod.dart` で環境が分かれている。

## issue の読み書き先
このリポジトリ (bannzai/Pilll) は public で issue 機能が無効。issue は private の bannzai/PilllBackend で管理している。

- 指示・skill に登場する issue のやりとり（作成・閲覧・コメント・ラベル操作など）は、すべて bannzai/PilllBackend の issue を読み書きする
- `gh issue` 系コマンドは必ず `--repo bannzai/PilllBackend` を指定する

------------------------------------

# プログラムテストについて

## プログラムテスト方針
- いわゆるロジックを検証するUnit Test と Widget Test を中心に書いていく
- Widget Test では Button をタップすると言った操作を行うものは書かない。状態を用意して、どういうWidgetの状態になるかを検証する
- Pilllでは日付を扱うテストが多く、境界値テストが多い。端末での動作確認が大変なので、日付部分で境界値がある場合は積極的に・網羅的にテストを書く
- 実装後は手動テスト前に必ず、ユニットテスト・MaestroによるE2Eテストを実行する。該当するものがなければテストを新規作成する。作成・実行が難しい場合はユーザーに報告する
- 動作確認は、極力あなたが行うこと。 /sim-manager skill を使用して動作確認をすること


## コーディング規約・ルール
- mainのスコープでテストに使う変数を宣言してsetUpで用意する方式ではなく、各group,test,testWidgetsの中で必要に応じた最小限のスコープに収まるように宣言する。もちろんmainのスコープが適切ならそこに宣言する
- Unit Test ではメソッドや、Riverpodのproviderごとにgroupを作りテストを書く
- Widget Test では表示を期待する値・Widgetのclass単位でgroupを作りテストを書く
- groupでは、 group("#someMethod") のように #から始める
- test,testWidgetsではユースケース、シナリオ、条件式を書く。日本語で
- ディレクトリ構成、ファイル構成は、lib/配下と一緒にする
- ファイルの命名規則は {NAME}_test.dart
- FirestoreのclassはMockしない。例えば、Query,QuerySnapshot,Document,DocumentRef,DocumentSnapshot,Collection,CollectionRef,CollectionSnapshot は Mock にしない。Mockがしづらい

### PillSheet v1/v2 テスト
- PillSheet.v1() と PillSheet.v2() の両方でテストが必要な場合がある
- v2 特有のロジック（pills から lastTakenDate を導出など）は `#PillSheetV2` グループ内でテスト
- 共通 getter/function で v1/v2 両方のテストが必要な場合は、各グループ内に `group("v2", ...)` を追加

<!-- ai-review-config begin -->
<!--
このブロックは自動生成です。直接編集せず、テンプレートを更新してから再生成してください。
内容は AI コードレビュー時の挙動指示であり、コードベース自体への規約ではありません。
-->

## レビュー時の応答スタイル

- 応答は日本語で行う

## レビュー範囲外

以下は自動レビューで指摘しない (別の検出経路があるため):

- コンパイルエラー・型エラー (ローカル/CI のビルドで検出される)
- Lint/フォーマット違反 (リンター・フォーマッターで検出される)
<!-- ai-review-config end -->
