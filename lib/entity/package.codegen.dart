import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.codegen.g.dart';
part 'package.codegen.freezed.dart';

/// Firestoreに保存するパッケージ情報のフィールドキー定数を提供するクラス
///
/// パッケージ関連のFirestoreドキュメントのフィールド名を統一管理し、
/// タイポやキー名の不整合を防ぐために使用される
class PackageFirestoreKey {
  /// 最新OS情報のフィールドキー
  static const latestOS = 'latestOS';
}

/// アプリケーションのパッケージ情報を表現するエンティティ
///
/// ユーザーのアプリ使用統計として、ログイン時にFirestoreに保存される
/// 端末のOS情報とアプリのバージョン情報を組み合わせて管理し、
/// 統計分析やサポート業務で利用される
@freezed
abstract class Package with _$Package {
  @JsonSerializable(explicitToJson: true)
  const factory Package({
    /// 端末の最新OS種別
    ///
    /// Platform.operatingSystemから取得される値（"android", "ios"など）
    /// 端末のOS種別を識別するために使用される
    required String latestOS,

    /// アプリケーション名
    ///
    /// PackageInfo.fromPlatform().appNameから取得される値
    /// 通常は"Pilll"が設定される
    required String appName,

    /// アプリケーションのバージョン番号
    ///
    /// PackageInfo.fromPlatform().versionから取得される値
    /// アプリストアで公開されているバージョン番号（例: "2025.08.06"）
    required String appVersion,

    /// アプリケーションのビルド番号
    ///
    /// PackageInfo.fromPlatform().buildNumberから取得される値
    /// 開発時のビルド識別子として使用される
    required String buildNumber,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);
}
