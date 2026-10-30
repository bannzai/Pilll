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

    testWidgets(
        '文字サイズごとに拡大率が違う非線形の文字拡大 (Android) でも、Premium バッジはバッジの文字 (12) の拡大率で大きくなる',
        (WidgetTester tester) async {
      // 文言を 1 行に収め、バッジの高さだけを比べられる広い画面にする
      tester.view.physicalSize = const Size(2000, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      Future<double> badgeHeight({required TextScaler textScaler}) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              setSettingProvider.overrideWith((ref) => MockSetSetting())
            ],
            child: MaterialApp(
              home: Builder(
                builder: (context) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: textScaler),
                  child: const Scaffold(
                    body: CreatingNewPillSheetRow(
                        setting: setting,
                        isTrial: false,
                        isPremium: false,
                        trialDeadlineDate: null),
                  ),
                ),
              ),
            ),
          ),
        );
        return tester.getRect(find.byType(PremiumBadge)).height;
      }

      final unscaledHeight =
          await badgeHeight(textScaler: TextScaler.noScaling);
      // 12 は 2 倍、文言の 16 は 1.75 倍に拡大する
      expect(await badgeHeight(textScaler: const _NonLinearTextScaler()),
          moreOrLessEquals(unscaledHeight * 2, epsilon: 1));
    });

    testWidgets('プレミアムユーザーには Premium バッジを表示しない', (WidgetTester tester) async {
      await tester.pumpWidget(subject(isPremium: true));

      expect(find.byType(PremiumBadge), findsNothing);
    });
  });
}

/// Android の非線形の文字拡大を模した TextScaler。12 以下は 2 倍、それより大きい文字は 12 を超えた分を 1 倍で足す (16 は 28 で 1.75 倍)
class _NonLinearTextScaler extends TextScaler {
  const _NonLinearTextScaler();

  @override
  double scale(double fontSize) =>
      fontSize <= 12 ? fontSize * 2 : 24 + (fontSize - 12);

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => 2;

  @override
  TextScaler clamp(
          {double minScaleFactor = 0,
          double maxScaleFactor = double.infinity}) =>
      this;
}
