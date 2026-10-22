import 'package:flutter/services.dart';
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
  const MethodChannel timezoneChannel = MethodChannel('flutter_timezone');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timezoneChannel, (
      MethodCall methodCall,
    ) async {
      return 'Asia/Tokyo';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(timezoneChannel, null);
  });
  group("#InitialSettingState.buildPillSheet", () {
    test(
      "it is builded pillSheet.gropuIndex == todayPillNumber.pageIndex ",
      () {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime.parse("2020-11-23");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(mockToday);

        final mockIDGenerator = MockFirestoreIDGenerator();
        when(mockIDGenerator.call()).thenReturn("sheet_id");
        firestoreIDGenerator = mockIDGenerator;

        final pillSheet = InitialSettingState.buildPillSheet(
          pageIndex: 0,
          todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0,
            pillNumberInPillSheet: 1,
          ),
          pillSheetTypes: [PillSheetType.pillsheet_21],
          pillTakenCount: 1,
          restDuration: null,
        );

        final expected = PillSheet.v1(
          id: firestoreIDGenerator(),
          typeInfo: PillSheetType.pillsheet_21.typeInfo,
          beginDate: DateTime.parse("2020-11-23"),
          lastTakenDate: null,
          createdAt: now(),
        );

        expect(expected, pillSheet);
      },
    );
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
        todayPillNumber: const InitialSettingTodayPillNumber(
          pageIndex: 0,
          pillNumberInPillSheet: 1,
        ),
        pillSheetTypes: [
          PillSheetType.pillsheet_21,
          PillSheetType.pillsheet_24_0,
        ],
        pillTakenCount: 1,
        restDuration: null,
      );

      final expected = PillSheet.v1(
        id: "sheet_id2",
        groupIndex: 1,
        typeInfo: PillSheetType.pillsheet_24_0.typeInfo,
        beginDate: DateTime.parse("2020-12-21"),
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
      when(
        mockIDGenerator.call(),
      ).thenAnswer((_) => ["sheet_id", "sheet_id2"][idGeneratorCallCount++]);
      firestoreIDGenerator = mockIDGenerator;

      final pillSheet = InitialSettingState.buildPillSheet(
        pageIndex: 0,
        todayPillNumber: const InitialSettingTodayPillNumber(
          pageIndex: 1,
          pillNumberInPillSheet: 1,
        ),
        pillSheetTypes: [
          PillSheetType.pillsheet_21,
          PillSheetType.pillsheet_24_0,
        ],
        pillTakenCount: 1,
        restDuration: null,
      );

      final expected = PillSheet.v1(
        id: "sheet_id",
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginDate: DateTime.parse("2020-10-26"),
        lastTakenDate: DateTime.parse("2020-11-22"),
        createdAt: now(),
      );

      expect(expected, pillSheet);
    });
  });

  group("#yazFlexDefaultBeginPillNumber", () {
    test("今日の番号と再開日が未入力の場合は1", () {
      const state = InitialSettingState(reminderTimes: []);
      expect(state.yazFlexDefaultBeginPillNumber, 1);
    });
    test("再開日が1枚目の1番の日より前の場合は、再開日から1枚目の1番の日までの日数 + 1", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      // 今日が1枚目の1番なので1枚目の1番の日は今日。再開日は月をまたいだ2022-02-27
      final state = InitialSettingState(
        reminderTimes: [],
        isYazFlex: true,
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 1),
        yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-23"),
        yazFlexLastRestDurationEndDate: DateTime.parse("2022-02-27"),
      );
      expect(state.yazFlexDefaultBeginPillNumber, 4);
    });
    test("再開日が1枚目の1番の日より後の場合は1", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final state = InitialSettingState(
        reminderTimes: [],
        isYazFlex: true,
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 2),
        yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-13"),
        yazFlexLastRestDurationEndDate: DateTime.parse("2022-02-17"),
      );
      expect(state.yazFlexDefaultBeginPillNumber, 1);
    });
  });

  group("#buildYazFlexRestDurationInPillSheetGroup", () {
    test("ヤーズフレックス向けの導線でない場合は、休薬の日付があってもnull", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final state = InitialSettingState(
        reminderTimes: [],
        isYazFlex: false,
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 2),
        yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-13"),
        yazFlexLastRestDurationEndDate: DateTime.parse("2022-02-17"),
      );
      expect(state.buildYazFlexRestDurationInPillSheetGroup(), isNull);
    });
    test("休薬はまだしていない場合はnull", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      const state = InitialSettingState(
        reminderTimes: [],
        isYazFlex: true,
        yazFlexHasNotRestedYet: true,
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        todayPillNumber: InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 2),
      );
      expect(state.buildYazFlexRestDurationInPillSheetGroup(), isNull);
    });
    test("再開日が1枚目の1番の日より後の場合は、入力した期間のRestDurationを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;

      final state = InitialSettingState(
        reminderTimes: [],
        isYazFlex: true,
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 2),
        yazFlexLastRestDurationBeginDate: DateTime.parse("2022-02-13"),
        yazFlexLastRestDurationEndDate: DateTime.parse("2022-02-17"),
      );
      expect(
        state.buildYazFlexRestDurationInPillSheetGroup(),
        RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2022-02-13"),
          endDate: DateTime.parse("2022-02-17"),
          createdDate: DateTime.parse("2022-03-02"),
        ),
      );
    });
  });
}
