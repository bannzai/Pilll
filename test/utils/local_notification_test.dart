import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

import '../helper/mock.mocks.dart';

void main() {
  group("#restDaysUntilPlannedResumeFor", () {
    test("服用お休み中でない場合は0を返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      expect(restDaysUntilPlannedResumeFor(activeRestDuration: null), 0);
    });

    test("服用再開予定日（endDate）がない服用お休み中の場合は0を返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-08"),
        createdDate: DateTime.parse("2022-05-08"),
      );
      expect(
          restDaysUntilPlannedResumeFor(activeRestDuration: restDuration), 0);
    });

    test("服用再開予定日が明日の場合は1を返す。今日のリマインドだけを飛ばす", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-08"),
        createdDate: DateTime.parse("2022-05-08"),
        endDate: DateTime.parse("2022-05-11"),
      );
      expect(
          restDaysUntilPlannedResumeFor(activeRestDuration: restDuration), 1);
    });

    test("服用再開予定日が3日後の場合は3を返す。今日から2日後までのリマインドを飛ばし、3日後から登録する", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-08"),
        createdDate: DateTime.parse("2022-05-08"),
        endDate: DateTime.parse("2022-05-13"),
      );
      expect(
          restDaysUntilPlannedResumeFor(activeRestDuration: restDuration), 3);
    });

    test("月をまたぐ場合も日数を数える", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-30"));

      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-28"),
        createdDate: DateTime.parse("2022-05-28"),
        endDate: DateTime.parse("2022-06-02"),
      );
      expect(
          restDaysUntilPlannedResumeFor(activeRestDuration: restDuration), 3);
    });

    test("今日と現在時刻・予定日の時刻が異なっても日付で数える", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now())
          .thenReturn(DateTime(2022, 5, 10, 23, 59, 59));

      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-08"),
        createdDate: DateTime.parse("2022-05-08"),
        endDate: DateTime(2022, 5, 11, 8, 0, 0),
      );
      expect(
          restDaysUntilPlannedResumeFor(activeRestDuration: restDuration), 1);
    });
  });
}
