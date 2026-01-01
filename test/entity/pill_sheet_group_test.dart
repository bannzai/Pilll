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
    // activePillSheet は activePillSheetWhen(now()) のラッパー
    // activePillSheetWhen は pillSheets.where((element) => element.isActiveFor(date)).first を返す
    // 複数のピルシートがアクティブな場合は最初のもの(firstを使用)を返す

    group("ピルシートが1枚の場合", () {
      test("開始日当日はアクティブなピルシートを返す", () {
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
        expect(pillSheetGroup.activePillSheet, pillSheet);
      });
      test("終了日当日(21日目)はアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 9/21が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

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
        expect(pillSheetGroup.activePillSheet, pillSheet);
      });
      test("開始日前日はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

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
        expect(pillSheetGroup.activePillSheet, null);
      });
      test("終了日翌日(22日目)はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 9/21が最終日 → 9/22は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

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
        expect(pillSheetGroup.activePillSheet, null);
      });
      test("28錠ピルシートの終了日当日(28日目)はアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_28_0: totalCount=28, 9/1開始 → 9/28が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

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
        expect(pillSheetGroup.activePillSheet, pillSheet);
      });
    });

    group("ピルシートが1枚で休薬期間がある場合", () {
      test("終了した休薬期間により延長された終了日当日はアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 2日間の休薬期間 → 9/23が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-23"));

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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
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
      test("継続中の休薬期間がある場合、休薬期間中はアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 継続中の休薬期間（9/10開始、終了日なし）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

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

    group("ピルシートが複数枚の場合", () {
      test("1枚目の期間内は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("2枚目の期間内は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("1枚目の終了日(28日目)は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("2枚目の開始日は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("全てのピルシートがアクティブでない場合はnullを返す（開始前）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
        expect(pillSheetGroup.activePillSheet, null);
      });
      test("全てのピルシートがアクティブでない場合はnullを返す（終了後）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
        expect(pillSheetGroup.activePillSheet, null);
      });
    });

    group("ピルシートが3枚の場合の境界値テスト", () {
      test("2枚目の終了日は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        // 3枚目: 10/27開始 → 11/23終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
          id: "sheet_id_3",
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
        expect(pillSheetGroup.activePillSheet, pillSheet2);
      });
      test("3枚目の開始日は3枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        // 3枚目: 10/27開始 → 11/23終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
          id: "sheet_id_3",
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
    });
  });

  group("#isDeactived", () {
    // isDeactived は activePillSheet == null || _isDeleted で判定される
    // _isDeleted は deletedAt != null で判定される

    group("deletedAt が null の場合", () {
      group("activePillSheet が存在する場合", () {
        test("ピルシート期間内の場合は false を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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
            deletedAt: null,
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.isDeactived, false);
        });
        test("開始日当日の場合は false を返す", () {
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
            deletedAt: null,
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.isDeactived, false);
        });
        test("終了日当日（21日目）の場合は false を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          // pillsheet_21: totalCount=21, 9/1開始 → 9/21が最終日
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

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
            deletedAt: null,
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.isDeactived, false);
        });
      });

      group("activePillSheet が null の場合", () {
        test("開始日前日の場合は true を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

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
            deletedAt: null,
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.isDeactived, true);
        });
        test("終了日翌日（22日目）の場合は true を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          // pillsheet_21: totalCount=21, 9/1開始 → 9/21が最終日 → 9/22は非アクティブ
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

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
            deletedAt: null,
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.isDeactived, true);
        });
      });
    });

    group("deletedAt が設定されている場合（論理削除済み）", () {
      test("activePillSheet が存在する場合でも true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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
          deletedAt: DateTime.parse("2020-09-10"),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.isDeactived, true);
      });
      test("activePillSheet が null の場合も true を返す（両条件を満たす）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

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
          deletedAt: DateTime.parse("2020-09-10"),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.isDeactived, true);
      });
    });

    group("複数ピルシートの場合", () {
      test("1枚目が終了し2枚目がアクティブな場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("全てのピルシートが終了した場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始 → 10/26終了（28錠）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("1枚目の終了日と2枚目の開始日の境界: 1枚目終了日（28日目）は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
      test("1枚目の終了日と2枚目の開始日の境界: 2枚目開始日（29日目）は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1開始 → 9/28終了（28錠）
        // 2枚目: 9/29開始
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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

    group("休薬期間がある場合", () {
      test("休薬期間中もアクティブであれば false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: 9/1開始、休薬期間継続中
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

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
      test("終了した休薬期間により延長された終了日内は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: 9/1開始 → 通常9/21が最終日
        // 2日間の休薬期間 → 9/23が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-23"));

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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
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
      test("終了した休薬期間により延長された終了日の翌日は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: 9/1開始 → 通常9/21が最終日
        // 2日間の休薬期間 → 9/23が最終日 → 9/24は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
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

  group("#activePillSheetWhen", () {
    // activePillSheetWhen は日付を引数で受け取り、その日付でアクティブなピルシートを返す
    // activePillSheet の汎用版。履歴表示や過去データの参照で使用される

    group("ピルシートが1枚の場合", () {
      test("開始日を指定するとアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-01")), pillSheet);
      });
      test("終了日を指定するとアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-21")), pillSheet);
      });
      test("開始日前日を指定するとnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-08-31")), null);
      });
      test("終了日翌日を指定するとnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-22")), null);
      });
    });

    group("ピルシートが複数枚の場合", () {
      test("1枚目の期間の日付を指定すると1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-15")), pillSheet1);
      });
      test("2枚目の期間の日付を指定すると2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
    });

    group("activePillSheetとの整合性テスト", () {
      test("activePillSheetWhen(now()) と activePillSheet は同じ結果を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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
        expect(pillSheetGroup.activePillSheetWhen(now()), pillSheetGroup.activePillSheet);
      });
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
