# Pilll プロジェクト概要

## アプリケーション概要
飲み忘れの不安をなくすピルの服用管理モバイルアプリ・Pilllの開発をしています。
ピルの服用時刻にリマインド、服用履歴の管理、生理管理を行えるアプリになっています
iOS・Androidアプリ両方を提供しております。Flutter製のアプリです。このリポジトリはPilllのFlutterプロジェクトのリポジトリです

### 主な機能
- ピルの服用記録: 服用記録・取り消し。服用履歴を確認できる
- ピルシートUI: ピルシートをメタファーとしたUIで「どこまで飲んだかを一目でわかる」価値を提供。また、ピルシートのUIからいつ頃生理が来るか、何日飲む薬か、何番目の薬か。が一目でわかる。表示番号も調整できる
- 生理記録: 生理が記録・編集ができる
- 日記: カレンダーUIがあり、体調を記録
- 未来の予定: カレンダーUIから予定を書き込むことができる。通院予定など
- プレミアムプラン（有料機能）

## 技術スタック
詳細は、 @pubspec.yaml を参考

### 状態管理
- **Riverpod**: グローバル状態管理
- **Flutter Hooks**: Widget内部状態管理

### バックエンド・インフラ
- **Firebase**:
  - Authentication (認証)
  - Firestore (データベース)
  - Analytics
  - Crashlytics
  - Remote Config
  - Messaging (プッシュ通知)

### その他主要パッケージ
- **freezed** - イミュータブルなデータクラス生成
- **json_annotation** - JSONシリアライゼーション
- **mockito** - テスト用モック
- **intl** - 国際化対応
- **shared_preferences** - ローカルストレージ

### 決済
- **RevenueCat** - アプリ内課金管理

## コーディング規約

### コーディング規約
- 内部状態の管理は可能な限り flutter_hooksを使用する
- 一時変数は宣言しない。少なくとも「わかりやすくなる」という主観的な目的では行わない。繰り返し使われるものや、長すぎる条件式をまとめる場合は検討する
- コンポーネント内で状態管理の完結を目指す。
- 親からの状態共有は ValueNotifier を子コンポーネント間で共有する。コールバックは使わない。もし使用したい場合は理由をコメントに書く
- ValueNotifierのaddListenerは基本的にわかりづらいのでやらない。許容するケースは SharedPreferences と同期をしたい時
- StateNotifier,ChangeNotifierは使わない
- 関数、メソッドの引数は、{required} をつけましょう。引数ラベルがないとわかりづらいです

### Lintルール (analysis_options.yaml)
- その他は、 @analysis_options.yaml を参照

### ファイル構成・命名規則
- **エンティティ**: `lib/entity/`: `.codegen.dart` サフィックスで自動生成ファイルを識別
- **Provider**: `lib/provider/`: Riverpodプロバイダー
- **機能別ディレクトリ**: `lib/features/`: 各画面・機能ごとにディレクトリを分割
- **コンポーネント**: `lib/components/` 
  * Deprecated: atoms/molecules/organisms/page/templateのAtomic Design構成
  * components/の下は特にルールなく都合よくパッケージを切っていきましょう

### コード生成
- `build_runner` を使用
- 対象: freezed, json_serializable, riverpod_generator
- 実行コマンド: `flutter pub run build_runner build --delete-conflicting-outputs;dart format lib`

### テスト
- テストファイルは `test/` ディレクトリに配置
- 日本語でのコメントを推奨
- MockitoによるMock生成を活用

### Git管理
- 自動生成ファイル（`*.g.dart`, `*.freezed.dart`）も commit 対象
- `git commit --amend` は禁止。修正が必要な場合は新しいコミットを積み上げる

### その他の重要事項
- **ライセンス**: 独自ライセンス（著作権保持、個人利用・PR許可）
- **多言語対応**: 70以上の言語に対応（app_*.arb）
- **ログ出力**: debugPrintを使用（本番環境では無効化される）

### マネタイズ
- サブスクリプション: 2種類ある
  * 割引: 月額300円, 年額3600円
  * 通常: 月額600円, 年額4800円
- また、古いプランに 月額480円,年額3600円 がある。時たまキャンペーンとしてこの金額のプランを提供することがある
- 広告: アプリのホーム画面にAdMobのバナー広告。たまに企業からの純広告(バナー形式)を表示することがある

## 開発時の注意点
1. Firebaseの設定ファイルは環境ごとに分かれている（main.dev.dart/main.prod.dart）
2. RemoteConfigでフィーチャーフラグを管理

------------------------------------

# プログラムテストについて

## プログラムテスト方針
- いわゆるロジックを検証するUnit Test と Widget Test を中心に書いていく
- Widget Test では Button をタップすると言った操作を行うものは書かない。状態を用意して、どういうWidgetの状態になるかを検証する
- Pilllでは日付を扱うテストが多区、境界値テストが多い。端末での動作確認が大変なので、日付部分で境界値がある場合は積極的に・網羅的にテストを書く

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
