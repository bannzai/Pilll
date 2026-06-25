import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog_variant.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';

void main() {
  group('#endedPillSheetDialogVariantFromRemoteConfig', () {
    test('history_blur は historyBlur に解決される', () {
      expect(endedPillSheetDialogVariantFromRemoteConfig('history_blur'), EndedPillSheetDialogVariant.historyBlur);
    });
    test('summary_stats は summaryStats に解決される', () {
      expect(endedPillSheetDialogVariantFromRemoteConfig('summary_stats'), EndedPillSheetDialogVariant.summaryStats);
    });
    test('空文字は null（実験未参加=非表示）', () {
      expect(endedPillSheetDialogVariantFromRemoteConfig(''), isNull);
    });
    test('未知の値は null（非表示）', () {
      expect(endedPillSheetDialogVariantFromRemoteConfig('unknown'), isNull);
    });
  });

  group('#EndedPillSheetDialogVariantFunction', () {
    test('value が Remote Config / analytics の文字列と一致', () {
      expect(EndedPillSheetDialogVariant.historyBlur.value, 'history_blur');
      expect(EndedPillSheetDialogVariant.summaryStats.value, 'summary_stats');
    });
    test('paywallSource が各バリアントの source と一致', () {
      expect(EndedPillSheetDialogVariant.historyBlur.paywallSource, PaywallSource.endedPillSheetDialogHistory);
      expect(EndedPillSheetDialogVariant.summaryStats.paywallSource, PaywallSource.endedPillSheetDialogSummary);
    });
  });
}
