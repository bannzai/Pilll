import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/features/menstruation/menstruation_card.dart';
import 'package:pilll/features/menstruation/menstruation_card_state.codegen.dart';

void main() {
  setUp(() async {
    // DateTimeFormatter.monthAndWeekday は表示言語 (Intl.defaultLocale) で書式を引くため、全ロケールを読み込む
    await initializeDateFormatting();
  });

  group('#MenstruationCard', () {
    /// 生理予定日カードを本番と同じ余白のリストに置いて返す。title はカードのラベル
    Widget subject({required String title}) {
      return MaterialApp(
        home: Scaffold(
          body: ListView(
            // 本番 MenstruationCardList と同じ左右 16 の余白
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              MenstruationCard(
                MenstruationCardState(
                  title: title,
                  scheduleDate: DateTime.parse('2026-12-31'),
                  countdownString: 'in 5 days',
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// 画面を幅の狭い端末 (320pt) の大きさにし、テストの終わりに戻す
    void setNarrowScreen(WidgetTester tester) {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
    }

    testWidgets('ラベルが長い場合 (de の旧訳) もはみ出さず、日付はラベルの次の行に表示される', (
      WidgetTester tester,
    ) async {
      setNarrowScreen(tester);
      const title = 'Voraussichtlicher Beginn der nächsten Periode';
      await tester.pumpWidget(subject(title: title));

      expect(tester.takeException(), isNull);
      final cardRect = tester.getRect(find.byType(MenstruationCard));
      final titleRect = tester.getRect(find.text(title));
      final dateRect = tester.getRect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data != title &&
              widget.data != 'in 5 days',
        ),
      );
      expect(titleRect.left, greaterThanOrEqualTo(cardRect.left));
      expect(titleRect.right, lessThanOrEqualTo(cardRect.right));
      expect(dateRect.top, greaterThanOrEqualTo(titleRect.bottom));
    });

    testWidgets('ラベルと日付が幅に収まる場合は 1 行に並び、高さは従来の 111 のまま', (
      WidgetTester tester,
    ) async {
      // テストのフォントは 1 文字が文字サイズの正方形で実機より幅を取るため、ラベルと日付が 1 行に収まる広い画面にする
      tester.view.physicalSize = const Size(800, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      const title = 'Nächste Periode';
      await tester.pumpWidget(subject(title: title));

      expect(tester.takeException(), isNull);
      final titleRect = tester.getRect(find.text(title));
      final dateRect = tester.getRect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data != title &&
              widget.data != 'in 5 days',
        ),
      );
      expect(dateRect.left, greaterThan(titleRect.right));
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(tester.getSize(find.byType(MenstruationCard)).height, 111);
    });
  });
}
