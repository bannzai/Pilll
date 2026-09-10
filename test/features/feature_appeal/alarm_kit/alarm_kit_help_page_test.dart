import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_help_page.dart';
import 'package:pilll/features/feature_appeal/feature_appeal_premium_plan_button.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  group('#AlarmKitHelpPage', () {
    List<Override> helpPageProviderOverrides({User user = const User()}) {
      return [
        userProvider.overrideWith((ref) => Stream.value(user)),
        settingProvider.overrideWith(
          (ref) => Stream.value(
            const Setting(
              pillNumberForFromMenstruation: 22,
              durationMenstruation: 5,
              isOnReminder: false,
              timezoneDatabaseName: null,
            ),
          ),
        ),
      ];
    }

    testWidgets('見出し・本文の Text Widget が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsAtLeast(2));
    });

    testWidgets('PrimaryButton が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('AppBar と戻るボタンが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('トライアル中ユーザー → 「確認する」の下に Premium プランへの導線 (AppOutlinedButton) が表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime(2026, 9, 10);
      when(mockTodayRepository.now()).thenReturn(mockToday);
      todayRepository = mockTodayRepository;

      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(user: User(isPremium: false, trialDeadlineDate: mockToday.add(const Duration(days: 10)))),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FeatureAppealPremiumPlanButton), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.byType(AppOutlinedButton), findsOneWidget);
    });

    testWidgets('トライアル未開始ユーザー (User()) → Premium プランへの導線は出ず「確認する」だけ', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.byType(AppOutlinedButton), findsNothing);
    });
  });
}
