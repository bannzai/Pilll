import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/record/weekday_badge.dart';

void main() {
  setUp(() async {
    // Weekday.weekdayString は端末のロケール (Platform.localeName) の曜日の略記を引くため、全ロケールを読み込む
    await initializeDateFormatting();
  });

  group('#WeekdayBadge', () {
    testWidgets('曜日の略記がバッジの幅 20 を超える文字サイズでも、1 行のまま幅に収まる', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            // 略記を幅 20 より広くするため、文字を 4 倍にする (pt「dom.」・fr「sam.」が幅を超えるのと同じ状態)
            data: const MediaQueryData(textScaler: TextScaler.linear(4)),
            child: Scaffold(
              body: Center(child: WeekdayBadge(weekday: Weekday.Sunday)),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final text = find.descendant(
        of: find.byType(WeekdayBadge),
        matching: find.byType(Text),
      );
      final paragraph = tester.renderObject<RenderParagraph>(text);
      expect(paragraph.computeLineMetrics().length, 1);
      expect(tester.getRect(text).width, lessThanOrEqualTo(20));
    });

    testWidgets('曜日の略記が幅に収まる場合は縮小されない', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MediaQuery(
            // 幅 20 に十分収まる文字サイズにする
            data: MediaQueryData(textScaler: TextScaler.linear(0.5)),
            child: Scaffold(
              body: Center(child: WeekdayBadge(weekday: Weekday.Sunday)),
            ),
          ),
        ),
      );

      final text = find.descendant(
        of: find.byType(WeekdayBadge),
        matching: find.byType(Text),
      );
      final paragraph = tester.renderObject<RenderParagraph>(text);
      expect(tester.getRect(text).width, paragraph.size.width);
    });
  });
}
