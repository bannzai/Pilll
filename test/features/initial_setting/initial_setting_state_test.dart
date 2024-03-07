import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group("#InitialSettingState.buildPillSheet", () {
    test("it is builded pillSheet.gropuIndex == todayPillNumber.pageIndex ", () {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("sheet_id");
      firestoreIDGenerator = mockIDGenerator;

      final pillSheet = InitialSettingState.buildPillSheet(
        pageIndex: 0,
        todayPillNumber: const InitialSettingTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 1),
        pillSheetTypeInfos: [PillSheetType.pillsheet_21],
      );

      final expected = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: DateTime.parse("2020-11-23"),
        lastTakenDate: null,
        createdAt: now(),
      );

      expect(expected, pillSheet);
    });
    test("it is builded pillSheet.gropuIndex > todayPillNumber.pageIndex ", () {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("sheet_id2");
      firestoreIDGenerator = mockIDGenerator;

      final pillSheet = InitialSettingState.buildPillSheet(
        pageIndex: 1,
        todayPillNumber: const InitialSettingTodayPillNumber(pageIndex: 0, pillNumberInPillSheet: 1),
        pillSheetTypeInfos: [
          PillSheetType.pillsheet_21.typeInfo,
          PillSheetType.pillsheet_24_0.typeInfo,
        ],
      );

      final expected = PillSheet(
        id: "sheet_id2",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
        beginingDate: DateTime.parse("2020-12-21"),
        lastTakenDate: null,
        createdAt: now(),
      );

      expect(expected, pillSheet);
    });
    test("it is builded pillSheet.gropuIndex < todayPillNumber.pageIndex ", () {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-11-23");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);

      var idGeneratorCallCount = 0;
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenAnswer((_) => ["sheet_id", "sheet_id2"][idGeneratorCallCount++]);
      firestoreIDGenerator = mockIDGenerator;

      final pillSheet = InitialSettingState.buildPillSheet(
        pageIndex: 0,
        todayPillNumber: const InitialSettingTodayPillNumber(pageIndex: 1, pillNumberInPillSheet: 1),
        pillSheetTypeInfos: [
          PillSheetType.pillsheet_21.typeInfo,
          PillSheetType.pillsheet_24_0.typeInfo,
        ],
      );

      final expected = PillSheet(
        id: "sheet_id",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: DateTime.parse("2020-10-26"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: now(),
      );

      expect(expected, pillSheet);
    });
  });
}
