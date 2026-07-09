import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/record/components/announcement_bar/components/special_offering.dart';
import 'package:pilll/features/special_offering/special_offering_copy_variant.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../../helper/fake.dart';

void main() {
  setUp(() {
    // viewed useEffect で analytics.setUserProperties/logEvent を呼ぶため、Firebase未初期化のテストではFakeに差し替える
    analytics = FakeAnalytics();
  });

  group('#SpecialOfferingAnnouncementBar', () {
    Future<void> pumpBar(
      WidgetTester tester, {
      required SpecialOfferingCopyVariant copyVariant,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Material(
              child: SpecialOfferingAnnouncementBar(
                specialOfferingIsClosed: ValueNotifier(false),
                copyVariant: copyVariant,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('defaultバリアントで現行の半額訴求文言が表示される', (WidgetTester tester) async {
      await pumpBar(tester,
          copyVariant: SpecialOfferingCopyVariant.defaultVariant);

      expect(
        find.text('97.2%の人が「飲み忘れが減った」と回答！\n今だけ半額でプレミアムプランをゲット！'),
        findsOneWidget,
      );
    });

    testWidgets('scarcityバリアントで希少性訴求のラストチャンス文言が表示される',
        (WidgetTester tester) async {
      await pumpBar(tester, copyVariant: SpecialOfferingCopyVariant.scarcity);

      expect(
        find.text('このオファーは今回限り。\n半額でプレミアムプランを始めるラストチャンス！'),
        findsOneWidget,
      );
      // 現行文言は表示されない
      expect(
        find.text('97.2%の人が「飲み忘れが減った」と回答！\n今だけ半額でプレミアムプランをゲット！'),
        findsNothing,
      );
    });
  });
}
