import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_general.dart';

void main() {
  group('#RecommendSignupGeneralAnnouncementBar', () {
    testWidgets('Bar が描画される: アラートアイコン・矢印・Text 2件を含む', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Material(
              child: RecommendSignupGeneralAnnouncementBar(),
            ),
          ),
        ),
      );

      expect(find.byType(RecommendSignupGeneralAnnouncementBar), findsOneWidget);
      // alert_24.svg + arrow_right.svg
      expect(find.byType(SvgPicture), findsNWidgets(2));
      // タイトル + 説明文
      expect(find.byType(Text), findsNWidgets(2));
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
