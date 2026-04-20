import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';

void main() {
  group('#MenstruationAnnouncementBar', () {
    testWidgets('isClosed=false の状態でタイトル・説明文の Text Widget が表示される',
        (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MenstruationAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      // タイトルと説明文で少なくとも2つの Text が存在する
      expect(find.byType(Text), findsAtLeast(2));
    });

    testWidgets('isClosed=false の状態で × ボタン (Icons.close) が表示される',
        (tester) async {
      final isClosed = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MenstruationAnnouncementBar(isClosed: isClosed),
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
            child: MenstruationAnnouncementBar(isClosed: isClosed),
          ),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
    });
  });
}
