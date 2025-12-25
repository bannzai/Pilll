import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.codegen.g.dart';
part 'config.codegen.freezed.dart';

/// アプリの全体的な設定情報を管理するエンティティクラス。
/// Firestoreの`/globals/config`ドキュメントのデータ構造を表し、
/// アプリの強制アップデート判定などの設定値を提供する。
/// 主にアプリケーションの動作制御に使用される。
@freezed
abstract class Config with _$Config {
  factory Config({
    /// 最小サポートバージョンを表すバージョン文字列。
    /// このバージョンより古いアプリは強制アップデートが必要となる。
    /// バージョン形式は`Version.parse()`で解析可能な文字列（例: "1.0.0"）。
    required String minimumSupportedAppVersion,
  }) = _Config;
  Config._();

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
