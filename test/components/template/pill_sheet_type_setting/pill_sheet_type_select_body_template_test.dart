import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/components/template/pill_sheet_type_setting/pill_sheet_type_select_body_template.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../helper/fake.dart';

void main() {
  setUp(() {
    analytics = FakeAnalytics();
  });

  group('#PillSheetTypeSelectBodyTemplate', () {
    // iPhone 17 の論理幅 (402pt) に合わせる。説明文が長い言語でこの幅を超えて Row が溢れていた
    const screenWidth = 402.0;

    // 実際の呼び出し元 (pill_sheet_group_select_pill_sheet_type_page.dart) と同じく ListView の中に置く
    Widget subject() {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: screenWidth,
            child: ListView(
              children: [
                PillSheetTypeSelectBodyTemplate(
                  selectedFirstPillSheetType: null,
                  onSelect: (_) {},
                ),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('説明文が最も長い言語 (ドイツ語) でも Row が溢れずカードが 2 列に収まる', (tester) async {
      final originalL = L;
      addTearDown(() => L = originalL);
      L = lookupAppLocalizations(const Locale('de'));
      tester.view.physicalSize = const Size(screenWidth, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(subject());
      await tester.pump();

      expect(tester.takeException(), isNull);
      for (final card in tester
          .widgetList<PillSheetTypeColumn>(find.byType(PillSheetTypeColumn))) {
        expect(tester.getSize(find.byWidget(card)).width,
            lessThanOrEqualTo((screenWidth - 16) / 2));
      }
    });

    // 説明文の長さが段ごとに違う言語 (QA で en は段ごとに左端が 0・23・23・37pt とばらついた) でも列が揃うこと
    for (final lang in ['ja', 'en', 'de']) {
      testWidgets('$lang で全段の左のカードの左端と幅が揃う (訳文の長さで段ごとにずれない)', (tester) async {
        final originalL = L;
        addTearDown(() => L = originalL);
        L = lookupAppLocalizations(Locale(lang));
        tester.view.physicalSize = const Size(screenWidth, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(subject());
        await tester.pump();

        final cards = tester
            .widgetList<PillSheetTypeColumn>(find.byType(PillSheetTypeColumn))
            .toList();
        expect(cards, hasLength(7));
        // 各段の左のカードは 0・2・4・6 番目
        final firstRowLeft = tester.getTopLeft(find.byWidget(cards[0])).dx;
        final firstRowWidth = tester.getSize(find.byWidget(cards[0])).width;
        for (final index in [2, 4, 6]) {
          expect(tester.getTopLeft(find.byWidget(cards[index])).dx,
              moreOrLessEquals(firstRowLeft, epsilon: 1),
              reason: '$lang: cards[$index] の左端');
          expect(tester.getSize(find.byWidget(cards[index])).width,
              moreOrLessEquals(firstRowWidth, epsilon: 1),
              reason: '$lang: cards[$index] の幅');
        }
        expect(tester.takeException(), isNull);
      });
    }
  });
}
