import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/feature_appeal/feature_appeal_premium_plan_button.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

void main() {
  final mockToday = DateTime(2026, 9, 10);

  setUp(() {
    analytics = FakeAnalytics();
    final mockTodayRepository = MockTodayService();
    when(mockTodayRepository.now()).thenReturn(mockToday);
    todayRepository = mockTodayRepository;
  });

  Widget subject({required User user}) {
    return ProviderScope(
      overrides: [
        userProvider.overrideWith((ref) => Stream.value(user)),
      ],
      child: const MaterialApp(
        home: Material(
          child: FeatureAppealPremiumPlanButton(featureKey: 'alarm_kit', paywallSource: PaywallSource.featureAppealAlarmKit),
        ),
      ),
    );
  }

  group('#FeatureAppealPremiumPlanButton', () {
    testWidgets('トライアル中 (isPremium=false, trialDeadlineDate が未来) → AppOutlinedButton が表示される', (tester) async {
      await tester.pumpWidget(subject(user: User(isPremium: false, trialDeadlineDate: mockToday.add(const Duration(days: 10)))));
      await tester.pumpAndSettle();

      expect(find.byType(AppOutlinedButton), findsOneWidget);
    });

    testWidgets('トライアル終了後の無料ユーザー (trialDeadlineDate が過去) → 「確認する」が paywall を開くため表示しない', (tester) async {
      await tester.pumpWidget(subject(user: User(isPremium: false, trialDeadlineDate: mockToday.subtract(const Duration(days: 1)))));
      await tester.pumpAndSettle();

      expect(find.byType(AppOutlinedButton), findsNothing);
    });

    testWidgets('トライアル未開始 (trialDeadlineDate=null) → 表示しない', (tester) async {
      await tester.pumpWidget(subject(user: const User(isPremium: false, trialDeadlineDate: null)));
      await tester.pumpAndSettle();

      expect(find.byType(AppOutlinedButton), findsNothing);
    });

    testWidgets('Premium 会員 (トライアル期間内でも) → 表示しない', (tester) async {
      await tester.pumpWidget(subject(user: User(isPremium: true, trialDeadlineDate: mockToday.add(const Duration(days: 10)))));
      await tester.pumpAndSettle();

      expect(find.byType(AppOutlinedButton), findsNothing);
    });
  });
}
