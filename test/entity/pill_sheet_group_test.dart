import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
  });

  group("#activePillSheet", () {
    group("ピルシートが空の場合", () {
      test("nullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [],
          pillSheets: [],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, isNull);
      });
    });

    group("ピルシートが1つの場合", () {
      test("今日がピルシートの期間内の場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet);
      });

      test("今日がピルシート開始日の場合はそのピルシートを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet);
      });

      test("今日がピルシート終了日の場合はそのピルシートを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21は21錠+休薬7日タイプでtotalCount=28日周期
        // 2020-09-01開始で2020-09-28（28日目）が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet);
      });

      test("今日がピルシート開始日前日の場合はnullを返す（境界値・期間外）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, isNull);
      });

      test("今日がピルシート終了日の翌日の場合はnullを返す（境界値・期間外）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21は21錠+休薬7日タイプでtotalCount=28日周期
        // 2020-09-01開始で2020-09-28が終了日。2020-09-29は期間外
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, isNull);
      });

      group("服用お休み期間がある場合", () {
        test("服用お休みにより終了日がずれた場合、今日がその終了日でもピルシートを返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          // pillsheet_21は21錠+休薬7日タイプでtotalCount=28日周期
          // 2020-09-01開始で本来の終了日は2020-09-28
          // 2020-09-10から2020-09-12まで休薬（2日間）
          // 終了日は2020-09-28 + 2日 = 2020-09-30が終了日
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          expect(pillSheetGroup.activePillSheet, pillSheet);
        });

        test("服用お休みがまだ終了していない場合でもアクティブなピルシートを返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          // 休薬中（endDateがnull）
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: null,
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          expect(pillSheetGroup.activePillSheet, pillSheet);
        });
      });
    });

    group("ピルシートが複数ある場合", () {
      test("今日が1枚目の期間内の場合は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        // pillsheet_21はtotalCount=28日周期
        // 1枚目: 2020-09-01~2020-09-28
        // 2枚目: 2020-09-29~
        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet1);
      });

      test("今日が1枚目の終了日の場合は1枚目を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21はtotalCount=28日周期
        // 1枚目: 2020-09-01開始で2020-09-28が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet1);
      });

      test("今日が2枚目の開始日の場合は2枚目を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 2枚目: 2020-09-29開始
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 2020-09-29は2枚目の開始日であり、1枚目の終了日(2020-09-28)を過ぎている
        // よって2枚目のみがactiveとなる
        expect(pillSheetGroup.activePillSheet, pillSheet2);
      });

      test("今日が2枚目の期間内の場合は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        // pillsheet_21はtotalCount=28日周期
        // 1枚目: 2020-09-01~2020-09-28
        // 2枚目: 2020-09-29~2020-10-26
        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet2);
      });

      test("今日が3枚目の終了日の場合は3枚目を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21はtotalCount=28日周期
        // 1枚目: 2020-09-01~2020-09-28
        // 2枚目: 2020-09-29~2020-10-26
        // 3枚目: 2020-10-27~2020-11-23
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-23"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet3);
      });

      test("今日が全てのピルシート期間外の場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 3枚目の終了日(2020-11-23)の翌日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-24"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, isNull);
      });
    });

    group("PillSheetTypeによる違い", () {
      test("28錠タイプ: 今日がピルシート終了日（28日目）の場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 28錠タイプ: 2020-09-01開始で2020-09-28が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet);
      });

      test("24錠タイプ: 今日がピルシート終了日（24日目）の場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 24錠タイプ: 2020-09-01開始で2020-09-24が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheet, pillSheet);
      });
    });
  });

  group("#activePillSheetWhen", () {
    group("ピルシートが空の場合", () {
      test("nullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [],
          pillSheets: [],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-14")), isNull);
      });
    });

    group("ピルシートが1枚の場合", () {
      // pillsheet_21はtotalCount=28日周期
      // 期間: 2020-09-01~2020-09-28
      test("開始日より前の日付ではnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-08-31")), isNull);
      });

      test("開始日ちょうどの日付ではピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-01")), pillSheet);
      });

      test("期間内の日付ではピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-14")), pillSheet);
      });

      test("終了日ちょうどの日付ではピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        // pillsheet_21はtotalCount=28
        // 開始日: 2020-09-01から28日間 → 終了日: 2020-09-28
        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-28")), pillSheet);
      });

      test("終了日より後の日付ではnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-29")), isNull);
      });
    });

    group("ピルシートが複数枚の場合", () {
      // pillsheet_21はtotalCount=28日周期
      // 1枚目: 2020-09-01~2020-09-28
      // 2枚目: 2020-09-29~2020-10-26
      test("1枚目の期間内では1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-10")), pillSheet1);
      });

      test("1枚目の最終日では1枚目を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-28")), pillSheet1);
      });

      test("2枚目の開始日では2枚目を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-29")), pillSheet2);
      });

      test("2枚目の期間内では2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-10")), pillSheet2);
      });

      test("2枚目の最終日では2枚目を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-26")), pillSheet2);
      });

      test("全シートの期間外ではnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 2枚目終了後
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-27")), isNull);
        // 1枚目開始前
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-08-31")), isNull);
      });
    });

    group("休薬期間（RestDuration）がある場合", () {
      test("休薬期間により終了日が延長されてアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間を考慮しない場合、2020-09-28が終了日
        // 3日間の休薬期間がある場合、2020-10-01が終了日になる
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          // 3日間の休薬期間: 2020-09-10~2020-09-12
          restDurations: [
            RestDuration(
              id: "rest_id",
              beginDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
              createdDate: DateTime.parse("2020-09-10"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: DateTime.parse("2020-09-01"),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 通常終了日より後でも休薬期間延長により期間内
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-30")), pillSheet);
      });

      test("休薬期間考慮後の終了日を超えた日付ではnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-02"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          // 3日間の休薬期間: 2020-09-10~2020-09-12
          restDurations: [
            RestDuration(
              id: "rest_id",
              beginDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
              createdDate: DateTime.parse("2020-09-10"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: DateTime.parse("2020-09-01"),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 休薬期間延長後の終了日（2020-10-01）を超えた日付
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-02")), isNull);
      });
    });

    group("3枚以上のピルシートがある場合", () {
      test("3枚目の期間内では3枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-10"));

        const sheetType = PillSheetType.pillsheet_21;
        // 1枚目: 2020-09-01~2020-09-28
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 2枚目: 2020-09-29~2020-10-26
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 3枚目: 2020-10-27~2020-11-23
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-11-10")), pillSheet3);
      });

      test("2枚目と3枚目の境界で正しいピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 2枚目の最終日
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-26")), pillSheet2);
        // 3枚目の開始日
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-27")), pillSheet3);
      });
    });
  });

  group("#lastTakenPillSheetOrFirstPillSheet", () {
    group("ピルシートが1枚の場合", () {
      test("服用履歴がない場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet);
      });

      test("服用履歴がある場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-10"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet);
      });
    });

    group("ピルシートが複数枚の場合", () {
      test("どのピルシートにも服用履歴がない場合は最初のピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet1);
      });

      test("1枚目のみに服用履歴がある場合は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-10"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet1);
      });

      test("1枚目と2枚目両方に服用履歴がある場合は最後に服用したピルシート（2枚目）を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-03"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet2);
      });

      test("3枚すべてに服用履歴がある場合は最後のピルシート（3枚目）を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: DateTime.parse("2020-11-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet3);
      });
    });

    group("境界値テスト", () {
      test("1枚目の最終日に服用済みで2枚目に服用履歴がない場合は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"), // 1枚目の最終日（28錠目）
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet1);
      });

      test("2枚目の初日のみに服用履歴がある場合は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-09-29"), // 2枚目の初日
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet2);
      });
    });

    group("PillSheetTypeによる違い", () {
      test("pillsheet_28_0（28錠すべて実薬）で複数枚の場合も正しく動作する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet2);
      });

      test("pillsheet_24_rest_4（24錠+休薬4日）で1枚目の休薬期間中でも正しく動作する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-27"));

        const sheetType = PillSheetType.pillsheet_24_rest_4;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"), // 24錠目まで服用（休薬期間開始）
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet1);
      });
    });
  });

  group("#lastTakenPillNumberWithoutDate", () {
    group("服用履歴がない場合", () {
      test("lastTakenDateがnullの場合はnullを返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, isNull);
      });

      test("複数ピルシートで全てのlastTakenDateがnullの場合はnullを返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, isNull);
      });
    });

    group("PillSheetAppearanceModeによる分岐", () {
      group("numberモードの場合", () {
        test("ピルシート内の番号を返す", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 2020-09-10は開始日2020-09-01から10日目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 10);
        });

        test("1番目のピルを服用した場合は1を返す（境界値）", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-01"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 1);
        });

        test("最後のピルを服用した場合はtotalCountを返す（境界値）", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // pillsheet_21はtotalCount=28
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });
      });

      group("dateモードの場合", () {
        test("ピルシート内の番号を返す（numberモードと同じ挙動）", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          );
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 10);
        });
      });

      group("sequentialモードの場合", () {
        test("連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 10);
        });
      });

      group("cyclicSequentialモードの場合", () {
        test("連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 10);
        });
      });
    });

    group("複数のピルシートがある場合", () {
      group("numberモードの場合", () {
        test("1枚目のみ服用がある場合、1枚目のピルシート内番号を返す", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-15"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 2020-09-15は1枚目の15番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 15);
        });

        test("2枚目のみ服用がある場合、2枚目のピルシート内番号を返す", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-05"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 2020-10-05は2枚目の7番目（2020-09-29から7日目）
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 7);
        });

        test("両方に服用がある場合、2枚目（後のピルシート）の番号を返す", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 逆順イテレートで2枚目が先に見つかるため、2枚目の12番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 12);
        });

        test("2枚目の1番目を服用した場合は1を返す（ピルシート境界値）", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-09-29"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 2枚目の1番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 1);
        });

        test("1枚目の最後を服用し2枚目は未服用の場合、1枚目の最終番号を返す（ピルシート境界値）", () {
          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 1枚目の28番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });
      });

      group("cyclicSequentialモードの場合", () {
        test("2枚目で服用した場合、1枚目からの通し番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

          const sheetType = PillSheetType.pillsheet_21;
          // 1枚目: 2020-09-01〜2020-09-28（28日間）
          // 2枚目: 2020-09-29〜2020-10-26
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-05"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // 2020-10-05は2枚目の7番目、1枚目28錠 + 7 = 35
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 35);
        });

        test("2枚目の1番目を服用した場合、1枚目のtotalCount+1を返す（ピルシート境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-09-29"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // 1枚目28錠 + 1 = 29
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 29);
        });

        test("1枚目の最後を服用し2枚目は未服用の場合、1枚目のtotalCountを返す（ピルシート境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // 1枚目の28番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });
      });

      group("sequentialモードの場合", () {
        test("2枚目で服用した場合、1枚目からの通し番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

          const sheetType = PillSheetType.pillsheet_21;
          // 1枚目: 2020-09-01〜2020-09-28（28日間）
          // 2枚目: 2020-09-29〜2020-10-26
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-05"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          // 2020-10-05は2枚目の7番目、1枚目28錠 + 7 = 35
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 35);
        });

        test("2枚目の1番目を服用した場合、1枚目のtotalCount+1を返す（ピルシート境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-09-29"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          // 1枚目28錠 + 1 = 29
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 29);
        });

        test("1枚目の最後を服用し2枚目は未服用の場合、1枚目のtotalCountを返す（ピルシート境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          // 1枚目の28番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });
      });
    });

    group("displayNumberSettingがある場合", () {
      group("cyclicSequentialモードの場合", () {
        test("beginPillNumberが設定されている場合、開始番号がbeginPillNumberになる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 5,
            ),
          );
          // 開始番号5で10日目なので 5 + (10-1) = 14
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 14);
        });

        test("endPillNumberが設定されていて超過した場合、1から始まる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-15"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 1,
              endPillNumber: 10,
            ),
          );
          // endPillNumber=10で15日目なので、11日目から1に戻る
          // 1〜10日目: 1〜10, 11〜15日目: 1〜5
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 5);
        });
      });
    });

    group("服用お休み期間がある場合", () {
      group("cyclicSequentialモードの場合", () {
        test("服用お休み期間終了後は1から番号が始まる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-15"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            // 2020-09-06から2020-09-10まで服用お休み（5日間）
            // endDateの2020-09-10で番号が1にリセット
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-06"),
                createdDate: DateTime.parse("2020-09-06"),
                endDate: DateTime.parse("2020-09-10"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // 2020-09-10で1にリセット、2020-09-15は2020-09-10から数えて6番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 6);
        });
      });
    });

    group("3枚のピルシートがある場合", () {
      test("3枚目で服用した場合、通し番号を返す（cyclicSequentialモード）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: DateTime.parse("2020-10-30"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 1枚目28錠 + 2枚目28錠 + 3枚目4番目 = 60
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 60);
      });

      test("2枚目の終了と3枚目の開始の境界値チェック（cyclicSequentialモード）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: DateTime.parse("2020-10-27"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 1枚目28錠 + 2枚目28錠 + 3枚目1番目 = 57
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 57);
      });

      test("2枚目の最後を服用し3枚目は未服用の場合（ピルシート境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 1枚目28錠 + 2枚目28錠 = 56
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 56);
      });
    });
  });

  group("#sequentialLastTakenPillNumber", () {
    group("activePillSheetがnullの場合（過去のピルシートグループ参照時など）", () {
      test("今日がピルシート期間外の場合は0を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // ピルシート終了日の翌日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.activePillSheet, isNull);
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });
    });

    group("lastTakenDateがnullの場合（まだ服用していない）", () {
      test("服用履歴がない場合は0を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });
    });

    group("PillSheetAppearanceModeによる分岐", () {
      group("numberモードの場合", () {
        test("lastTakenDateがあっても0を返す（連続番号表示モードではないため）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
        });
      });

      group("dateモードの場合", () {
        test("lastTakenDateがあっても0を返す（連続番号表示モードではないため）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
        });
      });

      group("sequentialモードの場合", () {
        test("lastTakenDateに対応する連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-05"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          // lastTakenDateは2020-09-05、beginingDateは2020-09-01なので5番目
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 5);
        });
      });

      group("cyclicSequentialモードの場合", () {
        test("lastTakenDateに対応する連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-05"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // lastTakenDateは2020-09-05、beginingDateは2020-09-01なので5番目
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 5);
        });

        test("1番目のピル（境界値）を服用した場合は1を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-01"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 1);
        });

        test("最後のピル（境界値）を服用した場合はtotalCountを返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // pillsheet_21はtotalCount=28
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 28);
        });
      });
    });

    group("複数のピルシートがある場合", () {
      test("2枚目のピルシートで服用した場合、1枚目からの通し番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        // 1枚目: 2020-09-01〜2020-09-28（28日間）
        // 2枚目: 2020-09-29〜2020-10-26
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 2020-10-05は2枚目の7番目（2020-09-29から7日目）
        // 通し番号では28 + 7 = 35番目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 35);
      });

      test("2枚目の最初のピル（境界値）を服用した場合、29番を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-09-29"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 1枚目28錠 + 2枚目1錠目 = 29番
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 29);
      });

      test("3枚目のピルシートで服用した場合の通し番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-10"));

        const sheetType = PillSheetType.pillsheet_21;
        // 1枚目: 2020-09-01〜2020-09-28
        // 2枚目: 2020-09-29〜2020-10-26
        // 3枚目: 2020-10-27〜2020-11-23
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: DateTime.parse("2020-11-10"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 2020-11-10は3枚目の15番目（2020-10-27から15日目）
        // 通し番号では28 + 28 + 15 = 71番目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 71);
      });
    });

    group("RestDurationがある場合", () {
      test("服用お休み期間があっても、lastTakenDateに対応する連続番号を正しく返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        // 2020-09-10〜2020-09-12が服用お休み期間（2日間）
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-30"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 2020-09-30は2020-09-01から30日目だが、休薬があるので日付がずれる
        // 服用お休み終了日(2020-09-12)で番号が1にリセットされる
        // 2020-09-12が1番、2020-09-13が2番、...、2020-09-30が19番
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 19);
      });

      test("服用お休み終了日に服用した場合は1を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-12"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 服用お休み終了日は番号が1にリセットされる
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 1);
      });

      test("服用お休み期間中（endDateがnull）でも、lastTakenDateに対応する番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: null,
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // lastTakenDateは2020-09-09で、beginingDateから9番目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 9);
      });
    });

    group("displayNumberSettingがある場合", () {
      test("beginPillNumberが設定されている場合、開始番号からカウントする", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 10,
            endPillNumber: null,
          ),
        );
        // beginPillNumber=10から始まるので、5番目のピルは10+4=14番
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 14);
      });

      test("endPillNumberを超えた場合、1に戻る", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-25"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 21,
          ),
        );
        // endPillNumber=21なので、22番目以降は1に戻る
        // 25番目のピル: 21を超えるので 25-21=4番
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 4);
      });

      test("endPillNumberちょうどの場合、その番号を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-21"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 21,
          ),
        );
        // 21番目のピル = endPillNumber
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 21);
      });
    });

    group("sequentialモードで複数ピルシートがある場合", () {
      test("2枚目のピルシートで服用した場合、1枚目からの通し番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        // 2020-10-05は2枚目の7番目（2020-09-29から7日目）
        // 通し番号では28 + 7 = 35番目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 35);
      });
    });

    group("複数のRestDurationがある場合", () {
      test("2回の服用お休み期間があった場合、それぞれの終了時に番号がリセットされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-30"),
          createdAt: now(),
          restDurations: [
            // 1回目: 2020-09-05〜2020-09-07（終了で番号1にリセット）
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            // 2回目: 2020-09-15〜2020-09-17（終了で番号1にリセット）
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 2回目のお休み終了日(2020-09-17)で番号が1にリセット
        // 2020-09-17が1番、2020-09-18が2番、...、2020-09-30が14番
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 14);
      });
    });

    group("異なる種類のピルシートが混在する場合", () {
      test("1枚目が21錠タイプ、2枚目が24錠タイプの場合の通し番号", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType1 = PillSheetType.pillsheet_21;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        // 1枚目: 2020-09-01〜2020-09-28（pillsheet_21はtotalCount=28）
        // 2枚目: 2020-09-29〜（pillsheet_24_0はtotalCount=24）
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 1枚目28錠 + 2枚目の7番目 = 35番
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 35);
      });
    });
  });

  group("#menstruationDateRanges", () {
    group("has one pill sheet", () {
      test("setting.pillNumberForFromMenstruation or setting.durationMenstruation is not setting", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 0,
          durationMenstruation: 0,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
      test("setting values in the range of pill sheet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-01"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 24,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-24"), DateTime.parse("2020-09-26"))]);
      });
      test("setting values out the range of pill sheet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-01"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 29,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
      test("setting values two appears in the range of pill sheet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-01"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 10,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-10"), DateTime.parse("2020-09-12"))]);
      });
    });

    group("has three pill sheet", () {
      test("setting.pillNumberForFromMenstruation or setting.durationMenstruation is not setting", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 0,
          durationMenstruation: 0,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
      test("setting values in the range of pill sheet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillNumberForFromMenstruation: 24,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-24"), DateTime.parse("2020-09-26")),
          DateRange(DateTime.parse("2020-10-22"), DateTime.parse("2020-10-24")),
          DateRange(DateTime.parse("2020-11-19"), DateTime.parse("2020-11-21")),
        ]);
      });
      test("setting values in the range of pill sheet and with not ended rest durations", () {
        const pastDaysFromBeginRestDuration = 2;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10").add(const Duration(days: 2)));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: null,
              ),
            ]);
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 + pastDaysFromBeginRestDuration)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2 + pastDaysFromBeginRestDuration)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillNumberForFromMenstruation: 24,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-26"), DateTime.parse("2020-09-28")),
          DateRange(DateTime.parse("2020-10-24"), DateTime.parse("2020-10-26")),
          DateRange(DateTime.parse("2020-11-21"), DateTime.parse("2020-11-23")),
        ]);
      });
      test("setting values in the range of pill sheet and with ended rest durations", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));
        const restDurationDays = 2;

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-10").add(const Duration(days: restDurationDays)),
              ),
            ]);
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 + restDurationDays)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2 + restDurationDays)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillNumberForFromMenstruation: 24,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-26"), DateTime.parse("2020-09-28")),
          DateRange(DateTime.parse("2020-10-24"), DateTime.parse("2020-10-26")),
          DateRange(DateTime.parse("2020-11-21"), DateTime.parse("2020-11-23")),
        ]);
      });
      test("setting values out the range of pill sheet group", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillNumberForFromMenstruation: 100,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
      test("setting values out of the range for each pill sheet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillNumberForFromMenstruation: 29,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-29"), DateTime.parse("2020-10-01")),
          DateRange(DateTime.parse("2020-10-28"), DateTime.parse("2020-10-30")),
        ]);
      });
      test("setting values two appears in the range of pill sheet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        const setting = Setting(
          pillNumberForFromMenstruation: 10,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-10"), DateTime.parse("2020-09-12")),
          DateRange(DateTime.parse("2020-10-08"), DateTime.parse("2020-10-10")),
          DateRange(DateTime.parse("2020-11-05"), DateTime.parse("2020-11-07")),
        ]);
      });
    });

    group("境界値テスト", () {
      test("pillNumberForFromMenstruation が totalCount と等しい場合、elseブランチ経由で生理期間が設定される", () {
        // pillNumberForFromMenstruation < totalCount の条件を満たさないためelseブランチに入る
        // elseブランチでは summarizedPillCount ~/ pillNumberForFromMenstruation の計算で
        // fromMenstruations に 21 が含まれ、範囲内なので生理期間が設定される
        // pillsheet_21_0 を使用（totalCount == 21、すべて実薬のタイプ）
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount, // 21
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 21, // == totalCount
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // pillNumberForFromMenstruation (21) < totalCount (21) は false → elseブランチ
        // summarizedPillCount = 21, numberOfMenstruationSettingInPillSheetGroup = 21 ~/ 21 = 1
        // fromMenstruations = [21], offset = 0, begin = 1, end = 21
        // 21は範囲[1,21]内なので生理期間が設定される
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-21"), DateTime.parse("2020-09-23")),
        ]);
      });

      test("pillNumberForFromMenstruation が totalCount を超える場合、1枚のシートでは生理期間が設定されない", () {
        // pillNumberForFromMenstruation > totalCount の場合、elseブランチに入る
        // 1枚のシートでは fromMenstruations が空になり生理期間が設定されない
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount, // 21
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 22, // > totalCount
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // pillNumberForFromMenstruation (22) < totalCount (21) は false → elseブランチ
        // summarizedPillCount = 21, numberOfMenstruationSettingInPillSheetGroup = 21 ~/ 22 = 0
        // fromMenstruations = [] (空) → 生理期間が設定されない
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });

      test("pillNumberForFromMenstruation が totalCount - 1 の場合、生理期間が設定される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount, // 21
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 20, // == totalCount - 1
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 20番目 = 2020-09-20 から3日間
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-20"), DateTime.parse("2020-09-22")),
        ]);
      });

      test("pillNumberForFromMenstruation が 1 の場合、シート開始日から生理期間が設定される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 1,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 1番目 = 2020-09-01 から3日間
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-01"), DateTime.parse("2020-09-03")),
        ]);
      });

      test("durationMenstruation が 1 の場合、1日だけの生理期間", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 20,
          durationMenstruation: 1, // 最小値
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 20番目 = 2020-09-20 の1日だけ
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-20"), DateTime.parse("2020-09-20")),
        ]);
      });
    });

    group("設定値の個別0テスト", () {
      test("pillNumberForFromMenstruation のみ 0 の場合は空配列", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 0, // 0
          durationMenstruation: 3, // != 0
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });

      test("durationMenstruation のみ 0 の場合は空配列", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 20, // != 0
          durationMenstruation: 0, // 0
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
    });

    group("異なるPillSheetTypeの組み合わせ", () {
      test("21錠と28錠タイプが混在する場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount, // 21
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount, // 28
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        // 20番は21錠シートでは範囲内、28錠シートでも範囲内
        const setting = Setting(
          pillNumberForFromMenstruation: 20,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-20"), DateTime.parse("2020-09-22")),
          DateRange(DateTime.parse("2020-10-18"), DateTime.parse("2020-10-20")),
        ]);
      });

      test("21錠タイプ（実薬のみ）と28錠タイプが混在し、設定が21錠の境界値（21番）の場合", () {
        // pillsheet_21_0 を使用（totalCount == 21、すべて実薬）
        // pillsheet_21 は totalCount == 28（21錠+7日休薬）なので使用しない
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType21 = PillSheetType.pillsheet_21_0;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount, // 21
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 21)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount, // 28
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        // 21番は21錠シート(実薬のみ)では境界（totalCountと等しい）、28錠シートでは範囲内
        const setting = Setting(
          pillNumberForFromMenstruation: 21,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 21錠シート: pillNumberForFromMenstruation (21) < totalCount (21) は false → elseブランチ
        //   summarizedPillCount = 49, numberOfMenstruationSettingInPillSheetGroup = 49 ~/ 21 = 2
        //   fromMenstruations = [21, 42], 21は範囲[1,21]内 → 生理期間設定
        // 28錠シート: pillNumberForFromMenstruation (21) < totalCount (28) は true → ifブランチ
        //   displayPillTakeDate(21) → 2020-10-12 から3日間
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-21"), DateTime.parse("2020-09-23")),
          DateRange(DateTime.parse("2020-10-12"), DateTime.parse("2020-10-14")),
        ]);
      });

      test("24錠タイプ（実薬のみ）と28錠タイプが混在する場合", () {
        // pillsheet_24_0 は totalCount == 24（すべて実薬）
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType24 = PillSheetType.pillsheet_24_0;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType24.dosingPeriod,
            name: sheetType24.fullName,
            totalCount: sheetType24.totalCount, // 24
            pillSheetTypeReferencePath: sheetType24.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 24)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount, // 28
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        // 22番 は 24 < 22 なので24錠シートでは範囲内、28錠シートでも範囲内
        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 24錠シート: pillNumberForFromMenstruation (22) < totalCount (24) は true なので適用
        // 28錠シート: pillNumberForFromMenstruation (22) < totalCount (28) は true なので適用
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-22"), DateTime.parse("2020-09-24")),
          DateRange(DateTime.parse("2020-10-16"), DateTime.parse("2020-10-18")),
        ]);
      });
    });

    group("生理期間がピルシートをまたぐケース", () {
      test("durationMenstruation が長くシート終了日を超える場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount, // 21
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        // 20番から7日間 → 20〜26日（シートの21日を超える）
        const setting = Setting(
          pillNumberForFromMenstruation: 20,
          durationMenstruation: 7,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // menstruationDateRanges はシートの終了を考慮しない単純な日数加算
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-20"), DateTime.parse("2020-09-26")),
        ]);
      });
    });

    group("複数の生理期間が設定される場合（ヤーズフレックス等）", () {
      test("pillNumberForFromMenstruation が totalCount を超え、複数回の生理期間が含まれる場合", () {
        // ヤーズフレックスのように長い周期で生理が来る設定
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 2)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        // 46番ごとに生理 → 84錠グループで46番、92番が対象だが、84錠までしかないので46番のみ
        // 46番 = 2枚目の18番目 (28 + 18)
        const setting = Setting(
          pillNumberForFromMenstruation: 46,
          durationMenstruation: 4,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // summarizedPillCount = 84
        // numberOfMenstruationSettingInPillSheetGroup = 84 ~/ 46 = 1
        // fromMenstruations = [46]
        // pillSheet2: offset = 28, begin = 29, end = 56
        // 46は範囲内 (29 <= 46 <= 56) なので適用される
        // pillSheet2の (46 - 28) = 18番目の日付
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-10-16"), DateTime.parse("2020-10-19")),
        ]);
      });
    });
  });

  group("#pillNumbersForCyclicSequential", () {
    group("ピルシートが1つの場合", () {
      test("服薬お休み期間がない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number), [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
        ]);
      });
      test("服薬お休み期間がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-16"),
              createdDate: DateTime.parse("2020-09-16"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number), [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          // NOTE: 16番目から2日間休薬する。そのあと1番始まりになる
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
        ]);
      });
      test("服薬お休み期間がある。ただし、終了はしていない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-16"),
              createdDate: DateTime.parse("2020-09-16"),
              endDate: null,
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number), [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
        ]);
      });
      test("服薬お休み期間がある場合。かつ、服用日数を開始番号を変更している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-16"),
              createdDate: DateTime.parse("2020-09-16"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 2,
          ),
        );
        expect(pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number), [
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          // NOTE: 16番目から2日間休薬する。そのあと1番から始まる
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
        ]);
      });
      test("服薬お休み期間がある場合。かつ、服用日数を開始番号と終了番号を変更している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-16"),
              createdDate: DateTime.parse("2020-09-16"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 2,
            endPillNumber: 14,
          ),
        );
        expect(pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number), [
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          // NOTE: 16番目が終了番号設定が14番目なので、1番目から始まる
          1,
          2,
          // NOTE: 16番目から2日間休薬する。そして、表示番号が2番からでも服用お休み後は1番から始まる
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
        ]);
      });
    });
    group("ピルシートが2つの場合", () {
      test("服薬お休み期間がない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number), [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29,
          30,
          31,
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
        ]);
      });
      test("服薬お休み期間がある場合（1枚目で休薬）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-16"),
              createdDate: DateTime.parse("2020-09-16"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final numbers = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 1-15, 休薬後1-13 (計28)
        // 2枚目: 14-41 (計28)
        expect(numbers.sublist(0, 28), [
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
          // 休薬後に1から始まる
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
        ]);
        // 2枚目は1枚目の最後の番号+1から始まる（13+1=14）
        expect(numbers.sublist(28, 56), [
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29,
          30,
          31,
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
        ]);
      });
      test("服薬お休み期間がある。ただし、終了はしていない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-16"),
              createdDate: DateTime.parse("2020-09-16"),
              endDate: null, // 終了していない
            ),
          ],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final numbers = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 服用お休みが終わっていない場合は番号リセットは起きない
        expect(numbers, [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          17,
          18,
          19,
          20,
          21,
          22,
          23,
          24,
          25,
          26,
          27,
          28,
          29,
          30,
          31,
          32,
          33,
          34,
          35,
          36,
          37,
          38,
          39,
          40,
          41,
          42,
          43,
          44,
          45,
          46,
          47,
          48,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
        ]);
      });
      test("displayNumberSettingでendPillNumberが設定されている場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-14").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 28, // 28でリセット
          ),
        );

        final numbers = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 1-28
        // 2枚目: 1-28 (endPillNumberで1にリセット)
        expect(numbers.sublist(0, 28), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]);
        expect(numbers.sublist(28, 56), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]);
      });
    });
    group("ピルシートが3つの場合", () {
      test("服薬お休み期間がない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").addDays(56),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final numbers = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        expect(numbers.length, 84); // 28 * 3
        // 1枚目: 1-28
        expect(numbers.sublist(0, 28), List.generate(28, (i) => i + 1));
        // 2枚目: 29-56
        expect(numbers.sublist(28, 56), List.generate(28, (i) => i + 29));
        // 3枚目: 57-84
        expect(numbers.sublist(56, 84), List.generate(28, (i) => i + 57));
      });
      test("2枚目で服薬お休み期間がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28), // 2020-09-29
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-10-05"), // 2枚目の7日目
              createdDate: DateTime.parse("2020-10-05"),
              endDate: DateTime.parse("2020-10-08"),
            ),
          ],
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").addDays(56),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final numbers = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 1-28
        expect(numbers.sublist(0, 28), List.generate(28, (i) => i + 1));
        // 2枚目: 休薬開始は2020-10-05、終了は2020-10-08
        // buildDatesが休薬期間（10-05〜10-07の3日間）をスキップするため、
        // 09-29〜10-04で6日間（29-34）、10-08が休薬終了日なので1にリセット、その後22日間（1-22）
        expect(numbers.sublist(28, 56), [
          29, 30, 31, 32, 33, 34, // 6日間（09-29〜10-04）
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, // 休薬終了後1からリセット
        ]);
        // 3枚目: 前のシートの最後の番号22+1=23から始まる
        expect(numbers.sublist(56, 84), List.generate(28, (i) => i + 23));
      });
    });
    group("シート間の境界値テスト", () {
      test("1枚目の最後と2枚目の最初の番号が連続している", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final pillMarks = pillSheetGroup.pillNumbersForCyclicSequential;
        // 1枚目の最後
        final lastOfSheet1 = pillMarks[27]; // 0-indexed, 28番目
        expect(lastOfSheet1.number, 28);
        expect(lastOfSheet1.pillSheet.groupIndex, 0);
        // 2枚目の最初
        final firstOfSheet2 = pillMarks[28]; // 0-indexed, 29番目
        expect(firstOfSheet2.number, 29);
        expect(firstOfSheet2.pillSheet.groupIndex, 1);
        // 連続していることを確認
        expect(firstOfSheet2.number, lastOfSheet1.number + 1);
      });
      test("2枚目の最後と3枚目の最初の番号が連続している", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-09-01").addDays(56),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final pillMarks = pillSheetGroup.pillNumbersForCyclicSequential;
        // 2枚目の最後
        final lastOfSheet2 = pillMarks[55]; // 0-indexed
        expect(lastOfSheet2.number, 56);
        expect(lastOfSheet2.pillSheet.groupIndex, 1);
        // 3枚目の最初
        final firstOfSheet3 = pillMarks[56]; // 0-indexed
        expect(firstOfSheet3.number, 57);
        expect(firstOfSheet3.pillSheet.groupIndex, 2);
        // 連続していることを確認
        expect(firstOfSheet3.number, lastOfSheet2.number + 1);
      });
      test("境界でendPillNumberによるリセットが起こる場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 28,
          ),
        );

        final pillMarks = pillSheetGroup.pillNumbersForCyclicSequential;
        // 1枚目の最後
        final lastOfSheet1 = pillMarks[27];
        expect(lastOfSheet1.number, 28);
        expect(lastOfSheet1.pillSheet.groupIndex, 0);
        // 2枚目の最初（endPillNumberで1にリセット）
        final firstOfSheet2 = pillMarks[28];
        expect(firstOfSheet2.number, 1);
        expect(firstOfSheet2.pillSheet.groupIndex, 1);
      });
    });
    group("異なるPillSheetTypeの組み合わせ", () {
      test("21錠タイプと28錠タイプの組み合わせ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType1 = PillSheetType.pillsheet_21;
        const sheetType2 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          // pillsheet_21はtotalCount=28だが、dosingPeriod=21
          beginingDate: DateTime.parse("2020-09-01").addDays(28),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final numbers = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目（21錠タイプ、ただしtotalCount=28）: 1-28
        expect(numbers.sublist(0, 28), List.generate(28, (i) => i + 1));
        // 2枚目（28錠タイプ）: 29-56
        expect(numbers.sublist(28, 56), List.generate(28, (i) => i + 29));
      });
    });
  });

  group("#isDeactived", () {
    group("アクティブなピルシートがある場合", () {
      test("deletedAtがnullの場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("deletedAtが設定されている場合はtrueを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: DateTime.parse("2020-09-20"),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });
    });

    group("アクティブなピルシートがない場合", () {
      test("今日がピルシート開始日前日の場合はtrueを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });

      test("今日がピルシート終了日翌日の場合はtrueを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21は28日周期。2020-09-01開始で2020-09-28が終了日。翌日は2020-09-29
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });

      test("deletedAtも設定されている場合はtrueを返す（両条件）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: DateTime.parse("2020-09-20"),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });
    });

    group("境界値テスト", () {
      test("今日がピルシート開始日の場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("今日がピルシート終了日の場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21は28日周期。2020-09-01開始で2020-09-28が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });
    });

    group("ピルシートが複数ある場合", () {
      test("2枚目がアクティブな期間でdeletedAtがnullの場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 2枚目の期間中
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("全ピルシートの期間外の場合はtrueを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 2枚目の終了日（2020-10-26）の翌日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });

      test("1枚目と2枚目の境界日（1枚目終了日）でdeletedAtがnullの場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目の終了日（28日目）= 2020-09-28
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("1枚目と2枚目の境界日（2枚目開始日）でdeletedAtがnullの場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 2枚目の開始日 = 2020-09-29
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });
    });

    group("服用お休み期間がある場合", () {
      test("服用お休みにより終了日がずれた場合でもアクティブならfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 本来の終了日は2020-09-28だが、2日間の休薬により2020-09-30が終了日になる
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("服用お休みにより終了日がずれた終了日の翌日はtrueを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 本来の終了日は2020-09-28だが、2日間の休薬により2020-09-30が終了日。翌日は2020-10-01
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });
    });

    group("totalCountが異なるPillSheetTypeの場合", () {
      test("pillsheet_24_0（24錠）の開始日の場合はfalseを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("pillsheet_24_0（24錠）の終了日の場合はfalseを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_24_0は24日周期。2020-09-01開始で2020-09-24が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("pillsheet_24_0（24錠）の終了日翌日の場合はtrueを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_24_0は24日周期。2020-09-01開始で2020-09-24が終了日。翌日は2020-09-25
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });

      test("pillsheet_21_0（21錠）の終了日の場合はfalseを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21_0は21日周期。2020-09-01開始で2020-09-21が終了日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("pillsheet_21_0（21錠）の終了日翌日の場合はtrueを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21_0は21日周期。2020-09-01開始で2020-09-21が終了日。翌日は2020-09-22
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });
    });

    group("3枚以上のピルシートがある場合", () {
      test("2枚目と3枚目の境界日（2枚目終了日）でfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 2020-09-01〜2020-09-28（28日）
        // 2枚目: 2020-09-29〜2020-10-26（28日）。終了日は2020-10-26
        // 3枚目: 2020-10-27〜
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("2枚目と3枚目の境界日（3枚目開始日）でfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 3枚目開始日: 2020-10-27
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("3枚目終了日翌日の場合はtrueを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 3枚目: 2020-10-27〜2020-11-23（28日）。翌日は2020-11-24
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-24"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });
    });

    group("異なるPillSheetTypeの混合の場合", () {
      test("21錠と24錠の組み合わせで2枚目（24錠）がアクティブな場合はfalseを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目(pillsheet_21_0): 2020-09-01〜2020-09-21（21日）
        // 2枚目(pillsheet_24_0): 2020-09-22〜2020-10-15（24日）。期間中の2020-10-01
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

        const sheetType1 = PillSheetType.pillsheet_21_0;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("21錠と24錠の組み合わせで1枚目終了日（21錠の終了日）でfalseを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目(pillsheet_21_0)終了日: 2020-09-21
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType1 = PillSheetType.pillsheet_21_0;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("21錠と24錠の組み合わせで2枚目開始日（24錠の開始日）でfalseを返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 2枚目(pillsheet_24_0)開始日: 2020-09-22
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

        const sheetType1 = PillSheetType.pillsheet_21_0;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, false);
      });

      test("21錠と24錠の組み合わせで全期間終了後はtrueを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 2枚目(pillsheet_24_0): 2020-09-22〜2020-10-15。翌日は2020-10-16
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-16"));

        const sheetType1 = PillSheetType.pillsheet_21_0;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          deletedAt: null,
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.isDeactived, true);
      });
    });
  });

  group("#sequentialTodayPillNumber", () {
    group("PillSheetAppearanceModeがnumberまたはdateの場合", () {
      for (final mode in [PillSheetAppearanceMode.number, PillSheetAppearanceMode.date]) {
        test("${mode.name}モードの場合は0を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-13"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: mode,
          );

          expect(pillSheetGroup.sequentialTodayPillNumber, 0);
        });
      }
    });

    group("PillSheetAppearanceModeがsequentialまたはcyclicSequentialの場合", () {
      for (final mode in [PillSheetAppearanceMode.sequential, PillSheetAppearanceMode.cyclicSequential]) {
        group("${mode.name}モード", () {
          group("ピルシートが1つの場合", () {
            test("今日がピルシート期間内の場合は対応する番号を返す", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 2020-09-01開始で2020-09-14は14日目
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-13"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 14);
            });

            test("今日がピルシート開始日（1日目）の場合は1を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 1);
            });

            test("今日がピルシート終了日の場合は最終番号を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // pillsheet_21のtotalCountは28
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 28);
            });

            test("今日がピルシート期間外（開始日前）の場合は0を返す", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 0);
            });

            test("今日がピルシート期間外（終了日翌日）の場合は0を返す", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 0);
            });
          });

          group("ピルシートが複数ある場合", () {
            test("1枚目の最終日の場合は1枚目の最終番号を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 1枚目: 2020-09-01〜2020-09-28 (28日間)
              // 1枚目最終日: 2020-09-28 → 28番
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
                pillSheets: [pillSheet1, pillSheet2],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 28);
            });

            test("2枚目の開始日の場合は29を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 2枚目開始日: 2020-09-29 → 28 + 1 = 29番
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
                pillSheets: [pillSheet1, pillSheet2],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 29);
            });

            test("2枚目の最終日の場合は56を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 2枚目最終日: 2020-09-29 + 27日 = 2020-10-26 → 28 + 28 = 56番
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
                pillSheets: [pillSheet1, pillSheet2],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 56);
            });

            test("3枚目の開始日の場合は57を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 3枚目開始日: 2020-10-27 → 28 + 28 + 1 = 57番
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet3 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 2,
                beginingDate: DateTime.parse("2020-10-27"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
                pillSheets: [pillSheet1, pillSheet2, pillSheet3],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 57);
            });
          });

          group("DisplayNumberSettingがある場合", () {
            test("beginPillNumberが設定されている場合、開始番号から始まる", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 開始番号10の場合、1日目は10番
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  beginPillNumber: 10,
                ),
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 10);
            });

            test("beginPillNumberが設定されている場合、14日目は23番（10 + 13）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  beginPillNumber: 10,
                ),
              );

              // 10 + 13 = 23
              expect(pillSheetGroup.sequentialTodayPillNumber, 23);
            });

            test("endPillNumberが設定されていて超過した場合、1にリセットされる", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // endPillNumber=21の場合、22日目は1番にリセット
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  endPillNumber: 21,
                ),
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 1);
            });

            test("endPillNumberちょうどの日は終了番号を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 21日目はendPillNumber=21でちょうど21
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  endPillNumber: 21,
                ),
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 21);
            });
          });

          group("RestDurationがある場合", () {
            test("服用お休み期間中（継続中）は休薬開始日の番号を返す", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 2020-09-10から休薬中（endDate=null）
              // buildDatesでは休薬期間中の日付がtoday()までずれるため、
              // 今日(2020-09-12)は10番目の日付にマッピングされる
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-09"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-09-10"),
                    createdDate: DateTime.parse("2020-09-10"),
                    endDate: null, // 継続中
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              // 休薬期間中は日付がずれるため、今日は休薬開始日の番号（10番）に対応
              expect(pillSheetGroup.sequentialTodayPillNumber, 10);
            });

            test("服用お休み終了日の翌日は1にリセットされる", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 休薬終了日は2020-09-12。その日は番号が1にリセット
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-09"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-09-10"),
                    createdDate: DateTime.parse("2020-09-10"),
                    endDate: DateTime.parse("2020-09-12"), // 終了日
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              // 休薬終了日は1にリセットされる
              expect(pillSheetGroup.sequentialTodayPillNumber, 1);
            });

            test("服用お休み終了後の日は1から順にカウントアップ", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 休薬終了日が2020-09-12で、2020-09-13は1の翌日で2
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-09"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-09-10"),
                    createdDate: DateTime.parse("2020-09-10"),
                    endDate: DateTime.parse("2020-09-12"), // 終了日
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              // 休薬終了日の翌日は2
              expect(pillSheetGroup.sequentialTodayPillNumber, 2);
            });

            test("服用お休みにより日付がずれた場合も正しく期間外判定される", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // pillsheet_21のtotalCount=28日で、2日間休薬すると期間が2日延長
              // 元終了日2020-09-28 + 2日 = 2020-09-30が終了日
              // 2020-10-01は期間外
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-09"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-09-10"),
                    createdDate: DateTime.parse("2020-09-10"),
                    endDate: DateTime.parse("2020-09-12"),
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 0);
            });

            test("複数のRestDurationがある場合、各終了日でリセットされる", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 1回目の休薬: 2020-09-10〜2020-09-12（2020-09-12でリセット）
              // 2回目の休薬: 2020-09-20〜2020-09-22（2020-09-22でリセット）
              // 2020-09-23は2回目の休薬後の2日目なので2
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-23"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-09"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id_1",
                    beginDate: DateTime.parse("2020-09-10"),
                    createdDate: DateTime.parse("2020-09-10"),
                    endDate: DateTime.parse("2020-09-12"),
                  ),
                  RestDuration(
                    id: "rest_duration_id_2",
                    beginDate: DateTime.parse("2020-09-20"),
                    createdDate: DateTime.parse("2020-09-20"),
                    endDate: DateTime.parse("2020-09-22"),
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 2);
            });
          });

          group("beginPillNumberとendPillNumberの両方が設定されている場合", () {
            test("開始番号から始まり、終了番号を超えたら1にリセットされる", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // beginPillNumber=5, endPillNumber=10の場合
              // 1日目: 5, 2日目: 6, ..., 6日目: 10, 7日目: 1にリセット
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-07"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  beginPillNumber: 5,
                  endPillNumber: 10,
                ),
              );

              // 7日目は endPillNumber(10) を超えたので 1 にリセット
              expect(pillSheetGroup.sequentialTodayPillNumber, 1);
            });

            test("終了番号ちょうどの日は終了番号を返す（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // beginPillNumber=5, endPillNumber=10の場合
              // 6日目: 10
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-06"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  beginPillNumber: 5,
                  endPillNumber: 10,
                ),
              );

              expect(pillSheetGroup.sequentialTodayPillNumber, 10);
            });

            test("リセット後も周期が継続する", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // beginPillNumber=5, endPillNumber=10の場合
              // 1日目: 5, ..., 6日目: 10, 7日目: 1, 8日目: 2, ..., 12日目: 6
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet = PillSheet(
                id: firestoreIDGenerator(),
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id"],
                pillSheets: [pillSheet],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
                displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
                  beginPillNumber: 5,
                  endPillNumber: 10,
                ),
              );

              // 12日目: 7日目から1にリセットされ、その後 1,2,3,4,5,6 で6日目は6
              expect(pillSheetGroup.sequentialTodayPillNumber, 6);
            });
          });

          group("複数ピルシート + RestDurationの組み合わせ", () {
            test("1枚目のRestDuration終了後、2枚目をまたいで連番が続く", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 1枚目: 2020-09-01〜2020-09-28 (28日間)
              // 休薬: 2020-09-10〜2020-09-12 (2020-09-12でリセット)
              // 2020-09-12以降は1から再開
              // 2020-09-29は2枚目開始日 = 1枚目の休薬後のカウント + 2枚目の日数
              // 休薬終了日(2020-09-12)が1、2020-09-13が2、...、2020-09-28が17(28-12+1=17)
              // 2枚目の2020-09-29は18
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-09"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-09-10"),
                    createdDate: DateTime.parse("2020-09-10"),
                    endDate: DateTime.parse("2020-09-12"),
                  ),
                ],
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
                pillSheets: [pillSheet1, pillSheet2],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              // 2枚目開始日(2020-09-29)は1枚目の休薬後カウント(17) + 1 = 18
              expect(pillSheetGroup.sequentialTodayPillNumber, 18);
            });

            test("2枚目にRestDurationがある場合、2枚目のリセット後は1から再開", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 1枚目: 2020-09-01〜2020-09-28 (28日間、番号1〜28)
              // 2枚目: 2020-09-29〜2020-10-26 (28日間)
              // 2枚目に休薬: 2020-10-05〜2020-10-07 (2020-10-07でリセット)
              // 2020-10-07は1にリセット
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-07"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-28"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: DateTime.parse("2020-10-04"),
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-10-05"),
                    createdDate: DateTime.parse("2020-10-05"),
                    endDate: DateTime.parse("2020-10-07"),
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
                pillSheets: [pillSheet1, pillSheet2],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              // 2枚目の休薬終了日(2020-10-07)は1にリセット
              expect(pillSheetGroup.sequentialTodayPillNumber, 1);
            });

            test("1枚目最終日と2枚目開始日の境界でRestDurationが跨らない（境界値）", () {
              final mockTodayRepository = MockTodayService();
              todayRepository = mockTodayRepository;
              // 1枚目: 2020-09-01〜2020-09-28 (28日間)
              // 休薬なし
              // 1枚目最終日(2020-09-28)は28番
              when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

              const sheetType = PillSheetType.pillsheet_21;
              final pillSheet1 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 0,
                beginingDate: DateTime.parse("2020-09-01"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
              );
              final pillSheet2 = PillSheet(
                id: firestoreIDGenerator(),
                groupIndex: 1,
                beginingDate: DateTime.parse("2020-09-29"),
                lastTakenDate: null,
                createdAt: now(),
                typeInfo: PillSheetTypeInfo(
                  dosingPeriod: sheetType.dosingPeriod,
                  name: sheetType.fullName,
                  totalCount: sheetType.totalCount,
                  pillSheetTypeReferencePath: sheetType.rawPath,
                ),
                restDurations: [
                  RestDuration(
                    id: "rest_duration_id",
                    beginDate: DateTime.parse("2020-09-29"),
                    createdDate: DateTime.parse("2020-09-29"),
                    endDate: DateTime.parse("2020-10-01"),
                  ),
                ],
              );
              final pillSheetGroup = PillSheetGroup(
                pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
                pillSheets: [pillSheet1, pillSheet2],
                createdAt: now(),
                pillSheetAppearanceMode: mode,
              );

              // 1枚目最終日は28番（2枚目のRestDurationの影響は受けない）
              expect(pillSheetGroup.sequentialTodayPillNumber, 28);
            });
          });
        });
      }
    });
  });

  group("#sequentialEstimatedEndPillNumber", () {
    group("PillSheetAppearanceModeによる分岐", () {
      group("numberモードの場合", () {
        test("0を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 0);
        });
      });

      group("dateモードの場合", () {
        test("0を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          );
          expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 0);
        });
      });

      group("sequentialモードの場合", () {
        test("グループ全体の最後のピル番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          // pillsheet_21はtotalCount=28
          expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
        });
      });

      group("cyclicSequentialモードの場合", () {
        test("グループ全体の最後のピル番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // pillsheet_21はtotalCount=28
          expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
        });
      });
    });

    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_28の場合はtotalCount=28を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("pillsheet_24_0の場合はtotalCount=24を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // pillsheet_24_0はtotalCount=24
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 24);
      });

      test("pillsheet_21_0（休薬期間なし21錠タイプ）の場合はtotalCount=21を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 21);
      });
    });

    group("複数のピルシートがある場合", () {
      test("2枚のピルシート（28錠×2）の場合、通し番号で56を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 28錠 × 2枚 = 56
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 56);
      });

      test("3枚のピルシート（28錠×3）の場合、通し番号で84を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 28錠 × 3枚 = 84
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 84);
      });

      test("異なるPillSheetTypeの組み合わせ（28錠 + 21錠）の場合、49を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType1 = PillSheetType.pillsheet_21;
        const sheetType2 = PillSheetType.pillsheet_21_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 28錠 + 21錠 = 49
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 49);
      });
    });

    group("displayNumberSettingがある場合", () {
      test("beginPillNumberが設定されている場合、開始番号を考慮した終了番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 10,
            endPillNumber: null,
          ),
        );
        // 開始番号10で28錠なので、10〜37の連続番号になる
        // 最後の番号は10 + 28 - 1 = 37
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 37);
      });

      test("endPillNumberが設定されている場合、周期に応じた終了番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 21,
          ),
        );
        // endPillNumber=21で28錠の場合、1〜21の後は1〜7になる
        // 最後の番号は7（28錠目 = 28-21 = 7）
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 7);
      });

      test("endPillNumber=28で28錠ピルシートの場合、28を返す（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 28,
          ),
        );
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("beginPillNumber=5, endPillNumber=21で28錠の場合の周期", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 5,
            endPillNumber: 21,
          ),
        );
        // 開始5から21まで（17個）で折り返し、残り11個は1〜11
        // 5,6,7...21(17個), 1,2,3...11(11個) = 28個
        // 最後の番号は11
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 11);
      });

      test("複数ピルシートでendPillNumber設定がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 28,
          ),
        );
        // 1〜28で1周期(28)、次の28錠も1〜28
        // 最後の番号は28
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });
    });

    group("RestDurationがある場合", () {
      test("服用お休み期間がある場合でも、最終番号を正しく返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // buildDatesにより休薬期間分日付がずれる
        // 1〜9日目は番号1〜9
        // 10日目（休薬開始日）でbuildDatesにより日付が休薬終了日にずれ、番号1にリセット
        // 11〜28日目は番号2〜19（残り19日分）
        // 最後の番号は19
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 19);
      });

      test("服用お休み期間が進行中（endDateがnull）の場合でも、ピルシートの最終番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: null,
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 休薬が終わっていないため、番号はリセットされず連続
        // 最後の番号は28
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("複数のピルシートで服用お休み期間がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-20"),
              createdDate: DateTime.parse("2020-09-20"),
              endDate: DateTime.parse("2020-09-22"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-10-01"),
          lastTakenDate: DateTime.parse("2020-10-20"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 1枚目: 1〜19、20日目（休薬開始）で日付がずれて番号1にリセット、21〜28日目は番号2〜9
        // 2枚目: 10〜37 (28日分)
        // 最後の番号は37
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 37);
      });
    });

    group("displayNumberSettingとRestDurationの複合ケース", () {
      test("beginPillNumber設定と服用お休み期間がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 5,
            endPillNumber: null,
          ),
        );
        // beginPillNumber=5で開始、1〜9日目は番号5〜13
        // 10日目（休薬開始日）で日付がずれて番号1にリセット
        // 11〜28日目は番号2〜19（残り19日分）
        // 最後の番号は19
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 19);
      });

      test("endPillNumber設定と服用お休み期間がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 1,
            endPillNumber: 21,
          ),
        );
        // 1〜9日目は番号1〜9
        // 10日目（休薬開始日）で日付がずれて番号1にリセット
        // 11〜28日目は番号2〜19（残り19日分）
        // 最後の番号は19（endPillNumber=21を超えないので折り返さない）
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 19);
      });
    });
  });

  group("#pillNumbersInPillSheet", () {
    group("単一のピルシートの場合", () {
      test("ピル番号は1からtotalCountまで順番に割り当てられる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // totalCount = 28（21錠+休薬7日）
        expect(pillNumbers.length, sheetType.totalCount);

        // 番号は1からtotalCountまで順番
        for (int i = 0; i < pillNumbers.length; i++) {
          expect(pillNumbers[i].number, i + 1);
        }
      });

      test("日付はbuildDatesで計算された日付と一致する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;
        final expectedDates = pillSheet.buildDates();

        for (int i = 0; i < pillNumbers.length; i++) {
          expect(isSameDay(pillNumbers[i].date, expectedDates[i]), isTrue);
        }
      });

      test("各要素にpillSheetが正しく紐付く", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        for (final pillMark in pillNumbers) {
          expect(pillMark.pillSheet.id, pillSheet.id);
        }
      });
    });

    group("複数のピルシートの場合", () {
      test("各ピルシートごとに1から番号が始まる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType1 = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );

        const sheetType2 = PillSheetType.pillsheet_21;
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // 合計はtotalCount * 2
        expect(pillNumbers.length, sheetType1.totalCount + sheetType2.totalCount);

        // 1枚目: 1からtotalCountまで
        for (int i = 0; i < sheetType1.totalCount; i++) {
          expect(pillNumbers[i].number, i + 1);
          expect(pillNumbers[i].pillSheet.id, pillSheet1.id);
        }

        // 2枚目: 1からtotalCountまで（リセットされる）
        for (int i = 0; i < sheetType2.totalCount; i++) {
          expect(pillNumbers[sheetType1.totalCount + i].number, i + 1);
          expect(pillNumbers[sheetType1.totalCount + i].pillSheet.id, pillSheet2.id);
        }
      });

      test("1枚目の最後の番号と2枚目の最初の番号が正しい（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType1 = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );

        const sheetType2 = PillSheetType.pillsheet_28_0;
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // 1枚目の最後（28番）
        expect(pillNumbers[sheetType1.totalCount - 1].number, sheetType1.totalCount);
        expect(pillNumbers[sheetType1.totalCount - 1].pillSheet.id, pillSheet1.id);

        // 2枚目の最初（1番）
        expect(pillNumbers[sheetType1.totalCount].number, 1);
        expect(pillNumbers[sheetType1.totalCount].pillSheet.id, pillSheet2.id);
      });

      test("3枚のピルシートでも各シートごとに1から番号が始まる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // 2枚目の最後と3枚目の最初（境界値）
        final secondSheetEnd = sheetType.totalCount * 2 - 1;
        final thirdSheetStart = sheetType.totalCount * 2;

        expect(pillNumbers[secondSheetEnd].number, sheetType.totalCount);
        expect(pillNumbers[secondSheetEnd].pillSheet.id, pillSheet2.id);

        expect(pillNumbers[thirdSheetStart].number, 1);
        expect(pillNumbers[thirdSheetStart].pillSheet.id, pillSheet3.id);
      });
    });

    group("服用お休み期間がある場合", () {
      test("番号は変わらないが日付がずれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"), // 2日間の休薬
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // 番号の数は変わらない
        expect(pillNumbers.length, sheetType.totalCount);

        // 番号は1からtotalCountまで順番（休薬期間で番号は変わらない）
        for (int i = 0; i < pillNumbers.length; i++) {
          expect(pillNumbers[i].number, i + 1);
        }

        // 休薬期間により日付がずれている
        // 9日目は2020-09-09、10日目は休薬終了後の2020-09-12（2日ずれ）
        expect(isSameDay(pillNumbers[8].date, DateTime.parse("2020-09-09")), isTrue);
        expect(isSameDay(pillNumbers[9].date, DateTime.parse("2020-09-12")), isTrue);
      });

      test("複数の服用お休み期間がある場合も番号は変わらない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-12"), // 2日間の休薬
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-20"),
              createdDate: DateTime.parse("2020-09-20"),
              endDate: DateTime.parse("2020-09-23"), // 3日間の休薬
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // 番号の数は変わらない
        expect(pillNumbers.length, sheetType.totalCount);

        // 番号は1からtotalCountまで順番
        for (int i = 0; i < pillNumbers.length; i++) {
          expect(pillNumbers[i].number, i + 1);
        }
      });
    });

    group("PillSheetTypeによる違い", () {
      test("pillsheet_21の場合、totalCount=28で28個の要素が生成される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        expect(pillNumbers.length, 28);
        expect(pillNumbers.first.number, 1);
        expect(pillNumbers.last.number, 28);
      });

      test("pillsheet_28_0の場合、totalCount=28で28個の要素が生成される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        expect(pillNumbers.length, 28);
        expect(pillNumbers.first.number, 1);
        expect(pillNumbers.last.number, 28);
      });

      test("pillsheet_24_0の場合、totalCount=24で24個の要素が生成される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        expect(pillNumbers.length, 24);
        expect(pillNumbers.first.number, 1);
        expect(pillNumbers.last.number, 24);
      });
    });

    group("PillSheetAppearanceModeに依存しない", () {
      // pillNumbersInPillSheetはPillSheetAppearanceModeに関係なく同じ結果を返す
      // （pillMarksメソッドでモードによって呼び分けられる）
      for (final mode in PillSheetAppearanceMode.values) {
        test("${mode.name}モードでも同じ結果を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: mode,
          );

          final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

          expect(pillNumbers.length, sheetType.totalCount);
          for (int i = 0; i < pillNumbers.length; i++) {
            expect(pillNumbers[i].number, i + 1);
          }
        });
      }
    });

    group("PillSheetGroupDisplayNumberSettingに依存しない", () {
      // pillNumbersInPillSheetはdisplayNumberSettingに関係なく同じ結果を返す
      // （displayNumberSettingはpillNumbersForCyclicSequentialにのみ影響）
      test("displayNumberSettingが設定されていても結果は変わらない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 10,
            endPillNumber: 50,
          ),
        );

        final pillNumbers = pillSheetGroup.pillNumbersInPillSheet;

        // displayNumberSettingに関係なく1からtotalCountまで
        expect(pillNumbers.length, sheetType.totalCount);
        expect(pillNumbers.first.number, 1);
        expect(pillNumbers.last.number, 28);
      });
    });
  });

  group("#replaced", () {
    group("例外がスローされるケース", () {
      test("pillSheet.idがnullの場合はFormatExceptionをスローする", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );

        // idがnullのピルシートで置き換えようとする
        final newPillSheet = pillSheet.copyWith(id: null, lastTakenDate: DateTime.parse("2020-09-10"));

        expect(
          () => pillSheetGroup.replaced(newPillSheet),
          throwsA(isA<FormatException>()),
        );
      });

      test("pillSheet.idがpillSheetsに存在しない場合はFormatExceptionをスローする", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );

        // 存在しないidのピルシートで置き換えようとする
        final nonExistentPillSheet = pillSheet.copyWith(id: "non_existent_id", lastTakenDate: DateTime.parse("2020-09-10"));

        expect(
          () => pillSheetGroup.replaced(nonExistentPillSheet),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group("ピルシートが1枚の場合", () {
      test("正常にピルシートを置き換えられる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final sheetId = firestoreIDGenerator();
        final pillSheet = PillSheet(
          id: sheetId,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [sheetId],
          pillSheets: [pillSheet],
          createdAt: now(),
        );

        final updatedPillSheet = pillSheet.copyWith(lastTakenDate: DateTime.parse("2020-09-10"));
        final updatedGroup = pillSheetGroup.replaced(updatedPillSheet);

        expect(updatedGroup.pillSheets.length, 1);
        expect(updatedGroup.pillSheets[0].id, sheetId);
        expect(updatedGroup.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-10"));
      });

      test("元のpillSheetGroupは変更されない（不変性の確認）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final sheetId = firestoreIDGenerator();
        final pillSheet = PillSheet(
          id: sheetId,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [sheetId],
          pillSheets: [pillSheet],
          createdAt: now(),
        );

        final updatedPillSheet = pillSheet.copyWith(lastTakenDate: DateTime.parse("2020-09-10"));
        pillSheetGroup.replaced(updatedPillSheet);

        // 元のpillSheetGroupは変更されていないことを確認
        expect(pillSheetGroup.pillSheets[0].lastTakenDate, isNull);
      });
    });

    group("ピルシートが複数枚の場合", () {
      test("1枚目のピルシートを置き換える", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final sheetId1 = firestoreIDGenerator();
        final sheetId2 = firestoreIDGenerator();
        final sheetId3 = firestoreIDGenerator();

        final pillSheet1 = PillSheet(
          id: sheetId1,
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: sheetId2,
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: sheetId3,
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [sheetId1, sheetId2, sheetId3],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );

        final updatedPillSheet1 = pillSheet1.copyWith(lastTakenDate: DateTime.parse("2020-09-10"));
        final updatedGroup = pillSheetGroup.replaced(updatedPillSheet1);

        expect(updatedGroup.pillSheets.length, 3);
        expect(updatedGroup.pillSheets[0].id, sheetId1);
        expect(updatedGroup.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-10"));
        // 他のピルシートは変更されていない
        expect(updatedGroup.pillSheets[1].id, sheetId2);
        expect(updatedGroup.pillSheets[1].lastTakenDate, isNull);
        expect(updatedGroup.pillSheets[2].id, sheetId3);
        expect(updatedGroup.pillSheets[2].lastTakenDate, isNull);
      });

      test("中間（2枚目）のピルシートを置き換える", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final sheetId1 = firestoreIDGenerator();
        final sheetId2 = firestoreIDGenerator();
        final sheetId3 = firestoreIDGenerator();

        final pillSheet1 = PillSheet(
          id: sheetId1,
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: sheetId2,
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: sheetId3,
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [sheetId1, sheetId2, sheetId3],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );

        final updatedPillSheet2 = pillSheet2.copyWith(lastTakenDate: DateTime.parse("2020-10-05"));
        final updatedGroup = pillSheetGroup.replaced(updatedPillSheet2);

        expect(updatedGroup.pillSheets.length, 3);
        // 1枚目は変更されていない
        expect(updatedGroup.pillSheets[0].id, sheetId1);
        expect(updatedGroup.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-28"));
        // 2枚目が更新されている
        expect(updatedGroup.pillSheets[1].id, sheetId2);
        expect(updatedGroup.pillSheets[1].lastTakenDate, DateTime.parse("2020-10-05"));
        // 3枚目は変更されていない
        expect(updatedGroup.pillSheets[2].id, sheetId3);
        expect(updatedGroup.pillSheets[2].lastTakenDate, isNull);
      });

      test("最後（3枚目）のピルシートを置き換える", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final sheetId1 = firestoreIDGenerator();
        final sheetId2 = firestoreIDGenerator();
        final sheetId3 = firestoreIDGenerator();

        final pillSheet1 = PillSheet(
          id: sheetId1,
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: sheetId2,
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: sheetId3,
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [sheetId1, sheetId2, sheetId3],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
        );

        final updatedPillSheet3 = pillSheet3.copyWith(lastTakenDate: DateTime.parse("2020-11-05"));
        final updatedGroup = pillSheetGroup.replaced(updatedPillSheet3);

        expect(updatedGroup.pillSheets.length, 3);
        // 1枚目は変更されていない
        expect(updatedGroup.pillSheets[0].id, sheetId1);
        expect(updatedGroup.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-28"));
        // 2枚目は変更されていない
        expect(updatedGroup.pillSheets[1].id, sheetId2);
        expect(updatedGroup.pillSheets[1].lastTakenDate, DateTime.parse("2020-10-26"));
        // 3枚目が更新されている
        expect(updatedGroup.pillSheets[2].id, sheetId3);
        expect(updatedGroup.pillSheets[2].lastTakenDate, DateTime.parse("2020-11-05"));
      });
    });

    group("置き換えでピルシートの他のプロパティも更新される", () {
      test("restDurationsが更新される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final sheetId = firestoreIDGenerator();
        final pillSheet = PillSheet(
          id: sheetId,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-10"),
          createdAt: now(),
          restDurations: [],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [sheetId],
          pillSheets: [pillSheet],
          createdAt: now(),
        );

        final restDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-11"),
          createdDate: DateTime.parse("2020-09-11"),
        );
        final updatedPillSheet = pillSheet.copyWith(restDurations: [restDuration]);
        final updatedGroup = pillSheetGroup.replaced(updatedPillSheet);

        expect(updatedGroup.pillSheets[0].restDurations.length, 1);
        expect(updatedGroup.pillSheets[0].restDurations[0].beginDate, DateTime.parse("2020-09-11"));
      });
    });
  });

  group("#pillNumberWithoutDateOrZeroFromDate", () {
    group("PillSheetAppearanceMode.number の場合", () {
      group("ピルシートが1つの場合", () {
        test("1日目のtargetDateで番号1を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-01"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result, 1);
        });

        test("中間日のtargetDateで対応する番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 2020-09-15は15日目
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-15"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result, 15);
        });

        test("最終日のtargetDateで番号28を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 2020-09-28は28日目
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-28"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result, 28);
        });

        test("RestDurationがある場合、休薬期間分ずれた日付で番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 2020-09-15は、休薬期間（2日）があるため、13番目になる
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-15"),
            estimatedEventCausingDate: DateTime.parse("2020-09-20"),
          );
          expect(result, 13);
        });
      });

      group("ピルシートが複数の場合", () {
        test("1枚目の最終日で番号28を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 2020-09-28は1枚目の28日目
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-28"),
            estimatedEventCausingDate: DateTime.parse("2020-10-15"),
          );
          expect(result, 28);
        });

        test("2枚目の1日目で番号1を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 2020-09-29は2枚目の1日目
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-10-15"),
          );
          expect(result, 1);
        });

        test("3枚目の中間日で番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-26"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet3 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 2,
            beginingDate: DateTime.parse("2020-10-27"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
            pillSheets: [pillSheet1, pillSheet2, pillSheet3],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 2020-11-10は3枚目の15日目
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-11-10"),
            estimatedEventCausingDate: DateTime.parse("2020-11-15"),
          );
          expect(result, 15);
        });
      });
    });

    group("PillSheetAppearanceMode.date の場合", () {
      test("number モードと同様の番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
        );

        final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          targetDate: DateTime.parse("2020-09-15"),
          estimatedEventCausingDate: DateTime.parse("2020-09-14"),
        );
        expect(result, 15);
      });
    });

    group("PillSheetAppearanceMode.sequential の場合", () {
      group("ピルシートが1つの場合", () {
        test("連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            targetDate: DateTime.parse("2020-09-15"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result, 15);
        });
      });

      group("ピルシートが複数の場合", () {
        test("2枚目の1日目で連続番号29を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // 2020-09-29は2枚目の1日目 = 連続番号で29
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-10-15"),
          );
          expect(result, 29);
        });

        test("1枚目の最終日で連続番号28を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // 2020-09-28は1枚目の最終日 = 連続番号で28
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            targetDate: DateTime.parse("2020-09-28"),
            estimatedEventCausingDate: DateTime.parse("2020-10-15"),
          );
          expect(result, 28);
        });
      });

      group("RestDurationがある場合", () {
        test("休薬期間終了後は1番から再開される", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // 2020-09-12は休薬期間終了日なので番号1
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            targetDate: DateTime.parse("2020-09-12"),
            estimatedEventCausingDate: DateTime.parse("2020-09-20"),
          );
          expect(result, 1);
        });

        test("休薬期間前の番号は通常通り連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                createdDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // 2020-09-09は休薬期間前なので番号9
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            targetDate: DateTime.parse("2020-09-09"),
            estimatedEventCausingDate: DateTime.parse("2020-09-20"),
          );
          expect(result, 9);
        });
      });
    });

    group("PillSheetAppearanceMode.cyclicSequential の場合", () {
      group("ピルシートが1つの場合", () {
        test("連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-15"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result, 15);
        });
      });

      group("displayNumberSettingがある場合", () {
        test("beginPillNumberが設定されていると開始番号がずれる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 5,
            ),
          );

          // 1日目は開始番号5
          final result1 = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-01"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result1, 5);

          // 10日目は番号14（5 + 9）
          final result2 = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-10"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          );
          expect(result2, 14);
        });

        test("endPillNumberが設定されていると終了番号で1に戻る", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              endPillNumber: 28,
            ),
          );

          // 28番を超えると1に戻る。29日目（2枚目の1日目）は番号1
          final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-10-15"),
          );
          expect(result, 1);
        });
      });
    });

    group("targetDateが見つからない場合", () {
      test("StateErrorが発生する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // ピルシートの期間外の日付を指定するとStateErrorが発生
        expect(
          () => pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-08-01"),
            estimatedEventCausingDate: DateTime.parse("2020-09-14"),
          ),
          throwsStateError,
        );
      });
    });

    group("estimatedEventCausingDateが異なる場合", () {
      test("estimatedEventCausingDateにより日付計算が変わる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-15"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // estimatedEventCausingDateが休薬期間終了後の場合、targetDateに休薬期間分のズレが反映される
        final result = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          targetDate: DateTime.parse("2020-09-20"),
          estimatedEventCausingDate: DateTime.parse("2020-09-20"),
        );
        // 2020-09-20は休薬期間（5日）があるため、15番目になる
        expect(result, 15);
      });
    });

    group("pillSheetAppearanceMode引数が異なる場合", () {
      test("PillSheetGroupのモードと異なるモードを引数に指定できる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // PillSheetGroupはnumberモードだが
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 引数でcyclicSequentialを指定すると連続番号が返る
        final resultSequential = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          targetDate: DateTime.parse("2020-09-29"),
          estimatedEventCausingDate: DateTime.parse("2020-10-15"),
        );
        expect(resultSequential, 29);

        // 引数でnumberを指定するとピルシート内番号が返る
        final resultNumber = pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          targetDate: DateTime.parse("2020-09-29"),
          estimatedEventCausingDate: DateTime.parse("2020-10-15"),
        );
        expect(resultNumber, 1);
      });
    });
  });

  group("#pillNumberWithoutDateOrZero", () {
    group("pillNumberInPillSheet == 0 の場合", () {
      for (final mode in PillSheetAppearanceMode.values) {
        test("${mode.name} モードで 0 を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: mode,
          );

          final result = pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: mode,
            pageIndex: 0,
            pillNumberInPillSheet: 0,
          );
          expect(result, 0);
        });
      }
    });

    group("PillSheetAppearanceMode.number の場合", () {
      group("ピルシートが1つの場合", () {
        test("pillNumberInPillSheet をそのまま返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            1,
          );
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              pageIndex: 0,
              pillNumberInPillSheet: 15,
            ),
            15,
          );
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            28,
          );
        });
      });

      group("ピルシートが複数の場合", () {
        test("各ページで pillNumberInPillSheet をそのまま返す（pageIndex は無視される）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 1枚目の28番目（境界値）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            28,
          );
          // 2枚目の1番目（境界値）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            1,
          );
          // 2枚目の15番目
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              pageIndex: 1,
              pillNumberInPillSheet: 15,
            ),
            15,
          );
        });
      });
    });

    group("PillSheetAppearanceMode.date の場合", () {
      test("number モードと同様に pillNumberInPillSheet をそのまま返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
        );

        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            pageIndex: 0,
            pillNumberInPillSheet: 15,
          ),
          15,
        );
      });
    });

    group("PillSheetAppearanceMode.sequential の場合", () {
      group("ピルシートが1つの場合", () {
        test("連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
              pageIndex: 0,
              pillNumberInPillSheet: 15,
            ),
            15,
          );
        });
      });

      group("ピルシートが複数の場合", () {
        test("1枚目の最終日で番号28を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            28,
          );
        });

        test("2枚目の1日目で連続番号29を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            29,
          );
        });

        test("2枚目の28日目で連続番号56を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-30"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-26"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
              pageIndex: 1,
              pillNumberInPillSheet: 28,
            ),
            56,
          );
        });

        test("3枚目の1日目で連続番号57を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-26"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet3 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 2,
            beginingDate: DateTime.parse("2020-10-27"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
            pillSheets: [pillSheet1, pillSheet2, pillSheet3],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
              pageIndex: 2,
              pillNumberInPillSheet: 1,
            ),
            57,
          );
        });
      });
    });

    group("PillSheetAppearanceMode.cyclicSequential の場合", () {
      group("ピルシートが1つの場合", () {
        test("連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 15,
            ),
            15,
          );
        });
      });

      group("ピルシートが複数の場合", () {
        test("2枚目の1日目で連続番号29を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            29,
          );
        });
      });

      group("displayNumberSettingがある場合", () {
        test("beginPillNumberが設定されていると開始番号がずれる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 5,
            ),
          );

          // 1番目のピルは開始番号5
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            5,
          );
          // 10番目のピルは番号14（5 + 9）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 10,
            ),
            14,
          );
        });

        test("endPillNumberが設定されていると終了番号で1に戻る", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              endPillNumber: 28,
            ),
          );

          // 1枚目の28番目は28（境界値）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            28,
          );
          // 2枚目の1番目は1（28を超えると1に戻る）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            1,
          );
        });

        test("beginPillNumber と endPillNumber の両方が設定されている場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 5,
              endPillNumber: 28,
            ),
          );

          // 1枚目の1番目は5（開始番号）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            5,
          );
          // 1枚目の24番目は28（5 + 23 = 28、endPillNumber）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 24,
            ),
            28,
          );
          // 1枚目の25番目は1（28を超えると1に戻る）
          // NOTE: endPillNumberを超えた場合は1に戻る実装。beginPillNumberには戻らない
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              pageIndex: 0,
              pillNumberInPillSheet: 25,
            ),
            1,
          );
        });
      });
    });

    group("pillSheetAppearanceMode引数がPillSheetGroupのモードと異なる場合", () {
      test("引数で指定したモードで計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // PillSheetGroupはnumberモードだが
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 引数でcyclicSequentialを指定すると連続番号が返る
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          29,
        );

        // 引数でnumberを指定するとピルシート内番号が返る
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          1,
        );
      });
    });
  });

  group("#displayPillNumberOrDate", () {
    group("PillSheetAppearanceMode.number の場合", () {
      group("ピルシートが1つの場合", () {
        test("pillNumberInPillSheet をそのまま文字列で返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // premiumOrTrial は number モードでは影響しない
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "1",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: false,
              pageIndex: 0,
              pillNumberInPillSheet: 15,
            ),
            "15",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
        });
      });

      group("ピルシートが複数の場合", () {
        test("各ページで pillNumberInPillSheet をそのまま返す（pageIndex は無視される）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 1枚目の28番目（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
          // 2枚目の1番目（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            "1",
          );
        });
      });
    });

    group("PillSheetAppearanceMode.date の場合", () {
      group("premiumOrTrial == true の場合", () {
        test("日付を文字列で返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          );

          // 1番目 = 2020-09-01 → "9/1"
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "9/1",
          );
          // 14番目 = 2020-09-14 → "9/14"
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 14,
            ),
            "9/14",
          );
          // 28番目 = 2020-09-28 → "9/28"
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "9/28",
          );
        });

        group("ピルシートが複数の場合", () {
          test("各ページで正しい日付を返す（境界値）", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

            const sheetType = PillSheetType.pillsheet_28_0;
            final pillSheet1 = PillSheet(
              id: firestoreIDGenerator(),
              groupIndex: 0,
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              createdAt: now(),
              typeInfo: PillSheetTypeInfo(
                dosingPeriod: sheetType.dosingPeriod,
                name: sheetType.fullName,
                totalCount: sheetType.totalCount,
                pillSheetTypeReferencePath: sheetType.rawPath,
              ),
            );
            final pillSheet2 = PillSheet(
              id: firestoreIDGenerator(),
              groupIndex: 1,
              beginingDate: DateTime.parse("2020-09-29"),
              lastTakenDate: null,
              createdAt: now(),
              typeInfo: PillSheetTypeInfo(
                dosingPeriod: sheetType.dosingPeriod,
                name: sheetType.fullName,
                totalCount: sheetType.totalCount,
                pillSheetTypeReferencePath: sheetType.rawPath,
              ),
            );
            final pillSheetGroup = PillSheetGroup(
              pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
              pillSheets: [pillSheet1, pillSheet2],
              createdAt: now(),
              pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            );

            // 1枚目の28番目 = 2020-09-28 → "9/28"（境界値）
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 0,
                pillNumberInPillSheet: 28,
              ),
              "9/28",
            );
            // 2枚目の1番目 = 2020-09-29 → "9/29"（境界値）
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 1,
                pillNumberInPillSheet: 1,
              ),
              "9/29",
            );
            // 2枚目の28番目 = 2020-10-26 → "10/26"
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 1,
                pillNumberInPillSheet: 28,
              ),
              "10/26",
            );
          });
        });

        group("服用お休み期間がある場合", () {
          test("休薬期間を考慮した日付を返す", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

            const sheetType = PillSheetType.pillsheet_28_0;
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              groupIndex: 0,
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-10"),
              createdAt: now(),
              typeInfo: PillSheetTypeInfo(
                dosingPeriod: sheetType.dosingPeriod,
                name: sheetType.fullName,
                totalCount: sheetType.totalCount,
                pillSheetTypeReferencePath: sheetType.rawPath,
              ),
              restDurations: [
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-11"),
                  createdDate: DateTime.parse("2020-09-11"),
                  endDate: DateTime.parse("2020-09-13"),
                ),
              ],
            );
            final pillSheetGroup = PillSheetGroup(
              pillSheetIDs: ["sheet_id"],
              pillSheets: [pillSheet],
              createdAt: now(),
              pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            );

            // 1番目 = 2020-09-01 → "9/1"
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 0,
                pillNumberInPillSheet: 1,
              ),
              "9/1",
            );
            // 10番目 = 2020-09-10 → "9/10"（休薬開始前日）
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 0,
                pillNumberInPillSheet: 10,
              ),
              "9/10",
            );
            // 11番目 = 2020-09-11 + 2日(休薬期間) = 2020-09-13 → "9/13"
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 0,
                pillNumberInPillSheet: 11,
              ),
              "9/13",
            );
            // 28番目 = 2020-09-28 + 2日(休薬期間) = 2020-09-30 → "9/30"
            expect(
              pillSheetGroup.displayPillNumberOrDate(
                premiumOrTrial: true,
                pageIndex: 0,
                pillNumberInPillSheet: 28,
              ),
              "9/30",
            );
          });
        });
      });

      group("premiumOrTrial == false の場合", () {
        test("pillNumberInPillSheet をそのまま文字列で返す（日付ではない）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          );

          // premiumOrTrial == false の場合、number モードと同じ動作
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: false,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "1",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: false,
              pageIndex: 0,
              pillNumberInPillSheet: 14,
            ),
            "14",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: false,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
        });
      });
    });

    group("PillSheetAppearanceMode.sequential の場合", () {
      group("ピルシートが1つの場合", () {
        test("連続番号を文字列で返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // premiumOrTrial は sequential モードでは影響しない
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "1",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: false,
              pageIndex: 0,
              pillNumberInPillSheet: 15,
            ),
            "15",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
        });
      });

      group("ピルシートが複数の場合", () {
        test("連続番号を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // 1枚目の28番目（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
          // 2枚目の1番目 = 連続番号29（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            "29",
          );
          // 2枚目の28番目 = 連続番号56
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 1,
              pillNumberInPillSheet: 28,
            ),
            "56",
          );
        });
      });

      group("displayNumberSetting がある場合", () {
        test("beginPillNumber が設定されている場合、その番号から開始する", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 10,
            ),
          );

          // 1番目 = 開始番号10
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "10",
          );
          // 2番目 = 11
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 2,
            ),
            "11",
          );
          // 28番目 = 37
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "37",
          );
        });

        test("endPillNumber が設定されている場合、その番号を超えると1に戻る", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              endPillNumber: 24,
            ),
          );

          // 24番目 = 24（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 24,
            ),
            "24",
          );
          // 25番目 = 1（24を超えると1に戻る）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 25,
            ),
            "1",
          );
          // 28番目 = 4
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "4",
          );
        });
      });

      group("服用お休み期間がある場合", () {
        test("休薬期間終了後は1番から再開する", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-13"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );

          // 10番目 = 10（休薬開始前日）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 10,
            ),
            "10",
          );
          // 11番目 = 1（休薬期間終了後は1から再開）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 11,
            ),
            "1",
          );
          // 12番目 = 2
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 12,
            ),
            "2",
          );
        });
      });
    });

    group("PillSheetAppearanceMode.cyclicSequential の場合", () {
      group("ピルシートが1つの場合", () {
        test("連続番号を文字列で返す（sequential と同じ動作）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "1",
          );
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: false,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
        });
      });

      group("ピルシートが複数の場合", () {
        test("連続番号を返す（境界値）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 1,
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet3 = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 2,
            beginingDate: DateTime.parse("2020-10-27"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
            pillSheets: [pillSheet1, pillSheet2, pillSheet3],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          // 1枚目の28番目（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 28,
            ),
            "28",
          );
          // 2枚目の1番目 = 連続番号29（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 1,
              pillNumberInPillSheet: 1,
            ),
            "29",
          );
          // 2枚目の28番目 = 連続番号56（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 1,
              pillNumberInPillSheet: 28,
            ),
            "56",
          );
          // 3枚目の1番目 = 連続番号57（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 2,
              pillNumberInPillSheet: 1,
            ),
            "57",
          );
          // 3枚目の28番目 = 連続番号84
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 2,
              pillNumberInPillSheet: 28,
            ),
            "84",
          );
        });
      });

      group("displayNumberSetting がある場合", () {
        test("beginPillNumber と endPillNumber の両方が設定されている場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            groupIndex: 0,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 5,
              endPillNumber: 28,
            ),
          );

          // 1番目 = 開始番号5
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 1,
            ),
            "5",
          );
          // 24番目 = 28（境界値）
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 24,
            ),
            "28",
          );
          // 25番目 = 1（28を超えると1に戻る）
          // NOTE: endPillNumberを超えた場合は1に戻る実装。beginPillNumberには戻らない
          expect(
            pillSheetGroup.displayPillNumberOrDate(
              premiumOrTrial: true,
              pageIndex: 0,
              pillNumberInPillSheet: 25,
            ),
            "1",
          );
        });
      });
    });

    group("異なる PillSheetType の場合", () {
      test("pillsheet_21（21錠+休薬7日）の場合も正しく動作する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
        );

        // 21番目 = 2020-09-21 → "9/21"（実薬最後）
        expect(
          pillSheetGroup.displayPillNumberOrDate(
            premiumOrTrial: true,
            pageIndex: 0,
            pillNumberInPillSheet: 21,
          ),
          "9/21",
        );
        // 28番目 = 2020-09-28 → "9/28"（休薬期間最後）
        expect(
          pillSheetGroup.displayPillNumberOrDate(
            premiumOrTrial: true,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          "9/28",
        );
      });

      test("pillsheet_24_0（24錠タイプ）の場合も正しく動作する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );

        // 1番目
        expect(
          pillSheetGroup.displayPillNumberOrDate(
            premiumOrTrial: true,
            pageIndex: 0,
            pillNumberInPillSheet: 1,
          ),
          "1",
        );
        // 24番目（totalCount）
        expect(
          pillSheetGroup.displayPillNumberOrDate(
            premiumOrTrial: true,
            pageIndex: 0,
            pillNumberInPillSheet: 24,
          ),
          "24",
        );
      });
    });
  });

  group("#lastActiveRestDuration", () {
    group("ピルシートが1つの場合", () {
      test("RestDuration がない場合は null を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, isNull);
      });

      test("終了済みの RestDuration のみの場合は null を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-20"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-10"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, isNull);
      });

      test("active な RestDuration がある場合はその RestDuration を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final activeRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-10"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-10"),
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration);
      });
    });

    group("境界値テスト（today() との関係）", () {
      test("beginDate が today() と同じ日の場合は active として扱う", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final activeRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-14"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-14"),
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-13"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration);
      });

      test("beginDate が today() より1日後の場合は null を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final futureRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-15"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-14"),
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [futureRestDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, isNull);
      });
    });

    group("ピルシートが複数の場合", () {
      test("1枚目に active な RestDuration がある場合は 1枚目の RestDuration を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final activeRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-10"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-10"),
        );
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration);
      });

      test("2枚目に active な RestDuration がある場合は 2枚目の RestDuration を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final activeRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-10-01"),
          endDate: null,
          createdDate: DateTime.parse("2020-10-01"),
        );
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-09-30"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration);
      });

      test("両方の枚目に active な RestDuration がある場合は 最初に見つかった 1枚目の RestDuration を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final activeRestDuration1 = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-10"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-10"),
        );
        final activeRestDuration2 = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-12"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-12"),
        );
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-09"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration1],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-09-11"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration2],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration1);
      });

      test("どちらにも active な RestDuration がない場合は null を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-20"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, isNull);
      });

      test("1枚目が終了済み、2枚目が active の場合は 2枚目の RestDuration を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final completedRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-10"),
          endDate: DateTime.parse("2020-09-15"),
          createdDate: DateTime.parse("2020-09-10"),
        );
        final activeRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-10-01"),
          endDate: null,
          createdDate: DateTime.parse("2020-10-01"),
        );
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [completedRestDuration],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-09-30"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [activeRestDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration);
      });
    });

    group("複数の RestDuration が同一ピルシートにある場合", () {
      test("最後の RestDuration が active の場合はそれを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final completedRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-10"),
          endDate: DateTime.parse("2020-09-15"),
          createdDate: DateTime.parse("2020-09-10"),
        );
        final activeRestDuration = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-20"),
          endDate: null,
          createdDate: DateTime.parse("2020-09-20"),
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-19"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [completedRestDuration, activeRestDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, activeRestDuration);
      });

      test("すべて終了済みの場合は null を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final completedRestDuration1 = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-10"),
          endDate: DateTime.parse("2020-09-12"),
          createdDate: DateTime.parse("2020-09-10"),
        );
        final completedRestDuration2 = RestDuration(
          id: firestoreIDGenerator(),
          beginDate: DateTime.parse("2020-09-15"),
          endDate: DateTime.parse("2020-09-18"),
          createdDate: DateTime.parse("2020-09-15"),
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-25"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [completedRestDuration1, completedRestDuration2],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, isNull);
      });
    });
  });

  group("#targetBeginRestDurationPillSheet", () {
    group("ピルシートが1つの場合", () {
      test("まだ1錠も服用していない場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet);
      });

      test("途中まで服用している場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet);
      });

      test("境界値: totalCount-1錠目まで服用している場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21はtotalCount=28
        // 27錠目まで服用(2020-09-01から27日後=2020-09-27)
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-27"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet);
      });

      test("全て服用完了の場合は次のピルシートがないため例外が発生する", () {
        // この場合 pillSheets[groupIndex + 1] へのアクセスで RangeError が発生する
        // 呼び出し側で事前にチェックする必要がある
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21はtotalCount=28
        // 28錠目まで服用(2020-09-01から28日後=2020-09-28)
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(() => pillSheetGroup.targetBeginRestDurationPillSheet, throwsA(isA<RangeError>()));
      });
    });

    group("ピルシートが複数の場合", () {
      test("1枚目がまだ服用中（未完了）の場合は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet1);
      });

      test("1枚目が全て服用完了の場合は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21はtotalCount=28
        // 28錠目まで服用(2020-09-01から28日後=2020-09-28)
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet2);
      });

      test("2枚目がまだ服用中（未完了）の場合は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-05"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet2);
      });

      test("2枚目も全て服用完了の場合で3枚目がある場合は3枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet3);
      });

      test("最後のピルシートが全て服用完了の場合は例外が発生する", () {
        // pillSheets[groupIndex + 1] へのアクセスで RangeError が発生する
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(() => pillSheetGroup.targetBeginRestDurationPillSheet, throwsA(isA<RangeError>()));
      });
    });

    group("境界値テスト（服用完了判定）", () {
      test("pillsheet_28タイプで27錠目まで服用（未完了境界）の場合は現在のシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_28はtotalCount=28で全て実錠
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-27"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-27"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet1);
      });

      test("pillsheet_28タイプで28錠目まで服用（完了境界）の場合は次のシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_28はtotalCount=28で全て実錠
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet2);
      });

      test("pillsheet_24タイプで23錠目まで服用（未完了境界）の場合は現在のシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_24_4はtotalCount=28 (24錠 + 偽薬4錠)
        // 23日目まで服用
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-27"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-27"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet1);
      });
    });

    group("服用お休み期間がある場合", () {
      test("服用お休み期間中でも、まだ全錠服用完了していなければ現在のシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: null,
            ),
          ],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet1);
      });

      test("服用お休み期間が過去にあっても、全錠服用完了していれば次のシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          // pillsheet_21はtotalCount=28、28日目=2020-09-28に全錠服用完了
          // 但し、服用お休みによりシート期間は延長されている
          lastTakenDate: DateTime.parse("2020-10-01"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-10-02"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.targetBeginRestDurationPillSheet, pillSheet2);
      });
    });
  });

  group("#availableRestDurationBeginDate", () {
    group("ピルシートが1つの場合", () {
      test("まだ1錠も服用していない場合はtoday()を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final todayDate = DateTime.parse("2020-09-01");
        when(mockTodayRepository.now()).thenReturn(todayDate);

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, todayDate);
      });

      test("途中まで服用している場合はlastTakenDateの翌日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final lastTakenDate = DateTime.parse("2020-09-14");
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: lastTakenDate,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate.addDays(1));
      });

      test("全錠服用完了の場合は次のピルシートがないため例外が発生する", () {
        // targetBeginRestDurationPillSheet で pillSheets[groupIndex + 1] へのアクセスで RangeError が発生する
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(() => pillSheetGroup.availableRestDurationBeginDate, throwsA(isA<RangeError>()));
      });
    });

    group("ピルシートが複数の場合", () {
      test("1枚目がまだ服用開始していない場合はtoday()を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final todayDate = DateTime.parse("2020-09-01");
        when(mockTodayRepository.now()).thenReturn(todayDate);

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, todayDate);
      });

      test("1枚目が途中まで服用している場合はlastTakenDateの翌日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final lastTakenDate = DateTime.parse("2020-09-14");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: lastTakenDate,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate.addDays(1));
      });

      test("1枚目が全て服用完了、2枚目がまだ服用開始していない場合はtoday()を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final todayDate = DateTime.parse("2020-09-29");
        when(mockTodayRepository.now()).thenReturn(todayDate);

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, todayDate);
      });

      test("1枚目が全て服用完了、2枚目が途中まで服用している場合はlastTakenDateの翌日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final lastTakenDate = DateTime.parse("2020-10-10");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: lastTakenDate,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate.addDays(1));
      });

      test("最後のピルシートが全て服用完了の場合は例外が発生する", () {
        // targetBeginRestDurationPillSheet で pillSheets[groupIndex + 1] へのアクセスで RangeError が発生する
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(() => pillSheetGroup.availableRestDurationBeginDate, throwsA(isA<RangeError>()));
      });
    });

    group("境界値テスト", () {
      test("pillsheet_28タイプで27錠目まで服用（未完了境界）の場合はlastTakenDateの翌日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-27"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 27錠目 = beginingDate + 26日 = 2020-09-27
        final lastTakenDate = DateTime.parse("2020-09-27");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: lastTakenDate,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate.addDays(1));
      });

      test("pillsheet_28タイプで28錠目まで服用（完了境界）の場合は2枚目の状態に応じた値を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final todayDate = DateTime.parse("2020-09-29");
        when(mockTodayRepository.now()).thenReturn(todayDate);

        const sheetType = PillSheetType.pillsheet_28_0;
        // 28錠目 = beginingDate + 27日 = 2020-09-28
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 2枚目がまだ服用開始していない場合
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, todayDate);
      });

      test("pillsheet_21タイプで20錠目まで服用（未完了境界）の場合はlastTakenDateの翌日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_21;
        // 20錠目 = beginingDate + 19日 = 2020-09-20
        final lastTakenDate = DateTime.parse("2020-09-20");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: lastTakenDate,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate.addDays(1));
      });

      test("pillsheet_24タイプで24錠目まで服用（完了境界）の場合は2枚目のlastTakenDateに依存する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_24_rest_4;
        // 28錠目（24+4休薬） = beginingDate + 27日 = 2020-09-28
        final lastTakenDate2 = DateTime.parse("2020-10-05");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: lastTakenDate2,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate2.addDays(1));
      });
    });

    group("服用お休み期間がある場合", () {
      test("服用お休み期間中でも、まだ全錠服用完了していなければlastTakenDateの翌日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final lastTakenDate = DateTime.parse("2020-09-14");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: lastTakenDate,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate.addDays(1));
      });

      test("服用お休み期間が過去にあっても、全錠服用完了していれば2枚目の状態に依存する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final lastTakenDate2 = DateTime.parse("2020-10-05");
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          // 服用お休み期間があるので、元々の28錠目より後ろにずれる
          lastTakenDate: DateTime.parse("2020-09-30"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-10-01"),
          lastTakenDate: lastTakenDate2,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.availableRestDurationBeginDate, lastTakenDate2.addDays(1));
      });
    });
  });
}
