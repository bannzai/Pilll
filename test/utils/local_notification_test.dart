import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

import '../helper/mock.mocks.dart';

void main() {
  group("#reminderPillDisplayNumberFor", () {
    // 日付の真昼にする。ちょうど0時だと、その日に開始するピルシートが isBegan(開始日 < 現在時刻) を満たさず、前のピルシートがアクティブのままになるため
    void mockToday(String date) {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("${date.substring(0, 10)}T12:00:00"));
    }

    // 連続番号は PillSheetGroup のインスタンスごとに今日を基準に遅延初期化されるため、今日を変えて比較する時は毎回新しく作る
    PillSheetGroup pillSheetGroupWith({
      required PillSheetAppearanceMode appearanceMode,
      required PillSheetType pillSheetType,
      required RestDuration restDuration,
      required List<String> beginDates,
    }) {
      final pillSheets = [
        for (final (index, beginDate) in beginDates.indexed)
          PillSheet.v1(
            id: "pill_sheet_id_$index",
            groupIndex: index,
            typeInfo: pillSheetType.typeInfo,
            beginDate: DateTime.parse(beginDate),
            lastTakenDate: null,
            createdAt: DateTime.parse("2022-05-01"),
            restDurations: index == 0 ? [restDuration] : [],
          ),
      ];
      return PillSheetGroup(
        pillSheetIDs: pillSheets.map((e) => e.id!).toList(),
        pillSheets: pillSheets,
        createdAt: DateTime.parse("2022-05-01"),
        pillSheetAppearanceMode: appearanceMode,
      );
    }

    /// 今日(mockToday の日付)に登録するリマインドの、(通知を出す日, 表示する番号) を run と同じ手順で求める
    List<(DateTime, String)> registeredReminderNumbers({required PillSheetGroup pillSheetGroup}) {
      final activePillSheet = pillSheetGroup.activePillSheet!;
      return [
        for (final (pillDayOffset, dayOffset) in reminderDayOffsetsFor(restDurations: pillSheetGroup.restDurations).indexed)
          (
            today().addDays(dayOffset),
            reminderPillDisplayNumberFor(
              pillSheetGroup: pillSheetGroup,
              pageIndex: activePillSheet.groupIndex,
              pillNumberInPillSheet: activePillSheet.todayPillNumber + pillDayOffset,
              reminderDate: today().addDays(dayOffset),
            ),
          ),
      ];
    }

    for (final appearanceMode in [PillSheetAppearanceMode.cyclicSequential, PillSheetAppearanceMode.sequential]) {
      group("$appearanceMode", () {
        test("5/1開始・5/8から服用お休み・服用再開予定日5/15を5/10に登録した通知の番号が、その日に画面が表示する番号と一致する", () {
          final restDuration = RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-08"),
            createdDate: DateTime.parse("2022-05-08"),
            endDate: DateTime.parse("2022-05-15"),
          );
          PillSheetGroup build() => pillSheetGroupWith(
                appearanceMode: appearanceMode,
                pillSheetType: PillSheetType.pillsheet_28_0,
                restDuration: restDuration,
                beginDates: ["2022-05-01"],
              );

          mockToday("2022-05-10");
          final reminders = registeredReminderNumbers(pillSheetGroup: build());
          // 予定日(5/15)より前は登録せず、5/15から10日分
          expect(reminders.first.$1, DateTime.parse("2022-05-15"));
          expect(reminders.length, 10);

          for (final (date, number) in reminders) {
            mockToday(date.toIso8601String());
            final screenPillSheetGroup = build();
            final screenNumber = screenPillSheetGroup.displayPillNumberWithoutDate(
              pageIndex: 0,
              pillNumberInPillSheet: screenPillSheetGroup.activePillSheet!.todayPillNumber,
            );
            expect(number, screenNumber, reason: "$date の通知の番号が画面の番号と一致しない");
          }
        });

        test("再開日(5/15)の通知は1番になり、以降は連続する", () {
          final restDuration = RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-08"),
            createdDate: DateTime.parse("2022-05-08"),
            endDate: DateTime.parse("2022-05-15"),
          );
          mockToday("2022-05-10");

          final reminders = registeredReminderNumbers(
            pillSheetGroup: pillSheetGroupWith(
              appearanceMode: appearanceMode,
              pillSheetType: PillSheetType.pillsheet_28_0,
              restDuration: restDuration,
              beginDates: ["2022-05-01"],
            ),
          );

          expect(reminders.map((e) => e.$2).toList(), ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]);
        });

        test("2枚目にまたがる通知の番号も、その日に画面が表示する番号と一致する", () {
          // 28錠(pillsheet_21は21錠+7日の休薬で28日)で5/22から服用お休み、予定日5/27。5/24に登録する。
          // 1枚目の最後のピルは6/2で、2枚目は6/3開始(予定日まで含めて確定した開始日)
          final restDuration = RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-22"),
            createdDate: DateTime.parse("2022-05-22"),
            endDate: DateTime.parse("2022-05-27"),
          );
          PillSheetGroup build() => pillSheetGroupWith(
                appearanceMode: appearanceMode,
                pillSheetType: PillSheetType.pillsheet_21,
                restDuration: restDuration,
                beginDates: ["2022-05-01", "2022-06-03"],
              );

          mockToday("2022-05-24");
          final activePillSheet = build().activePillSheet!;
          final reminders = [
            for (final (pillDayOffset, dayOffset) in reminderDayOffsetsFor(restDurations: build().restDurations).indexed)
              (
                today().addDays(dayOffset),
                activePillSheet.todayPillNumber + pillDayOffset,
              ),
          ];
          // 2枚目の開始日(6/3)が登録の範囲に入っていること
          expect(reminders.any((e) => e.$1 == DateTime.parse("2022-06-03")), true);

          var crossedToSecondPillSheet = false;
          for (final (date, pillNumberInPillSheetWithOverflow) in reminders) {
            mockToday("2022-05-24");
            final isOverActivePillSheet = pillNumberInPillSheetWithOverflow > 28;
            final pillNumberInPillSheet = isOverActivePillSheet ? pillNumberInPillSheetWithOverflow - 28 : pillNumberInPillSheetWithOverflow;
            final pageIndex = isOverActivePillSheet ? 1 : 0;
            final notificationNumber = reminderPillDisplayNumberFor(
              pillSheetGroup: build(),
              pageIndex: pageIndex,
              pillNumberInPillSheet: pillNumberInPillSheet,
              reminderDate: date,
            );

            mockToday(date.toIso8601String());
            final screenPillSheetGroup = build();
            final screenActivePillSheet = screenPillSheetGroup.activePillSheet!;
            expect(screenActivePillSheet.groupIndex, pageIndex, reason: "$date のアクティブなピルシート");
            expect(screenActivePillSheet.todayPillNumber, pillNumberInPillSheet, reason: "$date のシート内のピル番号");
            expect(
              notificationNumber,
              screenPillSheetGroup.displayPillNumberWithoutDate(pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet),
              reason: "$date の通知の番号が画面の番号と一致しない",
            );
            crossedToSecondPillSheet = crossedToSecondPillSheet || isOverActivePillSheet;
          }
          expect(crossedToSecondPillSheet, true);
        });
      });
    }

    group("reminderDate", () {
      test("通知日時(時刻あり)を渡しても日付で計算し、today()ではなく渡した日付を基準にする", () {
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2022-05-08"),
          createdDate: DateTime.parse("2022-05-08"),
          endDate: DateTime.parse("2022-05-15"),
        );
        PillSheetGroup build() => pillSheetGroupWith(
              appearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pillSheetType: PillSheetType.pillsheet_28_0,
              restDuration: restDuration,
              beginDates: ["2022-05-01"],
            );
        mockToday("2022-05-10");

        // 登録の処理が日付をまたぐと today() は 5/11 になる。通知日(5/15 05:00)を渡すので、今日の値に依らず再開日の 1 番になる
        expect(
          reminderPillDisplayNumberFor(pillSheetGroup: build(), pageIndex: 0, pillNumberInPillSheet: 8, reminderDate: DateTime(2022, 5, 15, 5, 0)),
          "1",
        );
        mockToday("2022-05-11");
        expect(
          reminderPillDisplayNumberFor(pillSheetGroup: build(), pageIndex: 0, pillNumberInPillSheet: 8, reminderDate: DateTime(2022, 5, 15, 5, 0)),
          "1",
        );
        // 予定日の前日の通知日を渡すと、まだ服用お休み中の暫定の番号になる(8番)
        expect(
          reminderPillDisplayNumberFor(pillSheetGroup: build(), pageIndex: 0, pillNumberInPillSheet: 8, reminderDate: DateTime(2022, 5, 14, 5, 0)),
          "8",
        );
      });
    });

    group("number", () {
      test("服用再開予定日ありでも番号はシート内の番号のまま", () {
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2022-05-08"),
          createdDate: DateTime.parse("2022-05-08"),
          endDate: DateTime.parse("2022-05-15"),
        );
        mockToday("2022-05-10");

        final reminders = registeredReminderNumbers(
          pillSheetGroup: pillSheetGroupWith(
            appearanceMode: PillSheetAppearanceMode.number,
            pillSheetType: PillSheetType.pillsheet_28_0,
            restDuration: restDuration,
            beginDates: ["2022-05-01"],
          ),
        );

        // 5/10の番号は8番。服用お休み中は進まないので、予定日(5/15)の通知が8番、以降は9番、10番…
        expect(reminders.map((e) => e.$2).toList(), ["8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]);
      });
    });
  });

  group("#newPillSheetNotificationBaseDateFor", () {
    PillSheet lastPillSheetWith({required List<RestDuration> restDurations}) {
      return PillSheet.v1(
        id: "pill_sheet_id",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: DateTime.parse("2022-05-01"),
        restDurations: restDurations,
      );
    }

    void mockToday(String date) {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse(date));
    }

    test("服用お休みが無い場合は服用完了日(5/28)の翌日", () {
      mockToday("2022-05-10");

      expect(newPillSheetNotificationBaseDateFor(lastPillSheet: lastPillSheetWith(restDurations: [])), DateTime(2022, 5, 29, 23, 59, 59));
    });

    test("服用再開予定日ありの服用お休み中は、今日(5/10)までではなく予定日(5/15)まで含めた日の翌日", () {
      mockToday("2022-05-10");

      final lastPillSheet = lastPillSheetWith(
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-08"),
            createdDate: DateTime.parse("2022-05-08"),
            endDate: DateTime.parse("2022-05-15"),
          ),
        ],
      );
      // 5/1 + 27日 + 服用お休み7日(5/8〜5/15) = 6/4 なので、通知の基準日は6/5。今日で打ち切った estimatedEndTakenDate の翌日(5/31)ではない
      expect(newPillSheetNotificationBaseDateFor(lastPillSheet: lastPillSheet), DateTime(2022, 6, 5, 23, 59, 59));
      expect(lastPillSheet.estimatedEndTakenDate.addDays(1), DateTime(2022, 5, 31, 23, 59, 59));
    });

    test("endDateがnullの服用お休み中は今日までで数えた日の翌日", () {
      mockToday("2022-05-10");

      final lastPillSheet = lastPillSheetWith(
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-08"),
            createdDate: DateTime.parse("2022-05-08"),
          ),
        ],
      );
      // 5/1 + 27日 + 服用お休み2日(5/8〜5/10) = 5/30 なので、通知の基準日は5/31
      expect(newPillSheetNotificationBaseDateFor(lastPillSheet: lastPillSheet), DateTime(2022, 5, 31, 23, 59, 59));
    });

    test("境界値テスト：服用再開予定日が今日と同日の場合は全日数を数えた日の翌日", () {
      mockToday("2022-05-15");

      final lastPillSheet = lastPillSheetWith(
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-08"),
            createdDate: DateTime.parse("2022-05-08"),
            endDate: DateTime.parse("2022-05-15"),
          ),
        ],
      );
      expect(newPillSheetNotificationBaseDateFor(lastPillSheet: lastPillSheet), DateTime(2022, 6, 5, 23, 59, 59));
    });
  });

  group("#reminderDayOffsetsFor", () {
    void mockToday(String date) {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse(date));
    }

    RestDuration restDuration({required String beginDate, String? endDate}) {
      return RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse(beginDate),
        createdDate: DateTime.parse(beginDate),
        endDate: endDate == null ? null : DateTime.parse(endDate),
      );
    }

    group("服用再開予定日の服用お休みが無い場合", () {
      test("服用お休みが無い場合は今日から10日分", () {
        mockToday("2022-05-10");

        expect(reminderDayOffsetsFor(restDurations: []), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });

      test("endDateがnullの服用お休みの場合は今日から10日分", () {
        mockToday("2022-05-10");

        expect(reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-08")]), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });

      test("endDateが昨日の終了済みの服用お休みの場合は今日から10日分", () {
        mockToday("2022-05-10");

        expect(reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-05", endDate: "2022-05-09")]), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });

      test("境界値テスト：endDateが今日の服用お休みは服用再開済みなので今日から10日分", () {
        mockToday("2022-05-10");

        expect(reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-05", endDate: "2022-05-10")]), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
    });

    group("服用再開予定日(endDateが今日より後)の服用お休み中の場合", () {
      test("服用再開予定日が明日の場合は今日を飛ばして明日から10日分", () {
        mockToday("2022-05-10");

        expect(
          reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-08", endDate: "2022-05-11")]),
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        );
      });

      test("服用再開予定日が3日後の場合は3日後から10日分", () {
        mockToday("2022-05-10");

        expect(
          reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-08", endDate: "2022-05-13")]),
          [3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        );
      });

      test("境界値テスト：服用再開予定日が10日後でも予定日から10日分を登録する", () {
        mockToday("2022-05-10");

        expect(
          reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-08", endDate: "2022-05-20")]),
          [10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
        );
      });

      test("服用再開予定日が365日後でも予定日から10日分を登録する", () {
        mockToday("2022-05-10");

        final actual = reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-08", endDate: "2023-05-10")]);
        expect(actual.length, 10);
        expect(actual.first, 365);
        expect(actual.last, 374);
      });

      test("月をまたぐ場合も日数を数える", () {
        mockToday("2022-05-30");

        expect(
          reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-28", endDate: "2022-06-02")]),
          [3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        );
      });

      test("今日と服用再開予定日に時刻があっても日付で数える", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime(2022, 5, 10, 23, 59, 59));

        expect(
          reminderDayOffsetsFor(
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime(2022, 5, 8, 12, 0, 0),
                createdDate: DateTime(2022, 5, 8),
                endDate: DateTime(2022, 5, 11, 8, 0, 0),
              ),
            ],
          ),
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        );
      });

      test("複数の服用お休みがある場合は最後の服用お休みの服用再開予定日を使う", () {
        mockToday("2022-05-10");

        expect(
          reminderDayOffsetsFor(
            restDurations: [
              restDuration(beginDate: "2022-05-01", endDate: "2022-05-03"),
              restDuration(beginDate: "2022-05-08", endDate: "2022-05-12"),
            ],
          ),
          [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        );
      });
    });

    group("服用再開予定日の服用お休みが開始前の場合", () {
      test("明日開始で服用再開予定日が3日後の場合は、今日の分は登録して、明日と明後日を飛ばす", () {
        mockToday("2022-05-10");

        // 今日(0)は服用お休み前。明日(1)・明後日(2)がお休みで、3日後(3)に再開する
        expect(
          reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-11", endDate: "2022-05-13")]),
          [0, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        );
      });

      test("境界値テスト：明後日開始の場合は今日と明日の分を登録する", () {
        mockToday("2022-05-10");

        expect(
          reminderDayOffsetsFor(restDurations: [restDuration(beginDate: "2022-05-12", endDate: "2022-05-14")]),
          [0, 1, 4, 5, 6, 7, 8, 9, 10, 11],
        );
      });
    });
  });
}
