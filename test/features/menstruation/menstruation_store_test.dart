import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/features/menstruation/components/menstruation_card_list.dart';
import 'package:pilll/features/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("#cardState", () {
    test(
      "if latestMenstruation is into mockToday, when return card state of begining about menstruation ",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [], pillSheets: [], createdAt: now());
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final menstruations = [
          Menstruation(
            beginDate: DateTime(2021, 04, 28),
            endDate: DateTime(2021, 04, 30),
            createdAt: DateTime(2021, 04, 28),
          ),
          Menstruation(
            beginDate: DateTime(2021, 03, 28),
            endDate: DateTime(2021, 03, 30),
            createdAt: DateTime(2021, 03, 28),
          ),
        ];
        final calendarScheduledMenstruationBandModels = scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, menstruations, 12)
            .map((e) => CalendarScheduledMenstruationBandModel(e.begin, e.end))
            .toList();

        final actual = cardState(pillSheetGroup, menstruations.first, setting, calendarScheduledMenstruationBandModels);

        expect(actual, MenstruationCardState(title: "生理開始日", scheduleDate: DateTime(2021, 04, 28), countdownString: "2日目"));
      },
    );
    test(
      "if latestMenstruation is out of duration and latest pill sheet is null",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(pillSheetIDs: [], pillSheets: [], createdAt: now());
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final menstruations = [
          Menstruation(
            beginDate: DateTime(2021, 03, 28),
            endDate: DateTime(2021, 03, 30),
            createdAt: DateTime(2021, 03, 28),
          ),
        ];
        final calendarScheduledMenstruationBandModels = scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, menstruations, 12)
            .map((e) => CalendarScheduledMenstruationBandModel(e.begin, e.end))
            .toList();

        final actual = cardState(pillSheetGroup, menstruations.first, setting, calendarScheduledMenstruationBandModels);
        expect(actual, null);
      },
    );

    test(
      "if latest pillsheet.beginingDate + totalCount < mockToday, when return schedueld card state",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [
            PillSheet(
              id: firestoreIDGenerator(),
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginingDate: DateTime(2021, 04, 22),
              createdAt: now(),
              pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, toDate: null),
            ),
          ],
          createdAt: now(),
        );
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final calendarScheduledMenstruationBandModels = scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, [], 12)
            .map((e) => CalendarScheduledMenstruationBandModel(e.begin, e.end))
            .toList();

        final actual = cardState(pillSheetGroup, null, setting, calendarScheduledMenstruationBandModels);
        expect(actual, MenstruationCardState(title: "生理予定日", scheduleDate: DateTime(2021, 05, 13), countdownString: "あと14日"));
      },
    );
    test(
      "if todayPillNumber > setting.pillNumberForFromMenstruation, when return card state of into duration for schedueld menstruation",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final mockToday = DateTime(2021, 04, 29);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [
            PillSheet(
              id: firestoreIDGenerator(),
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginingDate: DateTime(2021, 04, 07),
              createdAt: now(),
              pills: Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, toDate: null),
            ),
          ],
          createdAt: now(),
        );
        const setting = Setting(
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          reminderTimes: [],
          timezoneDatabaseName: null,
          isOnReminder: true,
        );
        final menstruations = [
          Menstruation(
            beginDate: DateTime(2021, 03, 28),
            endDate: DateTime(2021, 03, 30),
            createdAt: DateTime(2021, 03, 28),
          ),
        ];
        final calendarScheduledMenstruationBandModels = scheduledOrInTheMiddleMenstruationDateRanges(pillSheetGroup, setting, menstruations, 12)
            .map((e) => CalendarScheduledMenstruationBandModel(e.begin, e.end))
            .toList();
        final actual = cardState(pillSheetGroup, menstruations.first, setting, calendarScheduledMenstruationBandModels);
        expect(
          actual,
          MenstruationCardState(title: "生理予定日", scheduleDate: DateTime(2021, 04, 28), countdownString: "生理予定：2日目"),
        );
      },
    );
  });
}
