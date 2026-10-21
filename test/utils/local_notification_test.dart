import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

import '../helper/mock.mocks.dart';

void main() {
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
