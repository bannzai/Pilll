import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/delay.dart';
import '../../helper/mock.mocks.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    analytics = MockAnalytics();
  });
  group("#markFor", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
      );
      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());

      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillNumber, pillSheetGroup.pillSheets.first.lastTakenPillNumber);
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isTrue);
      expect(pillMarkFor(pillNumberInPillSheet: 1, pillSheet: pillSheetEntity), PillMarkType.done);
      expect(pillMarkFor(pillNumberInPillSheet: 2, pillSheet: pillSheetEntity), PillMarkType.done);
      expect(pillMarkFor(pillNumberInPillSheet: 3, pillSheet: pillSheetEntity), PillMarkType.done);
      expect(pillMarkFor(pillNumberInPillSheet: 4, pillSheet: pillSheetEntity), PillMarkType.normal);
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
      );
      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());

      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isFalse);
      expect(pillMarkFor(pillNumberInPillSheet: 1, pillSheet: pillSheetEntity), PillMarkType.done);
      expect(pillMarkFor(pillNumberInPillSheet: 2, pillSheet: pillSheetEntity), PillMarkType.done);
      expect(pillMarkFor(pillNumberInPillSheet: 3, pillSheet: pillSheetEntity), PillMarkType.normal);
      expect(pillMarkFor(pillNumberInPillSheet: 4, pillSheet: pillSheetEntity), PillMarkType.normal);
    });
  });
  group("#shouldPillMarkAnimation", () {
    test("it is alredy taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-23"),
      );
      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());
      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isTrue);
      for (int i = 1; i <= pillSheetEntity.typeInfo.totalCount; i++) {
        expect(
            shouldPillMarkAnimation(
              pillNumberInPillSheet: i,
              pillSheet: pillSheetEntity,
              pillSheetGroup: pillSheetGroup,
            ),
            isFalse);
      }
    });
    test("it is not taken all", () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final pillSheetEntity = PillSheet.create(
        PillSheetType.pillsheet_21,
        beginDate: DateTime.parse("2020-11-21"),
        lastTakenDate: DateTime.parse("2020-11-22"),
      );
      final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheetEntity], createdAt: now());

      await waitForResetStoreState();
      expect(pillSheetGroup.pillSheets.first.todayPillIsAlreadyTaken, isFalse);
      expect(
          shouldPillMarkAnimation(
            pillNumberInPillSheet: 3,
            pillSheet: pillSheetEntity,
            pillSheetGroup: pillSheetGroup,
          ),
          isTrue);
    });
  });
}
