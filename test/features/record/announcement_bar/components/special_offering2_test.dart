import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/record/components/announcement_bar/components/special_offering2.dart';
import 'package:pilll/features/special_offering/special_offering_copy_variant.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../../helper/fake.dart';

void main() {
  setUp(() {
    // viewed useEffect で analytics.setUserProperties/logEvent を呼ぶため、Firebase未初期化のテストではFakeに差し替える
    analytics = FakeAnalytics();
  });

  group('#SpecialOfferingAnnouncementBar2', () {
    Future<void> pumpBar(
      WidgetTester tester, {
      required SpecialOfferingCopyVariant copyVariant,
      required bool useAlternativeText,
      required int missedDays,
    }) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Material(
              child: SpecialOfferingAnnouncementBar2(
                specialOfferingIsClosed2: ValueNotifier(false),
                missedDays: missedDays,
                useAlternativeText: useAlternativeText,
                copyVariant: copyVariant,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
    }

    group('default バリアント', () {
      testWidgets('missedDays表示側で経過日数と97.2%訴求文言が表示される',
          (WidgetTester tester) async {
        await pumpBar(
          tester,
          copyVariant: SpecialOfferingCopyVariant.defaultVariant,
          useAlternativeText: false,
          missedDays: 3,
        );

        expect(find.textContaining('過去30日間で3日記録がなかったようです'), findsOneWidget);
        expect(find.textContaining('97.2%の人が「飲み忘れが減った」と回答！'), findsOneWidget);
        expect(find.textContaining('このオファーは今回限り。'), findsNothing);
      });

      testWidgets('代替テキスト側で不安訴求と97.2%訴求文言が表示される', (WidgetTester tester) async {
        await pumpBar(
          tester,
          copyVariant: SpecialOfferingCopyVariant.defaultVariant,
          useAlternativeText: true,
          missedDays: 3,
        );

        expect(find.textContaining('飲み忘れの不安ありませんか？'), findsOneWidget);
        expect(find.textContaining('97.2%の人が「飲み忘れが減った」と回答！'), findsOneWidget);
        expect(find.textContaining('このオファーは今回限り。'), findsNothing);
      });
    });

    group('scarcity バリアント', () {
      testWidgets('missedDays表示側で経過日数と希少性訴求文言が表示される',
          (WidgetTester tester) async {
        await pumpBar(
          tester,
          copyVariant: SpecialOfferingCopyVariant.scarcity,
          useAlternativeText: false,
          missedDays: 3,
        );

        expect(find.textContaining('過去30日間で3日記録がなかったようです'), findsOneWidget);
        expect(find.textContaining('このオファーは今回限り。'), findsOneWidget);
        expect(find.textContaining('特別価格でプレミアムを始めるチャンス！'), findsOneWidget);
        // 現行の97.2%訴求文言は表示されない
        expect(find.textContaining('97.2%の人が「飲み忘れが減った」と回答！'), findsNothing);
      });

      testWidgets('代替テキスト側で不安訴求と希少性訴求文言が表示される', (WidgetTester tester) async {
        await pumpBar(
          tester,
          copyVariant: SpecialOfferingCopyVariant.scarcity,
          useAlternativeText: true,
          missedDays: 3,
        );

        expect(find.textContaining('飲み忘れの不安ありませんか？'), findsOneWidget);
        expect(find.textContaining('このオファーは今回限り。'), findsOneWidget);
        expect(find.textContaining('特別価格でプレミアムを始めるチャンス！'), findsOneWidget);
        expect(find.textContaining('97.2%の人が「飲み忘れが減った」と回答！'), findsNothing);
      });
    });
  });
}
