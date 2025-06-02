# Pilll プロジェクト概要

## アプリケーション概要
Pilllは、ピル（経口避妊薬）の服用管理をサポートするモバイルアプリケーションです。Flutter製で、iOS/Android両プラットフォームに対応しています。

### 主な機能
- ピルの服用記録・リマインダー
- 服用履歴の管理
- 月経周期の記録
- プレミアムプラン（有料機能）

## 技術スタック

### フレームワーク・言語
- **Flutter** (Dart)
- **SDK**: >=3.0.0 <4.0.0

### 状態管理
- **Riverpod** 2.x (hooks_riverpod, riverpod_annotation)
- **Flutter Hooks**

### バックエンド・インフラ
- **Firebase**:
  - Authentication (認証)
  - Firestore (データベース)
  - Analytics
  - Crashlytics
  - Remote Config
  - Messaging (プッシュ通知)

### 主要パッケージ
- **freezed** - イミュータブルなデータクラス生成
- **json_annotation** - JSONシリアライゼーション
- **mockito** - テスト用モック
- **intl** - 国際化対応
- **url_launcher** - 外部URL起動
- **shared_preferences** - ローカルストレージ

### 決済
- **RevenueCat** - アプリ内課金管理

## コーディング規約

### Lintルール (analysis_options.yaml)
- `flutter_lints` パッケージのルールセットを使用
- `always_declare_return_types: true` - 戻り値の型は必ず宣言
- `prefer_single_quotes: true` - シングルクォートを推奨

### ファイル構成・命名規則
- **エンティティ**: `lib/entity/` - `.codegen.dart` サフィックスで自動生成ファイルを識別
- **Provider**: `lib/provider/` - Riverpodプロバイダー
- **機能別ディレクトリ**: `lib/features/` - 各画面・機能ごとにディレクトリを分割
- **コンポーネント**: `lib/components/` - atoms/molecules/organisms/page/templateのAtomic Design構成

### コード生成
- `build_runner` を使用
- 対象: freezed, json_serializable, riverpod_generator
- 実行コマンド: `flutter pub run build_runner build --delete-conflicting-outputs`

### テスト
- テストファイルは `test/` ディレクトリに配置
- 日本語でのコメントを推奨
- MockitoによるMock生成を活用

### Git管理
- 自動生成ファイル（`*.g.dart`, `*.freezed.dart`）は除外

### その他の重要事項
- **ライセンス**: 独自ライセンス（著作権保持、個人利用・PR許可）
- **多言語対応**: 70以上の言語に対応（app_*.arb）
- **ログ出力**: debugPrintを使用（本番環境では無効化される）

## 開発時の注意点
1. Firebaseの設定ファイルは環境ごとに分かれている（dev/prod）
2. RemoteConfigでフィーチャーフラグを管理
3. ピルシートの服用記録は `PillSheetModifiedHistory` エンティティで管理
4. プレミアム機能の判定は `User.isPremium` で行う