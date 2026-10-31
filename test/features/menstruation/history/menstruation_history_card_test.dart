import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/molecules/counter_unit_layout.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/menstruation/history/menstruation_history_card.dart';
import 'package:pilll/features/menstruation/history/menstruation_history_card_state.dart';
import 'package:pilll/l10n/app_localizations.dart';

void main() {
  group('#MenstruationHisotryCardAvarageInformation', () {
    // 幅 375pt は App Store スクリーンショットの生成ハーネスで overflow が出た iPhone と同じ論理幅
    const screenWidth = 375.0;

    /// 表示言語を lang にし、画面を幅 375pt にして平均の行を pump する。言語と画面の大きさはテストの終わりに戻す
    Future<void> pumpSubject(WidgetTester tester,
        {required String lang}) async {
      final originalL = L;
      addTearDown(() => L = originalL);
      L = lookupAppLocalizations(Locale(lang));
      tester.view.physicalSize = const Size(screenWidth, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final menstruations = [
        Menstruation(
            beginDate: DateTime(2026, 10, 1),
            endDate: DateTime(2026, 10, 5),
            createdAt: DateTime(2026, 10, 1)),
        Menstruation(
            beginDate: DateTime(2026, 9, 3),
            endDate: DateTime(2026, 9, 7),
            createdAt: DateTime(2026, 9, 3)),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              // 本番 MenstruationCardList と同じ左右 16 の余白
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  // 本番 MenstruationHistoryCard の内側と同じ左右 16 の余白
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MenstruationHisotryCardAvarageInformation(
                    state: MenstruationHistoryCardState(
                      allMenstruations: menstruations,
                      latestMenstruation: menstruations.first,
                      isPremium: true,
                      isTrial: false,
                      trialDeadlineDate: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    for (final lang in ['de', 'fi']) {
      testWidgets('ラベルの訳が長い $lang でもはみ出さず、2 つの平均が画面内に収まる',
          (WidgetTester tester) async {
        await pumpSubject(tester, lang: lang);

        expect(tester.takeException(), isNull);
        final counterRects = tester
            .widgetList(find.byType(CounterUnitLayout))
            .map((widget) => tester.getRect(find.byWidget(widget)));
        expect(counterRects, hasLength(2));
        for (final counterRect in counterRects) {
          expect(counterRect.left, greaterThanOrEqualTo(0));
          expect(counterRect.right, lessThanOrEqualTo(screenWidth));
        }
      });
    }

    testWidgets('ラベルが短い ja では 2 つの平均が区切り線を挟んで並び、まとまりが行の中央に置かれる',
        (WidgetTester tester) async {
      await pumpSubject(tester, lang: 'ja');

      expect(tester.takeException(), isNull);
      final rowRect = tester
          .getRect(find.byType(MenstruationHisotryCardAvarageInformation));
      final averagePeriodRect =
          tester.getRect(find.byType(CounterUnitLayout).first);
      final averageDaysRect =
          tester.getRect(find.byType(CounterUnitLayout).last);
      final dividerRect = tester.getRect(find.byType(VerticalDivider));
      expect(averagePeriodRect.right, lessThan(dividerRect.left));
      expect(averageDaysRect.left, greaterThan(dividerRect.right));
      expect(averagePeriodRect.left - rowRect.left,
          moreOrLessEquals(rowRect.right - averageDaysRect.right, epsilon: 1));
    });
  });
}
