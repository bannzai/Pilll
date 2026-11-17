import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/menstruation/page.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/first_weekday.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

/// 生理の記録もピルシートも無い利用者の設定。週カレンダーと AppBar の月表示はこの値に依存しない
const _setting = Setting(
  pillNumberForFromMenstruation: 0,
  durationMenstruation: 0,
  isOnReminder: true,
  timezoneDatabaseName: 'Asia/Tokyo',
);

/// today() が [date] を返すようにする
void _mockToday({required String date}) {
  final mockTodayRepository = MockTodayService();
  todayRepository = mockTodayRepository;
  when(mockTodayRepository.now()).thenReturn(DateTime.parse(date));
}

/// AppBar の月表示を英語の月名の省略形 (Sep・Oct) に固定し、テスト終了時に元の表示言語へ戻す。
/// 月表示は Intl.defaultLocale の書式で出るため、実行する環境の言語で期待値が変わらないようにする
void _useEnglishMonthName() {
  final defaultLocale = Intl.defaultLocale;
  Intl.defaultLocale = 'en_US';
  addTearDown(() => Intl.defaultLocale = defaultLocale);
}

/// 生理の記録もピルシートも無い利用者の [MenstruationPageBody] を、週の始まりを [firstWeekday] にして返す
Widget _menstruationPageBody({required Weekday firstWeekday}) {
  return ProviderScope(
    overrides: [
      firstWeekdayProvider.overrideWithValue(firstWeekday),
      // MenstruationRecordButton が記録用の provider を通して読む。描画では Firestore に書き込まないため Mock にする
      databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
    ],
    child: const MaterialApp(
      home: MenstruationPageBody(
        latestPillSheetGroup: null,
        user: User(),
        allMenstruation: [],
        latestMenstruation: null,
        setting: _setting,
        diaries: [],
        schedules: [],
        calendarMenstruationBandModels: [],
        calendarScheduledMenstruationBandModels: [],
        calendarNextPillSheetBandModels: [],
      ),
    ),
  );
}

/// AppBar に表示している月
String? _appBarMonth(WidgetTester tester) {
  return tester
      .widget<Text>(find.descendant(
          of: find.byType(AppBar), matching: find.byType(Text)))
      .data;
}

/// 週カレンダーに表示している 1 週間の日付
List<DateTime> _displayedWeekDates(WidgetTester tester) {
  return tester
      .widgetList<CalendarDayTile>(find.byType(CalendarDayTile))
      .map((calendarDayTile) => calendarDayTile.date)
      .toList();
}

/// [begin] から 7 日間の日付
List<DateTime> _weekDates({required String begin}) {
  return List.generate(
      7, (index) => DateTime.parse(begin).add(Duration(days: index)));
}

