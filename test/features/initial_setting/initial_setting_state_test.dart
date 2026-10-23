import 'package:flutter/services.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/features/initial_setting/initial_setting_state.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
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

  // ヤーズフレックス向けの導線の状態 (28錠 × 5枚、今日の番号・休薬のピル・休薬の日数・開始番号を指定) を返す
  InitialSettingState yazFlexState({
    required InitialSettingTodayPillNumber? todayPillNumber,
    InitialSettingTodayPillNumber? yazFlexLastTakenPillNumberBeforeRest,
    int yazFlexRestDurationDays = 4,
    int yazFlexBeginPillNumber = 1,
    bool yazFlexHasNotRestedYet = false,
    bool yazFlexIsResting = false,
  }) {
    return InitialSettingState(
      reminderTimes: [],
      isYazFlex: true,
      pillSheetTypes: const [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0
      ],
      todayPillNumber: todayPillNumber,
      yazFlexLastTakenPillNumberBeforeRest:
          yazFlexLastTakenPillNumberBeforeRest,
      yazFlexRestDurationDays: yazFlexRestDurationDays,
      yazFlexBeginPillNumber: yazFlexBeginPillNumber,
      yazFlexHasNotRestedYet: yazFlexHasNotRestedYet,
      yazFlexIsResting: yazFlexIsResting,
    );
  }

  group("#yazFlexLastRestDurationEndDate / #yazFlexLastRestDurationBeginDate",
      () {
    test("今日の番号か休薬のピルが未選択の場合はnull", () {
      expect(
        yazFlexState(todayPillNumber: null).yazFlexLastRestDurationEndDate,
        isNull,
      );
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
        ).yazFlexLastRestDurationBeginDate,
        isNull,
      );
    });
    test("今日が2枚目の2番で1枚目の16番の後に休薬した場合、再開日は13日前で開始日はその4日前", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      final state = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 2),
        yazFlexLastTakenPillNumberBeforeRest:
            const InitialSettingTodayPillNumber(
                pageIndex: 0, pillNumberInPillSheet: 16),
      );
      expect(
          state.yazFlexLastRestDurationEndDate, DateTime.parse("2022-02-17"));
      expect(
          state.yazFlexLastRestDurationBeginDate, DateTime.parse("2022-02-13"));
    });
    test("うるう年の2月をまたぐ場合 (2020-03-01 が今日で1枚目の2番、1番の後に休薬) は再開日が 2020-02-29", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-03-01"));

      // 今日は1枚目の3番、再開した2番はその前日の2020-02-29
      final state = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 3),
        yazFlexLastTakenPillNumberBeforeRest:
            const InitialSettingTodayPillNumber(
                pageIndex: 0, pillNumberInPillSheet: 1),
      );
      expect(
          state.yazFlexLastRestDurationEndDate, DateTime.parse("2020-02-29"));
      expect(
          state.yazFlexLastRestDurationBeginDate, DateTime.parse("2020-02-25"));
    });
    test("年をまたぐ場合 (2021-01-02 が今日で1枚目の6番、1番の後に休薬) は再開日が 2020-12-29", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-02"));

      final state = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 6),
        yazFlexLastTakenPillNumberBeforeRest:
            const InitialSettingTodayPillNumber(
                pageIndex: 0, pillNumberInPillSheet: 1),
      );
      expect(
          state.yazFlexLastRestDurationEndDate, DateTime.parse("2020-12-29"));
      expect(
          state.yazFlexLastRestDurationBeginDate, DateTime.parse("2020-12-25"));
    });
  });

  group("#yazFlexLastTakenPillPositionBeforeRest", () {
    test("休薬中でなければタップしたピルの位置、未選択なら null", () {
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
          yazFlexLastTakenPillNumberBeforeRest:
              const InitialSettingTodayPillNumber(
                  pageIndex: 0, pillNumberInPillSheet: 16),
        ).yazFlexLastTakenPillPositionBeforeRest,
        (pageIndex: 0, pillNumberInPillSheet: 16),
      );
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
        ).yazFlexLastTakenPillPositionBeforeRest,
        isNull,
      );
    });
    test("休薬中は今日のピルの1つ前の位置 (ピルシートの境界では前のシートの最後のピル)", () {
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 1),
          yazFlexIsResting: true,
        ).yazFlexLastTakenPillPositionBeforeRest,
        (pageIndex: 0, pillNumberInPillSheet: 28),
      );
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 0, pillNumberInPillSheet: 1),
          yazFlexIsResting: true,
        ).yazFlexLastTakenPillPositionBeforeRest,
        isNull,
      );
    });
  });

  group("#yazFlexLastRestDurationBeginDate (休薬中)", () {
    test("休薬して今日で4日目なら開始日は3日前で再開日は無し。年をまたぐ場合も同じ", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-02"));

      final state = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 10),
        yazFlexIsResting: true,
      );
      expect(
          state.yazFlexLastRestDurationBeginDate, DateTime.parse("2020-12-30"));
      expect(state.yazFlexLastRestDurationEndDate, isNull);
    });
    test("休薬中で今日の番号が未選択なら null", () {
      expect(
        yazFlexState(todayPillNumber: null, yazFlexIsResting: true)
            .yazFlexLastRestDurationBeginDate,
        isNull,
      );
    });
  });

  group("#yazFlexCanSelectAsLastTakenPillBeforeRest", () {
    test("今日のピルより前のピルだけ選べる (ピルシートの境界を含む)", () {
      final state = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 1),
      );
      expect(
        state.yazFlexCanSelectAsLastTakenPillBeforeRest(
            pageIndex: 0, pillNumberInPillSheet: 28),
        true,
      );
      expect(
        state.yazFlexCanSelectAsLastTakenPillBeforeRest(
            pageIndex: 1, pillNumberInPillSheet: 1),
        false,
      );
      expect(
        state.yazFlexCanSelectAsLastTakenPillBeforeRest(
            pageIndex: 1, pillNumberInPillSheet: 2),
        false,
      );
    });
    test("今日の番号が未選択なら選べない", () {
      expect(
        yazFlexState(todayPillNumber: null)
            .yazFlexCanSelectAsLastTakenPillBeforeRest(
                pageIndex: 0, pillNumberInPillSheet: 1),
        false,
      );
    });
  });

  group("#yazFlexResumedPillPosition", () {
    test("休薬のピルが未選択の場合はnull", () {
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
        ).yazFlexResumedPillPosition,
        isNull,
      );
    });
    test("1枚目の16番の後に休薬した場合は1枚目の17番", () {
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
          yazFlexLastTakenPillNumberBeforeRest:
              const InitialSettingTodayPillNumber(
                  pageIndex: 0, pillNumberInPillSheet: 16),
        ).yazFlexResumedPillPosition,
        (pageIndex: 0, pillNumberInPillSheet: 17),
      );
    });
    test("1枚目の28番の後に休薬した場合は2枚目の1番 (ピルシートの境界)", () {
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 5),
          yazFlexLastTakenPillNumberBeforeRest:
              const InitialSettingTodayPillNumber(
                  pageIndex: 0, pillNumberInPillSheet: 28),
        ).yazFlexResumedPillPosition,
        (pageIndex: 1, pillNumberInPillSheet: 1),
      );
    });
    test("休薬の入力をスキップした場合はnull", () {
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
          yazFlexLastTakenPillNumberBeforeRest:
              const InitialSettingTodayPillNumber(
                  pageIndex: 0, pillNumberInPillSheet: 16),
          yazFlexHasNotRestedYet: true,
        ).yazFlexResumedPillPosition,
        isNull,
      );
    });
  });

  group("#buildPillSheetGroup", () {
    test("今日の番号が未入力の場合はnull", () {
      expect(yazFlexState(todayPillNumber: null).buildPillSheetGroup(), isNull);
    });
    test("ヤーズフレックス向けの導線では開始番号を反映した服用日数の表示で、今日飲むピルの番号が休薬明けから数えた日数になる", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("id");
      firestoreIDGenerator = mockIDGenerator;

      // 今日は1枚目の10番。1枚目の1番は休薬明けから4日目だったので、今日は13日目
      final pillSheetGroup = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 10),
        yazFlexBeginPillNumber: 4,
        yazFlexHasNotRestedYet: true,
      ).buildPillSheetGroup()!;
      expect(pillSheetGroup.pillSheetAppearanceMode,
          PillSheetAppearanceMode.cyclicSequential);
      expect(pillSheetGroup.displayNumberSetting?.beginPillNumber, 4);
      expect(
        pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 1),
        "4",
      );
      expect(
        pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 10),
        "13",
      );
      expect(pillSheetGroup.sequentialTodayPillNumber, 13);
      expect(pillSheetGroup.pillSheets[0].lastTakenOrZeroPillNumber, 9);
    });
    test("休薬のピルを選ぶと、プレビューの次のピルから1に戻る", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("id");
      firestoreIDGenerator = mockIDGenerator;

      final pillSheetGroup = yazFlexState(
        todayPillNumber: const InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 20),
        yazFlexLastTakenPillNumberBeforeRest:
            const InitialSettingTodayPillNumber(
                pageIndex: 0, pillNumberInPillSheet: 16),
      ).buildPillSheetGroup()!;
      expect(
        pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 16),
        "16",
      );
      expect(
        pillSheetGroup.displayPillNumberWithoutDate(
            pageIndex: 0, pillNumberInPillSheet: 17),
        "1",
      );
      expect(pillSheetGroup.sequentialTodayPillNumber, 4);
    });
    test("ヤーズフレックス向けの導線でない場合は日付の表示で、開始番号の設定が無い", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("id");
      firestoreIDGenerator = mockIDGenerator;

      const state = InitialSettingState(
        reminderTimes: [],
        pillSheetTypes: [PillSheetType.pillsheet_21],
        todayPillNumber: InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 3),
      );
      final pillSheetGroup = state.buildPillSheetGroup()!;
      expect(
          pillSheetGroup.pillSheetAppearanceMode, PillSheetAppearanceMode.date);
      expect(pillSheetGroup.displayNumberSetting, isNull);
      expect(pillSheetGroup.pillSheets.length, 1);
    });
  });

  group("#buildYazFlexRestDurationInPillSheetGroup", () {
    test("ヤーズフレックス向けの導線でない場合は、休薬のピルがあってもnull", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      const state = InitialSettingState(
        reminderTimes: [],
        isYazFlex: false,
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        todayPillNumber: InitialSettingTodayPillNumber(
            pageIndex: 1, pillNumberInPillSheet: 2),
        yazFlexLastTakenPillNumberBeforeRest: InitialSettingTodayPillNumber(
            pageIndex: 0, pillNumberInPillSheet: 16),
      );
      expect(state.buildYazFlexRestDurationInPillSheetGroup(), isNull);
    });
    test("休薬の入力をスキップした・休薬のピルが未選択の場合はnull", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));

      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
          yazFlexLastTakenPillNumberBeforeRest:
              const InitialSettingTodayPillNumber(
                  pageIndex: 0, pillNumberInPillSheet: 16),
          yazFlexHasNotRestedYet: true,
        ).buildYazFlexRestDurationInPillSheetGroup(),
        isNull,
      );
      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
        ).buildYazFlexRestDurationInPillSheetGroup(),
        isNull,
      );
    });
    test("休薬のピルと日数から、開始日と再開日のRestDurationを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-02"));
      final mockIDGenerator = MockFirestoreIDGenerator();
      when(mockIDGenerator.call()).thenReturn("rest_duration_id");
      firestoreIDGenerator = mockIDGenerator;

      expect(
        yazFlexState(
          todayPillNumber: const InitialSettingTodayPillNumber(
              pageIndex: 1, pillNumberInPillSheet: 2),
          yazFlexLastTakenPillNumberBeforeRest:
              const InitialSettingTodayPillNumber(
                  pageIndex: 0, pillNumberInPillSheet: 16),
        ).buildYazFlexRestDurationInPillSheetGroup(),
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
