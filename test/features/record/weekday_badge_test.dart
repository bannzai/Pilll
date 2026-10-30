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
      // 描かれた行の数を、各文字の矩形の上端の種類の数で数える
      expect(
        tester
            .renderObject<RenderParagraph>(text)
            .getBoxesForSelection(TextSelection(
                baseOffset: 0,
                extentOffset: Weekday.Sunday.weekdayString().length))
            .map((box) => box.top)
            .toSet()
            .length,
        1,
      );
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
      expect(tester.getRect(text).width,
          tester.renderObject<RenderParagraph>(text).size.width);
    });
  });
}