void main() {
  group("AppBar", () {
    group("今日を含む週を表示している", () {
      // 月表示は表示中の週の右端の日付の月。右端は日曜日始まりで土曜日、月曜日始まりで日曜日になる
      for (final (today, firstWeekday, month, scenario) in [
        (
          "2020-09-27",
          Weekday.Sunday,
          "Oct",
          "今日が日曜日 (9/27) で日曜日始まりの週は 9/27〜10/3 なので右端の 10 月",
        ),
        (
          "2020-09-27",
          Weekday.Monday,
          "Sep",
          "今日が日曜日 (9/27) で月曜日始まりの週は 9/21〜9/27 なので右端の 9 月",
        ),
        (
          "2020-09-30",
          Weekday.Sunday,
          "Oct",
          "今日が水曜日 (9/30) で日曜日始まりの週は 9/27〜10/3 なので右端の 10 月",
        ),
        (
          "2020-09-30",
          Weekday.Monday,
          "Oct",
          "今日が水曜日 (9/30) で月曜日始まりの週は 9/28〜10/4 なので右端の 10 月",
        ),
        (
          "2020-12-27",
          Weekday.Sunday,
          "Jan",
          "年をまたぐ。今日が日曜日 (12/27) で日曜日始まりの週は 12/27〜1/2 なので右端の 1 月",
        ),
        (
          "2020-12-27",
          Weekday.Monday,
          "Dec",
          "年をまたがない。今日が日曜日 (12/27) で月曜日始まりの週は 12/21〜12/27 なので右端の 12 月",
        ),
        (
          "2020-02-29",
          Weekday.Sunday,
          "Feb",
          "うるう年。今日が土曜日 (2/29) で日曜日始まりの週は 2/23〜2/29 なので右端の 2 月",
        ),
        (
          "2020-02-29",
          Weekday.Monday,
          "Mar",
          "うるう年。今日が土曜日 (2/29) で月曜日始まりの週は 2/24〜3/1 なので右端の 3 月",
        ),
      ]) {
        testWidgets(scenario, (WidgetTester tester) async {
          _mockToday(date: today);
          _useEnglishMonthName();

          await tester
              .pumpWidget(_menstruationPageBody(firstWeekday: firstWeekday));
          await tester.pump();

          expect(_appBarMonth(tester), month);
        });
      }
    });
    group("今日を含む週から別の週へページを動かした", () {
      for (final (today, firstWeekday, pageOffset, month, scenario) in [
        (
          "2020-09-20",
          Weekday.Sunday,
          1,
          "Oct",
          "今日が日曜日 (9/20) で日曜日始まりの次の週は 9/27〜10/3 なので右端の 10 月",
        ),
        (
          "2020-09-20",
          Weekday.Monday,
          1,
          "Sep",
          "今日が日曜日 (9/20) で月曜日始まりの次の週は 9/21〜9/27 なので右端の 9 月",
        ),
        (
          "2020-10-04",
          Weekday.Sunday,
          -1,
          "Oct",
          "今日が日曜日 (10/4) で日曜日始まりの前の週は 9/27〜10/3 なので右端の 10 月",
        ),
        (
          "2020-10-04",
          Weekday.Monday,
          -1,
          "Sep",
          "今日が日曜日 (10/4) で月曜日始まりの前の週は 9/21〜9/27 なので右端の 9 月",
        ),
      ]) {
        testWidgets(scenario, (WidgetTester tester) async {
          _mockToday(date: today);
          _useEnglishMonthName();

          await tester
              .pumpWidget(_menstruationPageBody(firstWeekday: firstWeekday));
          await tester.pump();

          // 月表示が表示中のページに追従することを確かめるため、スワイプの代わりに PageController でページを動かす
          final pageController =
              tester.widget<PageView>(find.byType(PageView)).controller!;
          pageController.jumpToPage(pageController.page!.toInt() + pageOffset);
          await tester.pump();

          expect(_appBarMonth(tester), month);
        });
      }
    });
  });
  group("MenstruationPageBody", () {
    // 今日は日曜日 (2020-09-13)。今日を含む週は、日曜日始まりで 9/13〜9/19、月曜日始まりで 9/7〜9/13 になり、
    // 週カレンダーの中でのページ位置が 1 つずれる
    for (final (isFirstWeekdayMonday, weekBegin, toggledWeekBegin, scenario)
        in [
      (
        false,
        "2020-09-13",
        "2020-09-07",
        "日曜日始まりで表示している時に月曜日始まりへ切り替えると、今日を含む月曜日始まりの週 (9/7〜9/13) を表示する",
      ),
      (
        true,
        "2020-09-07",
        "2020-09-13",
        "月曜日始まりで表示している時に日曜日始まりへ切り替えると、今日を含む日曜日始まりの週 (9/13〜9/19) を表示する",
      ),
    ]) {
      testWidgets(scenario, (WidgetTester tester) async {
        _mockToday(date: "2020-09-13");
        _useEnglishMonthName();
        SharedPreferences.setMockInitialValues(
            {BoolKey.isFirstWeekdayMonday: isFirstWeekdayMonday});

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider
                  .overrideWithValue(await SharedPreferences.getInstance()),
              // MenstruationRecordButton が記録用の provider を通して読む。描画では Firestore に書き込まないため Mock にする
              databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
              userProvider.overrideWith((ref) => Stream.value(const User())),
              settingProvider.overrideWith((ref) => Stream.value(_setting)),
              latestPillSheetGroupProvider
                  .overrideWith((ref) => Stream.value(null)),
              allMenstruationProvider
                  .overrideWith((ref) => Stream.value(<Menstruation>[])),
              diariesFor90Days
                  .overrideWith((ref, base) => Stream.value(<Diary>[])),
              schedules90Days
                  .overrideWith((ref, base) => Stream.value(<Schedule>[])),
              calendarMenstruationBandListProvider
                  .overrideWithValue(const AsyncData([])),
              calendarScheduledMenstruationBandListProvider
                  .overrideWithValue(const AsyncData([])),
              calendarNextPillSheetBandListProvider
                  .overrideWithValue(const AsyncData([])),
            ],
            child: const MaterialApp(home: MenstruationPage()),
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(_displayedWeekDates(tester), _weekDates(begin: weekBegin));
        expect(_appBarMonth(tester), "Sep");

        await ProviderScope.containerOf(
                tester.element(find.byType(MenstruationPage)))
            .read(boolSharedPreferencesProvider(BoolKey.isFirstWeekdayMonday)
                .notifier)
            .set(!isFirstWeekdayMonday);
        await tester.pump();
        await tester.pump();

        expect(
            _displayedWeekDates(tester), _weekDates(begin: toggledWeekBegin));
        expect(_appBarMonth(tester), "Sep");
      });
    }
  });
}
