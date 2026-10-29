import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/settings/components/rows/creating_new_pillsheet.dart';
import 'package:pilll/provider/setting.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  group('#CreatingNewPillSheetRow', () {
    const setting = Setting(
      pillNumberForFromMenstruation: 0,
      durationMenstruation: 0,
      isOnReminder: true,
      timezoneDatabaseName: 'Asia/Tokyo',
    );

    Widget subject({required bool isPremium}) {
      return ProviderScope(
        overrides: [setSettingProvider.overrideWith((ref) => MockSetSetting())],
        child: MaterialApp(
          home: Scaffold(
            body: CreatingNewPillSheetRow(
              setting: setting,
              isTrial: false,
              isPremium: isPremium,
              trialDeadlineDate: null,
            ),
          ),
        ),
      );
    }

    testWidgets('無料ユーザーで文言が 2 行に折り返す場合、Premium バッジは 2 行目の文言の後ろに続く', (
      WidgetTester tester,
    ) async {
      // 文言が 1 行に収まらない幅の狭い端末にする
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(subject(isPremium: false));

      expect(tester.takeException(), isNull);
      final title = find
          .descendant(
            of: find.byType(ListTile),
            matching: find.byType(RichText),
          )
          .first;
      final titleRect = tester.getRect(title);
      final badgeRect = tester.getRect(find.byType(PremiumBadge));
      // 2 行に折り返している
      expect(titleRect.height, greaterThan(badgeRect.height * 1.5));
      // バッジが 2 行の間ではなく、下の行に置かれている
      expect(badgeRect.center.dy, greaterThan(titleRect.center.dy));
      expect(badgeRect.right, lessThanOrEqualTo(titleRect.right));
    });

    testWidgets('プレミアムユーザーには Premium バッジを表示しない', (WidgetTester tester) async {
      await tester.pumpWidget(subject(isPremium: true));

      expect(find.byType(PremiumBadge), findsNothing);
    });
  });
}
