import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/datetime/date_add.dart';
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
  });

  group("#activePillSheet", () {
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
    test("指定した日付でアクティブなピルシートを取得できる", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

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

      // 1枚目の期間内
      expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-10")), pillSheet1);
      // 2枚目の期間内
      expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-10")), pillSheet2);
      // 期間外
      expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-08-01")), isNull);
    });
  });

  group("#lastTakenPillNumberWithoutDate", () {
    group("ピルシートが一つの場合", () {
      group("服用お休み期間を持つ場合", () {
        group("複数の服用お休み期間を持つ場合", () {});
      });
    });
    group("has two pill sheets", () {});
  });

  group("#sequentialLastTakenPillNumber", () {
    group("has one pill sheet", () {
      test("it is not taken yet", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: null,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          createdAt: now(),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });
      group("pillsheet has rest durations", () {
        test("rest duration is ended and not yet taken pill", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-23"),
                createdDate: DateTime.parse("2020-09-23"),
                endDate: DateTime.parse("2020-09-25"),
              ),
            ],
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
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
        });

        group("pillsheet has plural rest durations", () {});
      });
      group("has two pill sheets", () {});
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
      test("服薬お休み期間がある場合", () {
        // まだ書いてない。必要になったら書く
      });
      test("服薬お休み期間がある。ただし、終了はしていない", () {
        // まだ書いてない。必要になったら書く
      });
    });
  });
}
