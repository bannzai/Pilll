import 'package:pilll/features/localizations/l.dart';

/// 外部アカウント連携の種類を定義するEnum
///
/// Firebase Authenticationで使用される外部プロバイダーの種類を表す。
/// ユーザーのアカウント作成・ログイン時に、どの外部サービスを
/// 使用するかを識別するために利用される。
enum LinkAccountType {
  /// Apple ID連携
  apple,

  /// Googleアカウント連携
  google,
}

extension LinkAccountTypeExtension on LinkAccountType {
  /// ログイン画面で表示される連携サービス名を取得
  ///
  /// UI表示用の文字列で、多言語対応されている。
  /// Appleは固定文字列、GoogleはL.googleAccountから取得。
  String get loginContentName {
    switch (this) {
      case LinkAccountType.apple:
        return 'Apple';
      case LinkAccountType.google:
        return L.googleAccount;
    }
  }

  /// 連携プロバイダーの正式名称を取得
  ///
  /// Firebase Authenticationのプロバイダー識別や
  /// 内部処理で使用される文字列を返す。
  String get providerName {
    switch (this) {
      case LinkAccountType.apple:
        return 'Apple';
      case LinkAccountType.google:
        return 'Google';
    }
  }
}
