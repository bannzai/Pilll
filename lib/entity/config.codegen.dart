```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.codegen.g.dart';
part 'config.codegen.freezed.dart';

/// アプリケーション全体の設定情報を管理するエンティティクラス
/// 
/// Firestoreの `/globals/config` ドキュメントに保存され、
/// アプリの動作制御に関する設定値を一元管理する。
/// 主にアプリの強制アップデート機能で使用される。
/// 
/// ## Firestore構造
/// - コレクション: `globals`
/// - ドキュメント: `config`
/// - 用途: グローバルなアプリ設定の管理
/// 
/// ## 使用場面
/// - アプリ起動時の強制アップデート判定
/// - 古いバージョンのアプリに対するサポート終了通知
/// - アプリケーションの最低動作要件の管理
/// 
/// ## 関連機能
/// - [CheckForceUpdate]: このConfigを使用して強制アップデートの判定を行う
/// - [Version]: アプリバージョンの比較処理
@freezed
class Config with _$Config {
  factory Config({
    /// アプリケーションの最低サポートバージョン
    /// 
    /// このバージョンより古いアプリは強制的にアップデートを促される。
    /// セマンティックバージョニング形式（例: "1.2.3"）または
    /// カスタムバージョン形式（例: "202408.06.163627"）で管理される。
    /// 
    /// ## 使用方法
    /// 1. 現在のアプリバージョンと比較
    /// 2. 現在のバージョンがこの値より小さい場合、強制アップデートを表示
    /// 3. アップデートが完了するまでアプリの利用を制限
    /// 
    /// ## 更新タイミング
    /// - 重要なセキュリティ修正が含まれるリリース時
    /// - 破壊的な変更が含まれるAPI変更時
    /// - サポート終了対象のバージョン指定時
    /// 
    /// ## テスト観点
    /// - バージョン比較のロジック検証
    /// - 境界値テスト（同じバージョン、直前のバージョン等）
    /// - バージョン文字列のパース処理
    required String minimumSupportedAppVersion,
  }) = _Config;
  Config._();

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
```
