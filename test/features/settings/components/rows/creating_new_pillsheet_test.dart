import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
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
              of: find.byType(ListTile), matching: find.byType(RichText))
          .first;
      final titleRect = tester.getRect(title);
      final badgeRect = tester.getRect(find.byType(PremiumBadge));
      // 2 行に折り返している
      expect(titleRect.height, greaterThan(badgeRect.height * 1.5));
      // バッジが文言の最後の文字と同じ行にある (2 行の間や、文言の次の行に浮いていない)
      final lastCharacterBox = tester
          .renderObject<RenderParagraph>(title)
          .getBoxesForSelection(TextSelection(
              baseOffset: L.autoAddPillSheetGroup.length - 1,
              extentOffset: L.autoAddPillSheetGroup.length))
          .single;
      expect(badgeRect.center.dy - titleRect.top,
          inInclusiveRange(lastCharacterBox.top, lastCharacterBox.bottom));
      expect(badgeRect.right, lessThanOrEqualTo(titleRect.right));
    });

    testWidgets('文字を拡大しても、Premium バッジの文字は拡大率の分だけ大きくなり、二重に拡大されない',
        (WidgetTester tester) async {
      // 文言を 1 行に収め、バッジの高さだけを比べられる広い画面にする
      tester.view.physicalSize = const Size(2000, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      Future<double> badgeHeight({required double textScale}) async {
        tester.platformDispatcher.textScaleFactorTestValue = textScale;
        await tester.pumpWidget(subject(isPremium: false));
        return tester.getRect(find.byType(PremiumBadge)).height;
      }

      final unscaledHeight = await badgeHeight(textScale: 1);
      expect(await badgeHeight(textScale: 2),
          moreOrLessEquals(unscaledHeight * 2, epsilon: 1));
    });

    testWidgets('プレミアムユーザーには Premium バッジを表示しない', (WidgetTester tester) async {
      await tester.pumpWidget(subject(isPremium: true));

      expect(find.byType(PremiumBadge), findsNothing);
    });
  });
}
