import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/menstruation_list/menstruation_list_row.dart';
import 'package:pilll/l10n/app_localizations.dart';

void main() {
  setUpAll(() async {
    // 行の日付範囲 (DateTimeFormatter.monthAndDay) が DateFormat を使うため
    await initializeDateFormatting();
  });

  group('#MenstruationListRow', () {
    /// 表示言語を lang にして、menstruation と previousMenstruation の行を pump する。言語はテストの終わりに戻す
    Future<void> pumpSubject(
      WidgetTester tester, {
      required String lang,
      required Menstruation menstruation,
      required Menstruation? previousMenstruation,
    }) async {
      final originalL = L;
      addTearDown(() => L = originalL);
      L = lookupAppLocalizations(Locale(lang));

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: MenstruationListRow(
                menstruation: menstruation,
                previousMenstruation: previousMenstruation,
              ),
            ),
          ),
        ),
      );
    }

    /// textFinder の文字が、周期の長さを表す棒 (最も近い祖先の Container) の中に収まっていることを確かめる
    void expectTextInsideBar(WidgetTester tester, Finder textFinder) {
      final textRect = tester.getRect(textFinder);
      final barRect = tester.getRect(find
          .ancestor(of: textFinder, matching: find.byType(Container))
          .first);
      expect(textRect.left, greaterThanOrEqualTo(barRect.left));
      expect(textRect.right, lessThanOrEqualTo(barRect.right));
    }

    // 前回の生理開始日から 28 日後に始まった 5 日間の生理
    final menstruation = Menstruation(
      beginDate: DateTime.parse('2020-09-29'),
      endDate: DateTime.parse('2020-10-03'),
      createdAt: DateTime.parse('2020-09-29'),
    );
    final previousMenstruation = Menstruation(
      beginDate: DateTime.parse('2020-09-01'),
      endDate: DateTime.parse('2020-09-05'),
      createdAt: DateTime.parse('2020-09-01'),
    );

    testWidgets('ja では周期が「28日周期」と表示される', (tester) async {
      await pumpSubject(tester,
          lang: 'ja',
          menstruation: menstruation,
          previousMenstruation: previousMenstruation);

      expect(tester.takeException(), isNull);
      expect(find.text('28日周期'), findsOneWidget);
      expectTextInsideBar(tester, find.text('28日周期'));
    });

    for (final (lang, expected) in [
      ('en', '28-day menstrual cycle'),
      ('de', 'Zyklus von 28 Tagen'),
    ]) {
      testWidgets('$lang では周期が各言語の訳で表示され、日本語の「日周期」を表示しない', (tester) async {
        await pumpSubject(tester,
            lang: lang,
            menstruation: menstruation,
            previousMenstruation: previousMenstruation);

        expect(tester.takeException(), isNull);
        expect(find.text(expected), findsOneWidget);
        expect(find.textContaining('日周期'), findsNothing);
        expectTextInsideBar(tester, find.text(expected));
      });
    }

    testWidgets('周期が短く生理の日数が長い棒 (21 日周期・8 日間) でも、訳の長い zu の周期がはみ出さず棒の中に収まる',
        (tester) async {
      await pumpSubject(
        tester,
        lang: 'zu',
        menstruation: Menstruation(
          beginDate: DateTime.parse('2020-09-22'),
          endDate: DateTime.parse('2020-09-29'),
          createdAt: DateTime.parse('2020-09-22'),
        ),
        previousMenstruation: previousMenstruation,
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Umjikelezo wokuya esikhathini wezinsuku ezingu-21'),
          findsOneWidget);
      expectTextInsideBar(tester,
          find.text('Umjikelezo wokuya esikhathini wezinsuku ezingu-21'));
    });

    testWidgets('前回の生理が無い時は周期を「-」と表示する', (tester) async {
      await pumpSubject(tester,
          lang: 'de', menstruation: menstruation, previousMenstruation: null);

      expect(tester.takeException(), isNull);
      expect(find.text('-'), findsOneWidget);
      expect(find.textContaining('Zyklus'), findsNothing);
    });
  });
}
