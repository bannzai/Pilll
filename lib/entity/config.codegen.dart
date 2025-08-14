```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.codegen.g.dart';
part 'config.codegen.freezed.dart';

/// アプリケーションのグローバル設定情報を管理するエンティティクラス。
/// Firestoreの`/globals/config`ドキュメントからデシリアライズされ、
/// アプリの基本動作に関する設定値を保持する。
/// 主に強制アップデート機能で使用され、アプリの最小サポート対象バージョンを管理する。
@freezed
class Config with _$Config {
  factory Config({
    /// アプリが動作する最小サポート対象バージョン。
    /// このバージョンより古いアプリは強制アップデートの対象となる。
    /// バージョン形式は`1.2.3`のようなセマンティックバージョニングに従う文字列。
    required String minimumSupportedAppVersion,
  }) = _Config;
  Config._();

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
```
