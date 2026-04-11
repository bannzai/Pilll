import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_general.dart';

void main() {
  group('#RecommendSignupGeneralAnnouncementBar', () {
    testWidgets('タイトル文言が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(
              child: RecommendSignupGeneralAnnouncementBar(),
            ),
          ),
        ),
      );

      expect(find.text(L.recommendSignupGeneralTitle), findsOneWidget);
    });

    testWidgets('説明文が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(
              child: RecommendSignupGeneralAnnouncementBar(),
            ),
          ),
        ),
      );

      expect(find.text(L.recommendSignupGeneralDescription), findsOneWidget);
    });

    testWidgets('× ボタン (Icons.close) は表示されない (既存 RecommendSignupForPremium と同様)', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(
              child: RecommendSignupGeneralAnnouncementBar(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
