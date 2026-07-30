import 'package:pilll/features/premium_introduction/paywall_source.dart';

/// ピルシート終了ダイアログの A/B バリアント。
/// Firebase Remote Config の `endedPillSheetDialogVariant` で配信される文字列に対応する。
enum EndedPillSheetDialogVariant {
  /// 履歴ぼかしティーザー（先頭1件表示 + 残り blur）
  historyBlur,

  /// 服用記録の集計メッセージティーザー
  summaryStats,
}

extension EndedPillSheetDialogVariantFunction on EndedPillSheetDialogVariant {
  /// Firebase Analytics の variant パラメータ / Remote Config に対応する snake_case 文字列。
  String get value {
    switch (this) {
      case EndedPillSheetDialogVariant.historyBlur:
        return 'history_blur';
      case EndedPillSheetDialogVariant.summaryStats:
        return 'summary_stats';
    }
  }

  /// CTA から開く paywall の source。
  PaywallSource get paywallSource {
    switch (this) {
      case EndedPillSheetDialogVariant.historyBlur:
        return PaywallSource.endedPillSheetDialogHistory;
      case EndedPillSheetDialogVariant.summaryStats:
        return PaywallSource.endedPillSheetDialogSummary;
    }
  }
}

/// Remote Config の文字列値から variant を解決する。空文字・未知値は null（ダイアログ非表示）。
EndedPillSheetDialogVariant? endedPillSheetDialogVariantFromRemoteConfig(String value) {
  switch (value) {
    case 'history_blur':
      return EndedPillSheetDialogVariant.historyBlur;
    case 'summary_stats':
      return EndedPillSheetDialogVariant.summaryStats;
    default:
      return null;
  }
}
