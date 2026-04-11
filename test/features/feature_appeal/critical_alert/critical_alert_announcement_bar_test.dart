import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_announcement_bar.dart';
import 'package:pilll/features/localizations/l.dart';

void main() {
  group('#CriticalAlertAnnouncementBar', () {
    testWidgets('isClosed=false の状態でタイトル文言が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CriticalAlertAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.text(L.criticalAlertFeatureAppealTitle), findsOneWidget);
    });

    testWidgets('isClosed=false の状態で短い説明文が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CriticalAlertAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.text(L.criticalAlertFeatureAppealShortDescription), findsOneWidget);
    });

    testWidgets('isClosed=false の状態で × ボタン (Icons.close) が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CriticalAlertAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('isClosed=false の状態で右矢印 SVG が表示される', (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: CriticalAlertAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
