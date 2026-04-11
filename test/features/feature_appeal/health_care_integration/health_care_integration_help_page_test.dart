import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_help_page.dart';
import 'package:pilll/features/localizations/l.dart';

void main() {
  group('#HealthCareIntegrationHelpPage', () {
    testWidgets('ヘッドライン文言が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HealthCareIntegrationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.healthCareIntegrationFeatureAppealHeadline), findsOneWidget);
    });

    testWidgets('本文が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HealthCareIntegrationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.healthCareIntegrationFeatureAppealBody), findsOneWidget);
    });

    testWidgets('「実際に試す」ボタン (PrimaryButton) が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HealthCareIntegrationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text(L.featureAppealTryFeature), findsOneWidget);
    });

    testWidgets('AppBar にタイトルが表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HealthCareIntegrationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.healthCareIntegrationFeatureAppealTitle), findsOneWidget);
    });
  });
}
