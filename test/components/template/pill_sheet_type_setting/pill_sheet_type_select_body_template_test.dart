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

    Widget subject() {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: screenWidth,
            child: PillSheetTypeSelectBodyTemplate(
              selectedFirstPillSheetType: null,
              onSelect: (_) {},
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

    testWidgets('最後の段のカードが上の段の左の列と同じ位置に揃う (空き枠が広がって左へずれない)', (tester) async {
      tester.view.physicalSize = const Size(screenWidth, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(subject());
      await tester.pump();

      final cards = tester
          .widgetList<PillSheetTypeColumn>(find.byType(PillSheetTypeColumn))
          .toList();
      // 各段の左のカードは 0・2・4・6 番目 (最後の段は 6 番目と、不可視の空き枠 7 番目)
      final firstRowLeft = tester.getTopLeft(find.byWidget(cards[0])).dx;
      final lastRowLeft = tester.getTopLeft(find.byWidget(cards[6])).dx;
      expect(lastRowLeft, moreOrLessEquals(firstRowLeft, epsilon: 1));
    });
  });
}
