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

      // NOTE: sequentialモードはtoday()に対応する番号を返す（実装の仕様）
      // cyclicSequentialモードはlastTakenDateに対応する番号を返す
      group("sequentialモードの場合", () {
        test("today()に対応する連続番号を返す", () {
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
          // 今日は2020-09-10、beginingDateは2020-09-01なので10番目
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 10);
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
          });
        });
      }
    });
  });
}
