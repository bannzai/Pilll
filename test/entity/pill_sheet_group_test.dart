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

  group("#lastTakenPillSheetOrFirstPillSheet", () {
    // lastTakenPillSheetOrFirstPillSheet は最後に服用したピルシートを返す
    // pillSheetsを逆順で走査し、lastTakenDateがnullでないピルシートを見つけたら返す
    // 見つからなければ最初のピルシート(pillSheets[0])を返す
    // このgetterはPillSheetAppearanceMode, PillSheetType, RestDuration, PillSheetGroupDisplayNumberSettingの影響を受けない

    group("ピルシートが1枚の場合", () {
      test("服用履歴がない場合は最初のピルシートを返す", () {
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
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 0);
      });

      test("服用履歴がある場合はそのピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
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
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 0);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.lastTakenDate, DateTime.parse("2020-09-10"));
      });
    });

    group("ピルシートが2枚の場合", () {
      test("全て服用履歴がない場合は最初のピルシートを返す", () {
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
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
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
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 0);
      });

      test("1枚目のみ服用履歴がある場合は1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
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
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 0);
      });

      test("2枚目のみ服用履歴がある場合は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

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
          beginingDate: DateTime.parse("2020-09-22"),
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
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet2);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 1);
      });

      test("両方に服用履歴がある場合は2枚目を返す（逆順で最初に見つかる）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
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
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet2);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 1);
      });
    });

    group("ピルシートが3枚の場合（境界値テスト）", () {
      test("1枚目と3枚目に服用履歴がある場合は3枚目を返す（逆順で探すため）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
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
          beginingDate: DateTime.parse("2020-10-13"),
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
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet3);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 2);
      });

      test("2枚目のみ服用履歴がある場合は2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

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
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: DateTime.parse("2020-10-01"),
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
          beginingDate: DateTime.parse("2020-10-13"),
          lastTakenDate: null,
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
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet2);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 1);
      });

      test("全て服用履歴がある場合は3枚目を返す（逆順で最初に見つかる）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: DateTime.parse("2020-10-12"),
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
          beginingDate: DateTime.parse("2020-10-13"),
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
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet, pillSheet3);
        expect(pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex, 2);
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

    group("ピルシートが1枚で休薬期間がある場合", () {
      test("終了した休薬期間により延長された終了日を指定するとアクティブなピルシートを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 2日間の休薬期間（9/5-9/7） → 9/23が最終日
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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-23")), pillSheet);
      });

      test("休薬期間延長後の終了日翌日を指定するとnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 2日間の休薬期間（9/5-9/7） → 9/23が最終日 → 9/24は非アクティブ
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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-24")), null);
      });

      test("継続中の休薬期間がある場合、休薬期間中の日付を指定するとアクティブなピルシートを返す", () {
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
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-25")), pillSheet);
      });
    });

    group("ピルシートが3枚の場合の境界値テスト", () {
      // 1枚目: 9/1開始 → 9/28終了（28錠）
      // 2枚目: 9/29開始 → 10/26終了（28錠）
      // 3枚目: 10/27開始 → 11/23終了（28錠）
      PillSheet createPillSheet(int groupIndex, DateTime beginingDate, PillSheetType sheetType) {
        return PillSheet(
          id: "sheet_id_${groupIndex + 1}",
          groupIndex: groupIndex,
          beginingDate: beginingDate,
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
      }

      test("1枚目の終了日(9/28)を指定すると1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = createPillSheet(0, DateTime.parse("2020-09-01"), sheetType);
        final pillSheet2 = createPillSheet(1, DateTime.parse("2020-09-29"), sheetType);
        final pillSheet3 = createPillSheet(2, DateTime.parse("2020-10-27"), sheetType);
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-28")), pillSheet1);
      });

      test("2枚目の開始日(9/29)を指定すると2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = createPillSheet(0, DateTime.parse("2020-09-01"), sheetType);
        final pillSheet2 = createPillSheet(1, DateTime.parse("2020-09-29"), sheetType);
        final pillSheet3 = createPillSheet(2, DateTime.parse("2020-10-27"), sheetType);
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-29")), pillSheet2);
      });

      test("2枚目の終了日(10/26)を指定すると2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = createPillSheet(0, DateTime.parse("2020-09-01"), sheetType);
        final pillSheet2 = createPillSheet(1, DateTime.parse("2020-09-29"), sheetType);
        final pillSheet3 = createPillSheet(2, DateTime.parse("2020-10-27"), sheetType);
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-26")), pillSheet2);
      });

      test("3枚目の開始日(10/27)を指定すると3枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = createPillSheet(0, DateTime.parse("2020-09-01"), sheetType);
        final pillSheet2 = createPillSheet(1, DateTime.parse("2020-09-29"), sheetType);
        final pillSheet3 = createPillSheet(2, DateTime.parse("2020-10-27"), sheetType);
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-27")), pillSheet3);
      });

      test("3枚目の終了日(11/23)を指定すると3枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-23"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = createPillSheet(0, DateTime.parse("2020-09-01"), sheetType);
        final pillSheet2 = createPillSheet(1, DateTime.parse("2020-09-29"), sheetType);
        final pillSheet3 = createPillSheet(2, DateTime.parse("2020-10-27"), sheetType);
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-11-23")), pillSheet3);
      });

      test("3枚目の終了日翌日(11/24)を指定するとnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-24"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = createPillSheet(0, DateTime.parse("2020-09-01"), sheetType);
        final pillSheet2 = createPillSheet(1, DateTime.parse("2020-09-29"), sheetType);
        final pillSheet3 = createPillSheet(2, DateTime.parse("2020-10-27"), sheetType);
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2", "sheet_id_3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-11-24")), null);
      });
    });

    group("異なるPillSheetTypeの組み合わせの場合", () {
      // 21錠と28錠の組み合わせ
      // 1枚目: 9/1開始 → 9/21終了（21錠）
      // 2枚目: 9/22開始 → 10/19終了（28錠）
      test("21錠シートの終了日(9/21)を指定すると1枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: "sheet_id_2",
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-21")), pillSheet1);
      });

      test("28錠シートの開始日(9/22)を指定すると2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: "sheet_id_2",
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-22")), pillSheet2);
      });

      test("28錠シートの終了日(10/19)を指定すると2枚目を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-19"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: "sheet_id_2",
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-19")), pillSheet2);
      });

      test("28錠シートの終了日翌日(10/20)を指定するとnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: "sheet_id_2",
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-10-20")), null);
      });
    });

    group("ピルシートが空の場合", () {
      test("pillSheetsが空配列の場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: [],
          pillSheets: [],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.activePillSheetWhen(DateTime.parse("2020-09-15")), null);
      });
    });
  });

  group("#lastTakenPillNumberWithoutDate", () {
    group("服用履歴がない場合", () {
      test("ピルシートが1枚でlastTakenDateがnullの場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, null);
      });

      test("ピルシートが複数枚でどれも服用履歴がない場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

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
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.lastTakenPillNumberWithoutDate, null);
      });
    });

    group("ピルシートが1枚の場合", () {
      group("PillSheetAppearanceModeごとのテスト", () {
        test("number モードの場合はピルシート内の番号をそのまま返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          // 9/1開始で9/10が最終服用日 → 10番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 10);
        });

        test("date モードの場合はピルシート内の番号をそのまま返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet = PillSheet(
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          );
          // 9/1開始で9/15が最終服用日 → 15番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 15);
        });

        test("sequential モードの場合は連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          );
          // 9/1開始で9/10が最終服用日 → 連続番号も10
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 10);
        });

        test("cyclicSequential モードの場合は連続番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
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
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // 9/1開始で9/20が最終服用日 → 連続番号も20
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 20);
        });
      });

      group("境界値テスト", () {
        test("1番目のピルを服用した場合は1を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

          const sheetType = PillSheetType.pillsheet_28_0;
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 1);
        });

        test("最後のピル(28番目)を服用した場合は28を返す", () {
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
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });
      });
    });

    group("ピルシートが複数枚の場合", () {
      group("逆順で走査するため最後のピルシートの服用履歴が優先される", () {
        test("2枚目のみに服用履歴がある場合は2枚目の番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

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
            lastTakenDate: DateTime.parse("2020-10-01"),
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
          // 2枚目: 9/29開始で10/1が最終服用日 → 3番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 3);
        });

        test("両方に服用履歴がある場合は2枚目の番号を返す（逆順で最初に見つかる）", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

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
          // 2枚目: 9/29開始で10/5が最終服用日 → 7番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 7);
        });

        test("1枚目のみに服用履歴がある場合は1枚目の番号を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
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
          // 1枚目: 9/1開始で9/20が最終服用日 → 20番目
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 20);
        });
      });

      group("境界値テスト", () {
        test("1枚目の最後のピル(28番目)を服用した場合 - number モード", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

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
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });

        test("2枚目の最初のピル(1番目)を服用した場合 - number モード", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

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
          // numberモードではピルシート内の番号をそのまま返す → 1
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 1);
        });

        test("1枚目の最後のピル(28番目)を服用した場合 - cyclicSequential モード", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

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
          // cyclicSequentialモードでは連続番号 → 28
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });

        test("2枚目の最初のピル(1番目)を服用した場合 - cyclicSequential モード", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

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
          // cyclicSequentialモードでは連続番号 → 28 + 1 = 29
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 29);
        });
      });
    });

    group("PillSheetGroupDisplayNumberSettingの影響", () {
      group("cyclicSequential モードの場合", () {
        test("beginPillNumberが設定されている場合は開始番号から始まる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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
          // 開始番号5で9/1開始、9/10が最終服用日 → 5 + 9 = 14
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 14);
        });

        test("endPillNumberが設定されていて超えた場合は1から始まる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

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
          // endPillNumber=28なので、1枚目の28番目は28
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 28);
        });

        test("endPillNumberを超えた後の番号は1から始まる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

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
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              endPillNumber: 28,
            ),
          );
          // endPillNumber=28を超えると1から。2枚目の9/29は1番、10/5は7番
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 7);
        });
      });
    });

    group("RestDurationの影響", () {
      group("cyclicSequential モードの場合", () {
        test("服用お休み期間終了後は1番から始まる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
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
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-08"),
                createdDate: DateTime.parse("2020-09-08"),
                endDate: DateTime.parse("2020-09-15"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          // 9/1から開始、9/8-9/14が休み、9/15に再開(1番から)
          // 9/20は再開後6日目なので6番
          expect(pillSheetGroup.lastTakenPillNumberWithoutDate, 6);
        });
      });
    });
  });

  group("#sequentialLastTakenPillNumber", () {
    group("PillSheetAppearanceModeごとのテスト", () {
      test("number モードの場合は lastTakenDate があっても 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });

      test("date モードの場合は lastTakenDate があっても 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });

      // NOTE: sequentialモードの実装では today() を使用しているため、
      // lastTakenDateではなく今日の日付に対応する番号を返す
      test("sequential モードの場合は今日の連続番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
        // 9/1開始、9/10は10日目を返す (today() を使用するため)
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 10);
      });

      test("cyclicSequential モードの場合は最後に服用した日の連続番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
        // 9/1開始、lastTakenDate=9/5なので5を返す
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 5);
      });
    });

    group("lastTakenDate が null の場合", () {
      test("activePillSheet の lastTakenDate が null の場合は 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });

      test("activePillSheet が null の場合は 0 を返す（ピルシート範囲外）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 9/1開始、28錠シート → 9/28が最終日 → 9/29は範囲外
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });
    });

    group("1枚のピルシートの場合（cyclicSequentialモード）", () {
      test("開始日に服用した場合は 1 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_28_0;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 1);
      });

      test("途中の日に服用した場合はその日の番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 9/1開始、9/15は15日目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 15);
      });

      test("終了日に服用した場合は totalCount を返す", () {
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 28);
      });
    });

    group("複数枚のピルシートの場合（cyclicSequentialモード）", () {
      test("1枚目の最終日に服用した場合は 28 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 28);
      });

      test("2枚目の開始日に服用した場合は 29 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 29);
      });

      test("2枚目の最終日に服用した場合は 56 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-26"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 56);
      });

      test("3枚目の開始日に服用した場合は 57 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-27"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
          id: "sheet_id_3",
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
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 57);
      });
    });

    group("DisplayNumberSetting がある場合（cyclicSequentialモード）", () {
      test("beginPillNumber が設定されている場合は開始番号から始まる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
          ),
        );
        // 開始番号10から始まり、5日目なので10+4=14を返す
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 14);
      });

      test("endPillNumber が設定されている場合は終了番号でリセットされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_28_0;
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
        // 1-21番で周期、22日目以降は1番からリセット
        // 25日目は 25 - 21 = 4番目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 4);
      });

      test("beginPillNumber と endPillNumber の両方が設定されている場合", () {
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 5,
            endPillNumber: 28,
          ),
        );
        // 開始番号5、終了番号28
        // 1日目=5, 2日目=6, ... 24日目=28, 25日目=1, 26日目=2, 27日目=3, 28日目=4
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 4);
      });
    });

    group("RestDuration がある場合（cyclicSequentialモード）", () {
      test("服用お休み期間終了後は1から再開される", () {
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 9/1開始
        // 9/22まで: 1-22番
        // 9/23-9/24: 服用お休み期間（23,24番はスキップ扱い）
        // 9/25: 服用お休み終了日（endDate）= 1番から再開
        // 9/26=2, 9/27=3, 9/28=4
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 4);
      });

      test("服用お休み期間中は番号がそのまま続く", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
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
        // 服用お休み期間中でendDateがnullの場合は番号がそのまま続く
        // 9/24は24日目
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 24);
      });

      test("複数の服用お休み期間がある場合", () {
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
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-08"),
              createdDate: DateTime.parse("2020-09-08"),
              endDate: DateTime.parse("2020-09-10"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 9/1開始
        // 9/1-9/7: 1-7番
        // 9/8-9/9: 服用お休み（8,9番）
        // 9/10: 1番から再開
        // 9/11-9/19: 2-10番
        // 9/20-9/21: 服用お休み（11,12番）
        // 9/22: 1番から再開
        // 9/23=2, 9/24=3, 9/25=4, 9/26=5, 9/27=6, 9/28=7
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 7);
      });
    });
  });

  group("#sequentialEstimatedEndPillNumber", () {
    // sequentialEstimatedEndPillNumber は pillSheetAppearanceMode に応じて
    // number/date モードでは 0 を返し、
    // sequential/cyclicSequential モードでは pillNumbersForCyclicSequential.last.number を返す

    group("PillSheetAppearanceModeごとのテスト", () {
      test("number モードの場合は 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 0);
      });

      test("date モードの場合は 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 0);
      });

      test("sequential モードの場合はピルシートの最終番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        // 28錠のピルシートなので28が最終番号
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("cyclicSequential モードの場合はピルシートの最終番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });
    });

    group("1枚のピルシートの場合（cyclicSequentialモード）", () {
      test("21錠ピルシートの場合は 21 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 21);
      });

      test("28錠ピルシートの場合は 28 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("24錠ピルシート(pillsheet_24_0)の場合は 24 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 24);
      });
    });

    group("複数枚のピルシートの場合（cyclicSequentialモード）", () {
      test("28錠ピルシート2枚の場合は 56 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 28 + 28 = 56
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 56);
      });

      test("28錠ピルシート3枚の場合は 84 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 28 + 28 + 28 = 84
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 84);
      });

      test("21錠ピルシート2枚の場合は 42 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_21;
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
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
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
        // 21 + 21 = 42
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 42);
      });

      test("異なる種類のピルシート（21錠と28錠）の場合は合計 49 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType1 = PillSheetType.pillsheet_21;
        const sheetType2 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
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
          id: "sheet_id_2",
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        // 21 + 28 = 49
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 49);
      });
    });

    group("DisplayNumberSetting がある場合（cyclicSequentialモード）", () {
      test("beginPillNumber が設定されている場合、最終番号に反映される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
            beginPillNumber: 10,
          ),
        );
        // 開始番号が10なので、10 + 27 = 37 が最終番号
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 37);
      });

      test("endPillNumber が設定されている場合、周期的に1に戻るため終了番号が変わる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            endPillNumber: 28,
          ),
        );
        // endPillNumber=28で周期が設定されている
        // 1枚目: 1-28
        // 2枚目: 1-28（28を超えたら1に戻る）
        // 最終番号は28
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("beginPillNumber と endPillNumber の両方が設定されている場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 10,
            endPillNumber: 30,
          ),
        );
        // 開始番号10、終了番号30の設定
        // 1枚目: 10-30（21個）, 31以降は1に戻るので 1-7（残り7個、合計28個）
        // 2枚目: 8-28（21個）, 29-30（2個）, 1-5（5個、合計28個）
        // 最終番号は5
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 5);
      });

      test("endPillNumber が 1枚のピルシートの錠数より小さい場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
            endPillNumber: 21,
          ),
        );
        // endPillNumber=21で周期が設定されている
        // 1-21, 22以降は1に戻る → 1-7（合計28錠）
        // 最終番号は7
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 7);
      });
    });

    group("RestDuration がある場合（cyclicSequentialモード）", () {
      test("服用お休み期間終了後は1から再開されるため、最終番号が変わる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
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
        // 9/1開始
        // 9/1-9/14: 1-14番
        // 9/15-9/16: 休薬期間（15,16番）
        // 9/17: 休薬終了日 = 1番から再開
        // 9/18-28日目: 2-12番
        // 最終番号は12
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 12);
      });

      test("継続中の服用お休み期間がある場合、最終番号は通常通り", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
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
        // 継続中の休薬期間がある場合、endDateがnullなので1に戻らない
        // 最終番号は28のまま
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 28);
      });

      test("複数の服用お休み期間がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-08"),
              createdDate: DateTime.parse("2020-09-08"),
              endDate: DateTime.parse("2020-09-10"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-18"),
              createdDate: DateTime.parse("2020-09-18"),
              endDate: DateTime.parse("2020-09-20"),
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
        // 9/1開始
        // 9/1-9/7: 1-7番
        // 9/8-9/9: 休薬期間（8,9番）
        // 9/10: 1番から再開
        // 9/11-9/17: 2-8番
        // 9/18-9/19: 休薬期間（9,10番）
        // 9/20: 1番から再開
        // 9/21-9/28: 2-9番
        // 最終番号は9
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 9);
      });
    });

    group("複数ピルシートの境界値テスト（cyclicSequentialモード）", () {
      test("1枚目の最終番号と2枚目の開始番号の関係", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        // pillNumbersForCyclicSequential を使って境界値を検証
        final pillNumbers = pillSheetGroup.pillNumbersForCyclicSequential;

        // 1枚目の最終番号は28
        final lastOfSheet1 = pillNumbers.where((e) => e.pillSheet.groupIndex == 0).last;
        expect(lastOfSheet1.number, 28);

        // 2枚目の開始番号は29
        final firstOfSheet2 = pillNumbers.where((e) => e.pillSheet.groupIndex == 1).first;
        expect(firstOfSheet2.number, 29);

        // 全体の最終番号は56
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 56);
      });

      test("2枚目の最終番号と3枚目の開始番号の関係", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        final pillNumbers = pillSheetGroup.pillNumbersForCyclicSequential;

        // 2枚目の最終番号は56
        final lastOfSheet2 = pillNumbers.where((e) => e.pillSheet.groupIndex == 1).last;
        expect(lastOfSheet2.number, 56);

        // 3枚目の開始番号は57
        final firstOfSheet3 = pillNumbers.where((e) => e.pillSheet.groupIndex == 2).first;
        expect(firstOfSheet3.number, 57);

        // 全体の最終番号は84
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 84);
      });
    });

    group("RestDuration と DisplayNumberSetting の組み合わせ", () {
      test("endPillNumber と 服用お休み期間の両方がある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
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
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            endPillNumber: 21,
          ),
        );
        // 9/1開始、endPillNumber=21
        // 9/1-9/14: 1-14番
        // 9/15-9/16: 休薬期間（15,16番）
        // 9/17: 休薬終了日 = 1番から再開
        // 9/18-9/23: 2-7番（endPillNumberより前に休薬リセットが発生するのでendPillNumber超過しない）
        // 9/24-9/28: 8-12番
        // 最終番号は12
        expect(pillSheetGroup.sequentialEstimatedEndPillNumber, 12);
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
      test("pillNumberForFromMenstruation == 0 かつ durationMenstruation > 0 の場合は空配列", () {
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 0,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
      test("pillNumberForFromMenstruation > 0 かつ durationMenstruation == 0 の場合は空配列", () {
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 24,
          durationMenstruation: 0,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), []);
      });
      test("pillNumberForFromMenstruation == 1（最小値）の場合", () {
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
        // 1日目から開始して3日間
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-01"), DateTime.parse("2020-09-03"))]);
      });
      test("pillNumberForFromMenstruation == totalCount（境界値）の場合", () {
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          // pillsheet_21 の totalCount は 28
          pillNumberForFromMenstruation: 28,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 28日目から開始して3日間（28日目はピルシートの最終日、生理期間は次のシートにまたがる）
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-28"), DateTime.parse("2020-09-30"))]);
      });
      test("durationMenstruation == 1（最小値）の場合", () {
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 1,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 22日目の1日間のみ
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-22"), DateTime.parse("2020-09-22"))]);
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

    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_28_0（28錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_28_0;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 25,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-25"), DateTime.parse("2020-09-27"))]);
      });
      test("pillsheet_24_0（24錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_24_0;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // pillsheet_24_0 の totalCount は 24
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-22"), DateTime.parse("2020-09-24"))]);
      });
      test("pillsheet_24_rest_4（24錠+休薬4日）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_24_rest_4;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 25,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // pillsheet_24_rest_4 の totalCount は 28
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [DateRange(DateTime.parse("2020-09-25"), DateTime.parse("2020-09-27"))]);
      });
    });

    group("異なるPillSheetTypeの組み合わせ（複数枚）の場合", () {
      test("1枚目pillsheet_28_0と2枚目pillsheet_24_0の組み合わせ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType1 = PillSheetType.pillsheet_28_0;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
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
          // 1枚目28錠の後
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28)),
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
          pillSheetIDs: ["1", "2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 22,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // 1枚目: 22日目から開始 (2020-09-22〜2020-09-24)
        // 2枚目: 22日目から開始 (2020-10-20〜2020-10-22)
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-09-22"), DateTime.parse("2020-09-24")),
          DateRange(DateTime.parse("2020-10-20"), DateTime.parse("2020-10-22")),
        ]);
      });
    });

    group("ヤーズフレックス的な使い方（pillNumberForFromMenstruation > 各ピルシートのtotalCount）", () {
      // コメントに書いてある例:
      // 28錠タイプが4枚ある場合で46番ごとに生理期間がくる設定をしていると生理期間の始まりが
      //   1枚目: なし
      //   2枚目: 18番から
      //   3枚目: なし
      //   4枚目: 8番から
      test("28錠タイプ4枚で46番ごとに生理の場合", () {
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
        final pillSheet4 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 3,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 3)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3", "4"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3, pillSheet4],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 46,
          durationMenstruation: 3,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // グループ合計: 28*4=112錠
        // 46番ごと: 46番, 92番
        // 46番: 1枚目(1-28)にはなし、2枚目(29-56)の18番目
        //   2枚目beginingDate = 2020-09-29
        //   displayPillTakeDate(18) = 2020-09-29 + 17日 = 2020-10-16
        // 92番: 3枚目(57-84)にはなし、4枚目(85-112)の8番目
        //   4枚目beginingDate = 2020-09-01 + 84日 = 2020-11-24
        //   displayPillTakeDate(8) = 2020-11-24 + 7日 = 2020-12-01
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-10-16"), DateTime.parse("2020-10-18")),
          DateRange(DateTime.parse("2020-12-01"), DateTime.parse("2020-12-03")),
        ]);
      });
      test("120日連続服用（21錠+休薬7日を4枚、84番ごとに生理）の場合", () {
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
        final pillSheet4 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 3,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 * 3)),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1", "2", "3", "4"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3, pillSheet4],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        const setting = Setting(
          pillNumberForFromMenstruation: 84,
          durationMenstruation: 4,
          isOnReminder: false,
          timezoneDatabaseName: "Asia/Tokyo",
        );
        // グループ合計: 28*4=112錠
        // 84番ごと: 84番
        // 84番: 3枚目(57-84)の28番目 → 2020-10-27 + 27日 = 2020-11-23
        expect(pillSheetGroup.menstruationDateRanges(setting: setting), [
          DateRange(DateTime.parse("2020-11-23"), DateTime.parse("2020-11-26")),
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
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 1枚目: 9/1開始、9/15に休薬開始、9/17に休薬終了
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
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        // 2枚目: 1枚目の28錠分+休薬2日分後に開始
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-01").add(const Duration(days: 28 + 2)),
          lastTakenDate: null,
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
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 1-14, 1-14 (休薬後リセット)
        // 2枚目: 15-42
        expect(result, [
          // 1枚目: 1番から14番まで、休薬後に1番から始まる
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
          // 休薬終了(9/17)でリセット
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
          // 2枚目: 15番から42番まで
          15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
        ]);
      });
      test("服薬お休み期間がある。ただし、終了はしていない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 1枚目: 9/1開始、9/15に休薬開始、終了未定
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
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: null,
            ),
          ],
        );
        // 2枚目: 1枚目の28錠分後に開始（休薬終了してないので日付がずれる）
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 休薬終了してない場合はリセットされない
        expect(result, [
          // 1枚目: 1番から28番まで（リセットなし）
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          // 2枚目: 29番から56番まで
          29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56,
        ]);
      });
      test("2枚目のピルシートにRestDurationがある場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 1枚目: 9/1開始、休薬なし
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
        // 2枚目: 9/29開始、10/10に休薬開始、10/12に休薬終了
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
              beginDate: DateTime.parse("2020-10-10"),
              createdDate: DateTime.parse("2020-10-10"),
              endDate: DateTime.parse("2020-10-12"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 1-28、2枚目: 29-40, 1-16（休薬後リセット）
        expect(result, [
          // 1枚目: 1番から28番まで
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          // 2枚目: 29番から40番まで（10/10が2枚目の12日目=40番）
          29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
          // 休薬終了(10/12)でリセット、残り16日分
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
        ]);
      });
      test("displayNumberSettingがある場合（beginPillNumberのみ）", () {
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
          beginingDate: DateTime.parse("2020-09-14").add(const Duration(days: 28)),
          lastTakenDate: null,
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
            beginPillNumber: 5,
          ),
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 開始番号が5の場合、5から始まる連続番号
        expect(result, [
          // 1枚目: 5番から32番まで
          5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
          // 2枚目: 33番から60番まで
          33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
        ]);
      });
      test("displayNumberSettingがある場合（endPillNumberのみ）", () {
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
          beginingDate: DateTime.parse("2020-09-14").add(const Duration(days: 28)),
          lastTakenDate: null,
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
            endPillNumber: 28,
          ),
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 終了番号が28の場合、28を超えたら1にリセット
        expect(result, [
          // 1枚目: 1番から28番まで
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          // 2枚目: 1番から28番まで（リセット）
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
        ]);
      });
      test("displayNumberSettingがある場合（beginPillNumberとendPillNumberの両方）", () {
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
          beginingDate: DateTime.parse("2020-09-14").add(const Duration(days: 28)),
          lastTakenDate: null,
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
            beginPillNumber: 5,
            endPillNumber: 24,
          ),
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 開始番号5、終了番号24の場合
        // 1枚目: 5-24, 1-8（24を超えてリセット）
        // 2枚目: 9-24, 1-12（24を超えてリセット）
        expect(result, [
          // 1枚目: 5番から24番まで（20個）、その後リセットして1番から8番まで（8個）= 計28個
          5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
          1, 2, 3, 4, 5, 6, 7, 8,
          // 2枚目: 前のシートの続きで9番から24番まで（16個）、その後リセットして1番から12番まで（12個）= 計28個
          9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
        ]);
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
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        expect(result.length, 84);
        expect(result.first, 1);
        expect(result.last, 84);
        // 1枚目最終番号
        expect(result[27], 28);
        // 2枚目開始番号
        expect(result[28], 29);
        // 2枚目最終番号
        expect(result[55], 56);
        // 3枚目開始番号
        expect(result[56], 57);
      });
      test("2枚目にRestDurationがある場合、休薬終了後に番号がリセットされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-30"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 1枚目: 9/1開始、休薬なし
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
        // 2枚目: 9/29開始、10/10に休薬開始、10/12に休薬終了
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
              beginDate: DateTime.parse("2020-10-10"),
              createdDate: DateTime.parse("2020-10-10"),
              endDate: DateTime.parse("2020-10-12"),
            ),
          ],
        );
        // 3枚目: 10/29開始（2枚目28日 + 休薬2日）
        final pillSheet3 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 2,
          beginingDate: DateTime.parse("2020-10-29"),
          lastTakenDate: null,
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
        final result = pillSheetGroup.pillNumbersForCyclicSequential;
        final numberList = result.map((e) => e.number).toList();

        // 1枚目: 1-28
        expect(numberList.sublist(0, 28), [
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
        // 2枚目: 29-40, 1-16（休薬後リセット）
        // 2枚目は9/29開始、10/10が12日目=40番
        expect(numberList.sublist(28, 56), [
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
        ]);
        // 3枚目: 17-44
        expect(numberList.sublist(56, 84), [
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
        ]);

        // 境界値: 1枚目最後と2枚目最初
        expect(result[27].number, 28);
        expect(result[28].number, 29);
        // 境界値: 2枚目の休薬前と休薬後
        expect(result[39].number, 40); // 休薬開始日
        expect(result[40].number, 1); // 休薬終了日（リセット）
        // 境界値: 2枚目最後と3枚目最初
        expect(result[55].number, 16);
        expect(result[56].number, 17);
      });
    });
    group("ピルシート間の境界値テスト", () {
      test("1枚目の最終番号と2枚目の開始番号が連続している", () {
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
        final result = pillSheetGroup.pillNumbersForCyclicSequential;
        // 1枚目の最終
        final lastOfSheet1 = result.where((e) => e.pillSheet.groupIndex == 0).last;
        expect(lastOfSheet1.number, 28);
        expect(lastOfSheet1.date, DateTime.parse("2020-09-28"));
        // 2枚目の開始
        final firstOfSheet2 = result.where((e) => e.pillSheet.groupIndex == 1).first;
        expect(firstOfSheet2.number, 29);
        expect(firstOfSheet2.date, DateTime.parse("2020-09-29"));
        // 番号が連続している
        expect(firstOfSheet2.number - lastOfSheet1.number, 1);
      });
      test("2枚目の最終番号と3枚目の開始番号が連続している", () {
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
        final result = pillSheetGroup.pillNumbersForCyclicSequential;
        // 2枚目の最終
        final lastOfSheet2 = result.where((e) => e.pillSheet.groupIndex == 1).last;
        expect(lastOfSheet2.number, 56);
        expect(lastOfSheet2.date, DateTime.parse("2020-10-26"));
        // 3枚目の開始
        final firstOfSheet3 = result.where((e) => e.pillSheet.groupIndex == 2).first;
        expect(firstOfSheet3.number, 57);
        expect(firstOfSheet3.date, DateTime.parse("2020-10-27"));
        // 番号が連続している
        expect(firstOfSheet3.number - lastOfSheet2.number, 1);
      });
    });
    group("異なるPillSheetTypeの組み合わせ", () {
      test("21錠タイプと28錠タイプが混在する場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

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
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 21錠 (1-21)、2枚目: 28錠 (22-49)
        expect(result.length, 49);
        expect(result.first, 1);
        expect(result[20], 21); // 1枚目最終
        expect(result[21], 22); // 2枚目開始
        expect(result.last, 49);
      });
      test("28_4錠タイプと21錠タイプが混在する場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType28_4 = PillSheetType.pillsheet_28_4;
        const sheetType21 = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28_4.dosingPeriod,
            name: sheetType28_4.fullName,
            totalCount: sheetType28_4.totalCount,
            pillSheetTypeReferencePath: sheetType28_4.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential.map((e) => e.number).toList();
        // 1枚目: 28錠 (1-28)、2枚目: 21錠 (29-49)
        expect(result.length, 49);
        expect(result.first, 1);
        expect(result[27], 28); // 1枚目最終
        expect(result[28], 29); // 2枚目開始
        expect(result.last, 49);
      });
    });
    group("日付情報の妥当性", () {
      test("ピルシートが1つの場合、日付が開始日から連続している", () {
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
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential;
        expect(result.first.date, DateTime.parse("2020-09-01"));
        expect(result.last.date, DateTime.parse("2020-09-28"));
        // 日付が連続していることを確認
        for (var i = 0; i < result.length - 1; i++) {
          expect(result[i + 1].date.difference(result[i].date).inDays, 1);
        }
      });
      test("ピルシートが2つの場合、日付がシートをまたいで連続している", () {
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
        final result = pillSheetGroup.pillNumbersForCyclicSequential;
        // 1枚目の最終日付と2枚目の開始日付が連続
        final lastOfSheet1 = result.where((e) => e.pillSheet.groupIndex == 0).last;
        final firstOfSheet2 = result.where((e) => e.pillSheet.groupIndex == 1).first;
        expect(firstOfSheet2.date.difference(lastOfSheet1.date).inDays, 1);
      });
      test("RestDurationがある場合、休薬期間分日付がずれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 休薬期間: 9/5-9/7 (2日間)
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        final result = pillSheetGroup.pillNumbersForCyclicSequential;
        // 開始日は変わらない
        expect(result.first.date, DateTime.parse("2020-09-01"));
        // 休薬期間(2日間)分終了日がずれる
        expect(result.last.date, DateTime.parse("2020-09-30"));
      });
    });
  });

  group("#sequentialTodayPillNumber", () {
    group("PillSheetAppearanceModeごとのテスト", () {
      test("number モードの場合は 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialTodayPillNumber, 0);
      });

      test("date モードの場合は 0 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        expect(pillSheetGroup.sequentialTodayPillNumber, 0);
      });

      test("sequential モードの場合は今日の連続番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        // 9/1開始、9/5は5日目
        expect(pillSheetGroup.sequentialTodayPillNumber, 5);
      });

      test("cyclicSequential モードの場合は今日の連続番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        // 9/1開始、9/5は5日目
        expect(pillSheetGroup.sequentialTodayPillNumber, 5);
      });
    });

    group("1枚のピルシートの場合", () {
      test("開始日当日は 1 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

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
        expect(pillSheetGroup.sequentialTodayPillNumber, 1);
      });

      test("終了日当日は totalCount を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 9/1開始、28錠シート → 9/28が最終日
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 28);
      });

      test("開始日前日は 0 を返す（今日がピルシート範囲外）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

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
        expect(pillSheetGroup.sequentialTodayPillNumber, 0);
      });

      test("終了日翌日は 0 を返す（今日がピルシート範囲外）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 9/1開始、28錠シート → 9/28が最終日 → 9/29は範囲外
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

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
        expect(pillSheetGroup.sequentialTodayPillNumber, 0);
      });
    });

    group("複数枚のピルシートの場合", () {
      test("1枚目の最終日は 28 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 28);
      });

      test("2枚目の開始日は 29 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 29);
      });

      test("2枚目の最終日は 56 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1-9/28 (28錠)
        // 2枚目: 9/29-10/26 (28錠)
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 56);
      });

      test("3枚目の開始日は 57 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 1枚目: 9/1-9/28 (28錠)
        // 2枚目: 9/29-10/26 (28錠)
        // 3枚目: 10/27開始
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 57);
      });
    });

    group("displayNumberSetting がある場合", () {
      test("beginPillNumber が設定されている場合、開始日はその番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

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
        expect(pillSheetGroup.sequentialTodayPillNumber, 10);
      });

      test("beginPillNumber が10の場合、5日目は 14 を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-05"));

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
        // 10 + 4 = 14 (5日目は開始日から4日後)
        expect(pillSheetGroup.sequentialTodayPillNumber, 14);
      });

      test("endPillNumber を超えた場合は 1 にリセットされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 28日目 → 次は1にリセット (endPillNumber=28)
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            endPillNumber: 28,
          ),
        );
        // 29日目は endPillNumber(28) を超えるので 1 にリセット
        expect(pillSheetGroup.sequentialTodayPillNumber, 1);
      });

      test("beginPillNumber と endPillNumber 両方が設定されている場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始番号10、終了番号37 → 28日後（38になるはずだが）は1にリセット
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 10,
            endPillNumber: 37,
          ),
        );
        // 開始日9/1は10、28日目(9/28)は37、29日目(9/29)は38>37なので1にリセット
        expect(pillSheetGroup.sequentialTodayPillNumber, 1);
      });
    });

    group("RestDuration がある場合", () {
      test("終了した RestDuration の翌日は 1 にリセットされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間: 9/5-9/7 → 9/7終了日の翌日ではなく、endDate当日に番号が1にリセット
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-07"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        // 9/7はRestDurationのendDate → 1にリセット
        expect(pillSheetGroup.sequentialTodayPillNumber, 1);
      });

      test("終了した RestDuration の翌日以降は 1 からカウントが続く", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間: 9/5-9/7 → 9/8は2日目
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-08"));

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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        // 9/7が1にリセット → 9/8は2
        expect(pillSheetGroup.sequentialTodayPillNumber, 2);
      });

      test("休薬期間中は休薬期間開始日のピル番号を返す（日付がずれるため）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間: 9/5開始、終了未定
        // buildDates で 9/5のピル(番号5)が9/6に移動するため、9/6を検索すると番号5が返る
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-06"));

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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: null,
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );
        // buildDatesの計算:
        // - dates[0-3] = 9/1-9/4 (番号1-4)
        // - dates[4] = 9/5 → 休薬期間で9/6にずれる (番号5)
        // - dates[5] = 9/7 (番号6)
        // 9/6を検索すると番号5のピルが対応する
        expect(pillSheetGroup.sequentialTodayPillNumber, 5);
      });
    });
  });

  group("#pillNumbersInPillSheet", () {
    // pillNumbersInPillSheet は各ピルシートごとに 1 から始まる番号を返す
    // pillNumbersForCyclicSequential とは異なり、ピルシート間で番号が連続しない
    // number/date モードで使用される

    group("ピルシートが1つの場合", () {
      test("服用お休み期間がない場合、番号は 1 から totalCount まで", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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

        final result = pillSheetGroup.pillNumbersInPillSheet;
        expect(result.length, 28);
        expect(result.map((e) => e.number).toList(), [
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
        // 日付も確認（休薬期間なしなので連続した日付）
        expect(result.first.date, DateTime.parse("2020-09-01"));
        expect(result.last.date, DateTime.parse("2020-09-28"));
      });

      test("21錠タイプの場合、番号は 1 から 21 まで", () {
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

        final result = pillSheetGroup.pillNumbersInPillSheet;
        expect(result.length, 21);
        expect(result.map((e) => e.number).toList(), [
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
        ]);
        expect(result.first.date, DateTime.parse("2020-09-01"));
        expect(result.last.date, DateTime.parse("2020-09-21"));
      });

      group("服用お休み期間がある場合", () {
        test("終了した休薬期間がある場合、番号はそのまま、日付がずれる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

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
                // 9/5-9/7の2日間休薬
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

          final result = pillSheetGroup.pillNumbersInPillSheet;
          // 番号は変わらない
          expect(result.length, 28);
          expect(result.map((e) => e.number).toList(), [
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
          // 日付は休薬期間分ずれる
          // 1-4番は9/1-9/4
          expect(result[0].date, DateTime.parse("2020-09-01"));
          expect(result[3].date, DateTime.parse("2020-09-04"));
          // 5番は9/5だが、休薬期間で9/7にずれる
          expect(result[4].date, DateTime.parse("2020-09-07"));
          // 28番は9/28+2日=9/30
          expect(result.last.date, DateTime.parse("2020-09-30"));
        });

        test("継続中の休薬期間がある場合、today() を上限として日付が計算される", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          // 今日は9/10。休薬期間は9/5開始で終了未定
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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
                beginDate: DateTime.parse("2020-09-05"),
                createdDate: DateTime.parse("2020-09-05"),
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

          final result = pillSheetGroup.pillNumbersInPillSheet;
          expect(result.length, 28);
          // 番号は変わらない
          expect(result.map((e) => e.number).toList(), [
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
          // 1-4番は9/1-9/4
          expect(result[0].date, DateTime.parse("2020-09-01"));
          expect(result[3].date, DateTime.parse("2020-09-04"));
          // 5番は9/5だが、休薬期間で9/10(today)にずれる（休薬期間5日分）
          expect(result[4].date, DateTime.parse("2020-09-10"));
        });

        test("複数の休薬期間がある場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

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
              // 1回目: 9/5-9/7 (2日間)
              RestDuration(
                id: "rest_duration_id_1",
                beginDate: DateTime.parse("2020-09-05"),
                createdDate: DateTime.parse("2020-09-05"),
                endDate: DateTime.parse("2020-09-07"),
              ),
              // 2回目: 9/15-9/18 (3日間、ただしずれて実際は9/17-9/20)
              RestDuration(
                id: "rest_duration_id_2",
                beginDate: DateTime.parse("2020-09-17"),
                createdDate: DateTime.parse("2020-09-17"),
                endDate: DateTime.parse("2020-09-20"),
              ),
            ],
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          final result = pillSheetGroup.pillNumbersInPillSheet;
          expect(result.length, 28);
          // 番号は変わらない
          expect(result.map((e) => e.number).toList(), [
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
          // 開始日
          expect(result.first.date, DateTime.parse("2020-09-01"));
          // 28番は9/28 + 2日(1回目) + 3日(2回目) = 10/3
          expect(result.last.date, DateTime.parse("2020-10-03"));
        });
      });
    });

    group("ピルシートが2つの場合", () {
      test("各ピルシートの番号は独立して 1 から始まる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final result = pillSheetGroup.pillNumbersInPillSheet;
        // 28 + 28 = 56
        expect(result.length, 56);
        // 番号は各シートで 1 から始まる（pillNumbersForCyclicSequential と異なる点）
        expect(result.map((e) => e.number).toList(), [
          // 1枚目: 1-28
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          // 2枚目: 1-28（リセット）
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
        ]);
      });

      test("境界値: 1枚目の最後(28番)と2枚目の最初(1番)の確認", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final result = pillSheetGroup.pillNumbersInPillSheet;

        // 1枚目の最後
        expect(result[27].number, 28);
        expect(result[27].date, DateTime.parse("2020-09-28"));
        expect(result[27].pillSheet.id, "sheet_id_1");

        // 2枚目の最初
        expect(result[28].number, 1);
        expect(result[28].date, DateTime.parse("2020-09-29"));
        expect(result[28].pillSheet.id, "sheet_id_2");
      });

      test("異なる錠数のピルシート（21錠と28錠）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-19"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: "sheet_id_1",
          groupIndex: 0,
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: "sheet_id_2",
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final result = pillSheetGroup.pillNumbersInPillSheet;
        // 21 + 28 = 49
        expect(result.length, 49);

        // 1枚目: 1-21
        expect(result.sublist(0, 21).map((e) => e.number).toList(), [
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
        ]);

        // 2枚目: 1-28（リセット）
        expect(result.sublist(21).map((e) => e.number).toList(), [
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

        // 境界値: 1枚目の最後と2枚目の最初
        expect(result[20].number, 21);
        expect(result[20].date, DateTime.parse("2020-09-21"));
        expect(result[21].number, 1);
        expect(result[21].date, DateTime.parse("2020-09-22"));
      });

      test("1枚目にRestDurationがある場合、1枚目の日付がずれるが2枚目は影響を受けない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-30"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 1枚目: 9/1開始、9/5-9/7に休薬（2日間）
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
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
          ],
        );
        // 2枚目: 1枚目28日 + 休薬2日 = 10/1開始
        final pillSheet2 = PillSheet(
          id: "sheet_id_2",
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-10-01"),
          lastTakenDate: null,
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

        final result = pillSheetGroup.pillNumbersInPillSheet;
        expect(result.length, 56);

        // 番号は各シートで1からリセットされる（pillNumbersInPillSheetの仕様）
        expect(result.map((e) => e.number).toList(), [
          // 1枚目: 1-28
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          // 2枚目: 1-28（リセット）
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
        ]);

        // 1枚目の日付確認（休薬で2日ずれる）
        expect(result[0].date, DateTime.parse("2020-09-01")); // 1番
        expect(result[3].date, DateTime.parse("2020-09-04")); // 4番
        expect(result[4].date, DateTime.parse("2020-09-07")); // 5番（休薬後）
        expect(result[27].date, DateTime.parse("2020-09-30")); // 28番（9/28+2日）

        // 境界値: 1枚目最後と2枚目最初の日付
        expect(result[27].number, 28);
        expect(result[27].date, DateTime.parse("2020-09-30"));
        expect(result[27].pillSheet.id, "sheet_id_1");
        expect(result[28].number, 1);
        expect(result[28].date, DateTime.parse("2020-10-01"));
        expect(result[28].pillSheet.id, "sheet_id_2");
      });

      test("2枚目にRestDurationがある場合、2枚目の日付がずれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-31"));

        const sheetType = PillSheetType.pillsheet_28_0;
        // 1枚目: 9/1開始、休薬なし
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
        // 2枚目: 9/29開始、10/5-10/8に休薬（3日間）
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
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-10-05"),
              createdDate: DateTime.parse("2020-10-05"),
              endDate: DateTime.parse("2020-10-08"),
            ),
          ],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final result = pillSheetGroup.pillNumbersInPillSheet;
        expect(result.length, 56);

        // 番号は各シートで1からリセットされる
        expect(result.map((e) => e.number).toList(), [
          // 1枚目: 1-28
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
          // 2枚目: 1-28（リセット）
          1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
        ]);

        // 1枚目の日付確認（休薬なしなので連続）
        expect(result[0].date, DateTime.parse("2020-09-01"));
        expect(result[27].date, DateTime.parse("2020-09-28"));

        // 2枚目の日付確認（休薬で3日ずれる）
        expect(result[28].date, DateTime.parse("2020-09-29")); // 2枚目1番
        expect(result[33].date, DateTime.parse("2020-10-04")); // 2枚目6番（休薬前）
        // 2枚目7番以降は休薬期間(10/5-10/8)で3日ずれる
        expect(result[34].date, DateTime.parse("2020-10-08")); // 2枚目7番（休薬後）
        expect(result[55].date, DateTime.parse("2020-10-29")); // 28番（10/26+3日）
      });
    });

    group("ピルシートが3つの場合", () {
      test("各シートの境界値（最後と最初）の確認", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-23"));

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

        final result = pillSheetGroup.pillNumbersInPillSheet;
        // 28 * 3 = 84
        expect(result.length, 84);

        // 1枚目の最後と2枚目の最初
        expect(result[27].number, 28);
        expect(result[27].pillSheet.id, "sheet_id_1");
        expect(result[28].number, 1);
        expect(result[28].pillSheet.id, "sheet_id_2");

        // 2枚目の最後と3枚目の最初
        expect(result[55].number, 28);
        expect(result[55].pillSheet.id, "sheet_id_2");
        expect(result[56].number, 1);
        expect(result[56].pillSheet.id, "sheet_id_3");

        // 3枚目の最後
        expect(result[83].number, 28);
        expect(result[83].pillSheet.id, "sheet_id_3");
      });
    });

    group("pillSheet 参照の確認", () {
      test("各要素が正しい pillSheet を参照している", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final result = pillSheetGroup.pillNumbersInPillSheet;

        // 1枚目のすべての要素が pillSheet1 を参照
        for (int i = 0; i < 28; i++) {
          expect(result[i].pillSheet.id, "sheet_id_1");
        }

        // 2枚目のすべての要素が pillSheet2 を参照
        for (int i = 28; i < 56; i++) {
          expect(result[i].pillSheet.id, "sheet_id_2");
        }
      });
    });
  });

  group("#replaced", () {
    // replaced は指定されたピルシートでグループ内容を更新する
    // 同一IDのピルシートを新しいデータで置き換える

    group("正常系: ピルシートを置き換える", () {
      group("ピルシートが1枚の場合", () {
        test("1枚目のピルシートを置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final originalPillSheet = PillSheet(
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1"],
            pillSheets: [originalPillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // lastTakenDateを更新したピルシートで置き換え
          final updatedPillSheet = originalPillSheet.copyWith(
            lastTakenDate: DateTime.parse("2020-09-10"),
          );

          final result = pillSheetGroup.replaced(updatedPillSheet);

          expect(result.pillSheets.length, 1);
          expect(result.pillSheets[0].id, "sheet_id_1");
          expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-10"));
          // 元のpillSheetGroupは変更されていないことを確認（イミュータブル）
          expect(pillSheetGroup.pillSheets[0].lastTakenDate, null);
        });
      });

      group("ピルシートが2枚の場合", () {
        test("1枚目のピルシートを置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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

          final updatedPillSheet1 = pillSheet1.copyWith(
            lastTakenDate: DateTime.parse("2020-09-10"),
          );

          final result = pillSheetGroup.replaced(updatedPillSheet1);

          expect(result.pillSheets.length, 2);
          // 1枚目が更新されている
          expect(result.pillSheets[0].id, "sheet_id_1");
          expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-10"));
          // 2枚目は変更されていない
          expect(result.pillSheets[1].id, "sheet_id_2");
          expect(result.pillSheets[1].lastTakenDate, null);
        });

        test("2枚目のピルシートを置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: "sheet_id_1",
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

          final updatedPillSheet2 = pillSheet2.copyWith(
            lastTakenDate: DateTime.parse("2020-10-05"),
          );

          final result = pillSheetGroup.replaced(updatedPillSheet2);

          expect(result.pillSheets.length, 2);
          // 1枚目は変更されていない
          expect(result.pillSheets[0].id, "sheet_id_1");
          expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-28"));
          // 2枚目が更新されている
          expect(result.pillSheets[1].id, "sheet_id_2");
          expect(result.pillSheets[1].lastTakenDate, DateTime.parse("2020-10-05"));
        });
      });

      group("ピルシートが3枚の場合", () {
        test("1枚目のピルシートを置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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

          final updatedPillSheet1 = pillSheet1.copyWith(
            lastTakenDate: DateTime.parse("2020-09-10"),
          );

          final result = pillSheetGroup.replaced(updatedPillSheet1);

          expect(result.pillSheets.length, 3);
          expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-10"));
          expect(result.pillSheets[1].lastTakenDate, null);
          expect(result.pillSheets[2].lastTakenDate, null);
        });

        test("2枚目のピルシートを置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: "sheet_id_1",
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

          final updatedPillSheet2 = pillSheet2.copyWith(
            lastTakenDate: DateTime.parse("2020-10-05"),
          );

          final result = pillSheetGroup.replaced(updatedPillSheet2);

          expect(result.pillSheets.length, 3);
          expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-28"));
          expect(result.pillSheets[1].lastTakenDate, DateTime.parse("2020-10-05"));
          expect(result.pillSheets[2].lastTakenDate, null);
        });

        test("3枚目のピルシートを置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-05"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final pillSheet1 = PillSheet(
            id: "sheet_id_1",
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
            id: "sheet_id_2",
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

          final updatedPillSheet3 = pillSheet3.copyWith(
            lastTakenDate: DateTime.parse("2020-11-05"),
          );

          final result = pillSheetGroup.replaced(updatedPillSheet3);

          expect(result.pillSheets.length, 3);
          expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-28"));
          expect(result.pillSheets[1].lastTakenDate, DateTime.parse("2020-10-26"));
          expect(result.pillSheets[2].lastTakenDate, DateTime.parse("2020-11-05"));
        });
      });

      group("restDurationsの更新", () {
        test("ピルシートにrestDurationsを追加して置き換えられる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

          const sheetType = PillSheetType.pillsheet_28_0;
          final originalPillSheet = PillSheet(
            id: "sheet_id_1",
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1"],
            pillSheets: [originalPillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          final updatedPillSheet = originalPillSheet.copyWith(
            restDurations: [
              RestDuration(
                id: "rest_duration_id_1",
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: null,
              ),
            ],
          );

          final result = pillSheetGroup.replaced(updatedPillSheet);

          expect(result.pillSheets[0].restDurations.length, 1);
          expect(result.pillSheets[0].restDurations[0].beginDate, DateTime.parse("2020-09-11"));
          expect(result.pillSheets[0].restDurations[0].endDate, null);
        });
      });
    });

    group("異常系: 例外がスローされる", () {
      test("pillSheet.idがnullの場合、FormatExceptionがスローされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // idがnullのピルシートを作成
        // PillSheetはidがnullの状態で作成可能（Firestore保存前の状態）
        final pillSheetWithNullId = PillSheet(
          id: null,
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

        expect(
          () => pillSheetGroup.replaced(pillSheetWithNullId),
          throwsA(isA<FormatException>()),
        );
      });

      test("一致するIDのピルシートが見つからない場合、FormatExceptionがスローされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // グループに存在しないIDのピルシート
        final pillSheetWithDifferentId = PillSheet(
          id: "non_existent_id",
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

        expect(
          () => pillSheetGroup.replaced(pillSheetWithDifferentId),
          throwsA(isA<FormatException>()),
        );
      });

      test("ピルシートが2枚ある場合でも、存在しないIDでFormatExceptionがスローされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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

        final pillSheetWithDifferentId = PillSheet(
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

        expect(
          () => pillSheetGroup.replaced(pillSheetWithDifferentId),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group("イミュータビリティの確認", () {
      test("replacedを呼び出しても元のPillSheetGroupは変更されない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final originalPillSheet = PillSheet(
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1"],
          pillSheets: [originalPillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        final updatedPillSheet = originalPillSheet.copyWith(
          lastTakenDate: DateTime.parse("2020-09-10"),
        );

        final result = pillSheetGroup.replaced(updatedPillSheet);

        // 新しいインスタンスが返されている
        expect(identical(result, pillSheetGroup), false);
        // 元のグループは変更されていない
        expect(pillSheetGroup.pillSheets[0].lastTakenDate, null);
        // 新しいグループは更新されている
        expect(result.pillSheets[0].lastTakenDate, DateTime.parse("2020-09-10"));
      });

      test("pillSheetsリストも新しいリストになっている", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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

        final updatedPillSheet1 = pillSheet1.copyWith(
          lastTakenDate: DateTime.parse("2020-09-10"),
        );

        final result = pillSheetGroup.replaced(updatedPillSheet1);

        // pillSheetsリスト自体が異なるインスタンス
        expect(identical(result.pillSheets, pillSheetGroup.pillSheets), false);
      });
    });
  });

  group("#pillNumberWithoutDateOrZeroFromDate", () {
    // pillNumberWithoutDateOrZeroFromDate は指定された日付とイベント発生日に基づくピル番号を取得する
    // 履歴表示で過去の特定日におけるピル番号を正確に算出するために使用される
    // PillSheetAppearanceMode によって使用する計算方法が変わる

    group("PillSheetAppearanceMode.number の場合", () {
      test("ピルシートが1枚で休薬期間がない場合、指定日の番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // 開始日の番号は1
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-01"),
            estimatedEventCausingDate: DateTime.parse("2020-09-15"),
          ),
          1,
        );

        // 15日目の番号は15
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-15"),
            estimatedEventCausingDate: DateTime.parse("2020-09-15"),
          ),
          15,
        );

        // 28日目の番号は28
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-28"),
            estimatedEventCausingDate: DateTime.parse("2020-09-28"),
          ),
          28,
        );
      });

      test("休薬期間がある場合、日付がずれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

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
              // 9/5-9/7の2日間休薬
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

        // 休薬前の日付は通常通り
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-04"),
            estimatedEventCausingDate: DateTime.parse("2020-09-30"),
          ),
          4,
        );

        // 5番目は9/7(休薬期間の終了日)
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-07"),
            estimatedEventCausingDate: DateTime.parse("2020-09-30"),
          ),
          5,
        );

        // 28番目は9/30(9/28 + 2日間の休薬)
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-30"),
            estimatedEventCausingDate: DateTime.parse("2020-09-30"),
          ),
          28,
        );
      });

      group("ピルシートが2枚の場合", () {
        test("1枚目の最後の日付と2枚目の最初の日付の境界値", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          // 1枚目の最後の日(9/28)は28番
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              targetDate: DateTime.parse("2020-09-28"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            28,
          );

          // 2枚目の最初の日(9/29)は1番（numberモードでは各シート独立）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              targetDate: DateTime.parse("2020-09-29"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            1,
          );
        });
      });
    });

    group("PillSheetAppearanceMode.date の場合", () {
      test("numberモードと同じ計算結果を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // dateモードもnumberモードと同じ番号を返す
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            targetDate: DateTime.parse("2020-09-15"),
            estimatedEventCausingDate: DateTime.parse("2020-09-15"),
          ),
          15,
        );
      });
    });

    group("PillSheetAppearanceMode.cyclicSequential の場合", () {
      test("ピルシートが1枚で休薬期間がない場合、連続番号を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-01"),
            estimatedEventCausingDate: DateTime.parse("2020-09-28"),
          ),
          1,
        );

        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-28"),
            estimatedEventCausingDate: DateTime.parse("2020-09-28"),
          ),
          28,
        );
      });

      group("ピルシートが2枚の場合", () {
        test("1枚目の最後と2枚目の最初で連続した番号になる", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          // 1枚目の最後(9/28)は28番
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-28"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            28,
          );

          // 2枚目の最初(9/29)は29番（連続番号）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-29"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            29,
          );

          // 2枚目の最後(10/26)は56番
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-10-26"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            56,
          );
        });
      });

      group("PillSheetGroupDisplayNumberSetting がある場合", () {
        test("beginPillNumberが設定されている場合、その番号から開始する", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 10,
            ),
          );

          // 開始日の番号は10（beginPillNumberの値）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-01"),
              estimatedEventCausingDate: DateTime.parse("2020-09-28"),
            ),
            10,
          );

          // 28日目の番号は37（10 + 27）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-28"),
              estimatedEventCausingDate: DateTime.parse("2020-09-28"),
            ),
            37,
          );
        });

        test("endPillNumberが設定されている場合、超えたら1に戻る", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
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
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              endPillNumber: 28,
            ),
          );

          // 1枚目の最後(9/28)は28番
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-28"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            28,
          );

          // 2枚目の最初(9/29)は1番（endPillNumberを超えたので1に戻る）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-29"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            1,
          );

          // 2枚目の28日目(10/26)は28番
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-10-26"),
              estimatedEventCausingDate: DateTime.parse("2020-10-26"),
            ),
            28,
          );
        });
      });

      group("休薬期間がある場合", () {
        test("終了した休薬期間後は1番から再開する", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

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
                // 9/5-9/7の2日間休薬
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          // 休薬前の日付は通常通り
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-04"),
              estimatedEventCausingDate: DateTime.parse("2020-09-30"),
            ),
            4,
          );

          // 休薬終了日(9/7)は1番から再開
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-07"),
              estimatedEventCausingDate: DateTime.parse("2020-09-30"),
            ),
            1,
          );

          // 9/30は24番（1 + 23）
          expect(
            pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
              pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
              targetDate: DateTime.parse("2020-09-30"),
              estimatedEventCausingDate: DateTime.parse("2020-09-30"),
            ),
            24,
          );
        });
      });
    });

    group("PillSheetAppearanceMode.sequential の場合", () {
      test("cyclicSequentialと同じ動作をする", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );

        // sequentialモードもcyclicSequentialと同じ計算結果
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-10-26"),
          ),
          29,
        );
      });
    });

    group("estimatedEventCausingDateの影響", () {
      test("継続中の休薬期間がある場合、estimatedEventCausingDateまでの日付が計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 今日は9/10。休薬期間は9/5開始で終了未定
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
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

        // 休薬中の9/10(estimatedEventCausingDate)は5番
        // 休薬期間中は日付がずれるため、5番目のピルの日付が9/10になる
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-10"),
            estimatedEventCausingDate: DateTime.parse("2020-09-10"),
          ),
          5,
        );
      });

      test("過去のイベント日を指定した場合、その時点での日付計算が行われる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 今日は9/15。休薬期間は9/5-9/7で終了
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // 過去の9/10を指定。休薬期間(2日)の影響で9/10は8番目のピル
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-10"),
            estimatedEventCausingDate: DateTime.parse("2020-09-10"),
          ),
          8,
        );
      });
    });

    group("異常系", () {
      test("targetDateがピルシートの範囲外の場合、StateErrorがスローされる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // ピルシート開始前の日付を指定
        expect(
          () => pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-08-31"),
            estimatedEventCausingDate: DateTime.parse("2020-09-15"),
          ),
          throwsA(isA<StateError>()),
        );

        // ピルシート終了後の日付を指定
        expect(
          () => pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-09-29"),
          ),
          throwsA(isA<StateError>()),
        );
      });
    });

    group("pillSheetAppearanceModeがPillSheetGroupの設定と異なる場合", () {
      test("引数のpillSheetAppearanceModeが優先される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
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
        // PillSheetGroupはnumberモードだが...
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id_1", "sheet_id_2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 引数でcyclicSequentialモードを指定すると連続番号になる
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-10-26"),
          ),
          29,
        );

        // 引数でnumberモードを指定するとシートごとの番号になる
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            targetDate: DateTime.parse("2020-09-29"),
            estimatedEventCausingDate: DateTime.parse("2020-10-26"),
          ),
          1,
        );
      });
    });
  });

  group("#pillNumberWithoutDateOrZero", () {
    // pillNumberWithoutDateOrZero はインデックスベースでピル番号を計算する
    // 日付ベースの pillNumberWithoutDateOrZeroFromDate と異なり、estimatedEventCausingDate は不要
    // 履歴表示で確定した番号情報から表示値を算出するために使用される

    group("pillNumberInPillSheet が 0 の場合", () {
      // pillNumberInPillSheet が 0 の場合は常に 0 を返す
      // lastTakenOrZeroPillNumber が 0 の場合に呼ばれるケースがあるため
      // PillSheetModifiedHistoryPillNumberOrDate.taken で beforeLastTakenPillNumber に +1 しており、整合性を保つため

      for (final mode in PillSheetAppearanceMode.values) {
        test("${mode.name} モードでも 0 を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

          expect(
            pillSheetGroup.pillNumberWithoutDateOrZero(
              pillSheetAppearanceMode: mode,
              pageIndex: 0,
              pillNumberInPillSheet: 0,
            ),
            0,
          );
        });
      }
    });

    group("PillSheetAppearanceMode.number の場合", () {
      test("pillNumberInPillSheet をそのまま返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // 1番目
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 0,
            pillNumberInPillSheet: 1,
          ),
          1,
        );

        // 15番目
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 0,
            pillNumberInPillSheet: 15,
          ),
          15,
        );

        // 28番目（最後）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );
      });

      test("複数枚のピルシートでもシートごとの番号を返す", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // 1枚目の最後の番号
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );

        // 2枚目の開始番号（シートごとなので1）
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

    group("PillSheetAppearanceMode.date の場合", () {
      test("pillNumberInPillSheet をそのまま返す（numberモードと同じ挙動）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // 1番目
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            pageIndex: 0,
            pillNumberInPillSheet: 1,
          ),
          1,
        );

        // 15番目
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            pageIndex: 0,
            pillNumberInPillSheet: 15,
          ),
          15,
        );

        // 28番目（最後）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );
      });
    });

    group("PillSheetAppearanceMode.sequential の場合", () {
      test("1枚目のピルシートでは pillNumberInPillSheet がそのまま連続番号になる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

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

        // 1番目
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 0,
            pillNumberInPillSheet: 1,
          ),
          1,
        );

        // 15番目
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 0,
            pillNumberInPillSheet: 15,
          ),
          15,
        );

        // 28番目（最後）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );
      });

      test("複数枚のピルシートで連続番号が返される（境界値テスト）", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );

        // 1枚目の最後の番号（28）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );

        // 2枚目の開始番号（29）- 連続番号なので28+1=29
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          29,
        );

        // 2枚目の15番目（43）- 28+15=43
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 15,
          ),
          43,
        );

        // 2枚目の最後（56）- 28+28=56
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 28,
          ),
          56,
        );
      });

      test("3枚のピルシートで連続番号が返される（境界値テスト）", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );

        // 2枚目の最後の番号（56）- 28+28=56
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 28,
          ),
          56,
        );

        // 3枚目の開始番号（57）- 56+1=57
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 2,
            pillNumberInPillSheet: 1,
          ),
          57,
        );

        // 3枚目の最後（84）- 28*3=84
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 2,
            pillNumberInPillSheet: 28,
          ),
          84,
        );
      });
    });

    group("PillSheetAppearanceMode.cyclicSequential の場合", () {
      test("sequential と同じ挙動で連続番号が返される", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        // 1枚目の最後の番号（28）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );

        // 2枚目の開始番号（29）- 連続番号なので28+1=29
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          29,
        );

        // 2枚目の最後（56）- 28+28=56
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            pageIndex: 1,
            pillNumberInPillSheet: 28,
          ),
          56,
        );
      });
    });

    group("異なるPillSheetTypeの場合", () {
      test("21錠タイプで連続番号が正しく計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 0,
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
        // 21錠タイプは7日間休薬期間があるので、次の開始は21+7=28日後
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );

        // 1枚目の最後の番号（21）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 0,
            pillNumberInPillSheet: 21,
          ),
          21,
        );

        // 2枚目の開始番号（22）- 21+1=22
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          22,
        );

        // 2枚目の最後（42）- 21*2=42
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 21,
          ),
          42,
        );
      });

      test("24錠+4偽薬タイプで連続番号が正しく計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_24_4;
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
        );

        // 1枚目の最後の番号（28）- 24錠+4偽薬=28錠
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 0,
            pillNumberInPillSheet: 28,
          ),
          28,
        );

        // 2枚目の開始番号（29）
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          29,
        );
      });
    });

    group("引数の pillSheetAppearanceMode と PillSheetGroup の pillSheetAppearanceMode が異なる場合", () {
      // 履歴表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合がある
      // そのため引数でpillSheetAppearanceModeを指定できるようになっている

      test("グループはcyclicSequentialモードだが引数でnumberモードを指定するとシートごとの番号になる", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        // グループのモードで呼び出すと連続番号
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          29,
        );

        // 引数でnumberモードを指定するとシートごとの番号
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          1,
        );
      });

      test("グループはnumberモードだが引数でcyclicSequentialモードを指定すると連続番号になる", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // グループのモードで呼び出すとシートごとの番号
        expect(
          pillSheetGroup.pillNumberWithoutDateOrZero(
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            pageIndex: 1,
            pillNumberInPillSheet: 1,
          ),
          1,
        );

        // 引数でcyclicSequentialモードを指定すると連続番号
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
  });

  group("#lastActiveRestDuration", () {
    // lastActiveRestDuration は pillSheets の中で activeRestDuration を持つ最初のピルシートの休薬期間を返す
    // activeRestDuration は restDurations.last の endDate が null かつ beginDate が now() より前の場合に返される

    group("休薬期間がない場合", () {
      test("ピルシートが1枚で休薬期間がない場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
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
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, null);
      });

      test("ピルシートが複数枚で全て休薬期間がない場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

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
          lastTakenDate: DateTime.parse("2020-10-04"),
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

        expect(pillSheetGroup.lastActiveRestDuration, null);
      });
    });

    group("休薬期間がある場合", () {
      test("1枚目のピルシートにアクティブな休薬期間がある場合はその休薬期間を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-09-10"),
          createdDate: DateTime.parse("2020-09-10"),
          endDate: null,
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
          restDurations: [restDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, restDuration);
      });

      test("2枚目のピルシートにアクティブな休薬期間がある場合はその休薬期間を返す", () {
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
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-10-08"),
          createdDate: DateTime.parse("2020-10-08"),
          endDate: null,
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-07"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [restDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, restDuration);
      });

      test("1枚目と2枚目の両方にアクティブな休薬期間がある場合は1枚目の休薬期間を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration1 = RestDuration(
          id: "rest_duration_id_1",
          beginDate: DateTime.parse("2020-09-15"),
          createdDate: DateTime.parse("2020-09-15"),
          endDate: null,
        );
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
          restDurations: [restDuration1],
        );
        final restDuration2 = RestDuration(
          id: "rest_duration_id_2",
          beginDate: DateTime.parse("2020-10-08"),
          createdDate: DateTime.parse("2020-10-08"),
          endDate: null,
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          groupIndex: 1,
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-07"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          restDurations: [restDuration2],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // firstOrNull を使っているため、1枚目の休薬期間が返される
        expect(pillSheetGroup.lastActiveRestDuration, restDuration1);
      });
    });

    group("休薬期間が終了している場合", () {
      test("endDateが設定されている場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-09-10"),
          createdDate: DateTime.parse("2020-09-10"),
          endDate: DateTime.parse("2020-09-12"),
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
          restDurations: [restDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, null);
      });
    });

    group("休薬期間の開始日が未来の場合", () {
      test("beginDateがnow()より後の場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-09"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-09-10"),
          createdDate: DateTime.parse("2020-09-09"),
          endDate: null,
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
          restDurations: [restDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, null);
      });
    });

    group("境界値テスト", () {
      test("beginDateがnow()と同じ日の場合はnullを返す（isBeforeなので当日は含まれない）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-09-10"),
          createdDate: DateTime.parse("2020-09-10"),
          endDate: null,
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
          restDurations: [restDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // beginDate.isBefore(now()) は beginDate==now() の場合 false を返すため null
        expect(pillSheetGroup.lastActiveRestDuration, null);
      });

      test("beginDateが昨日の場合はアクティブな休薬期間を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-11"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2020-09-10"),
          createdDate: DateTime.parse("2020-09-10"),
          endDate: null,
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
          restDurations: [restDuration],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        expect(pillSheetGroup.lastActiveRestDuration, restDuration);
      });
    });

    group("休薬期間が複数ある場合", () {
      test("最後の休薬期間のみがアクティブとして判定される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration1 = RestDuration(
          id: "rest_duration_id_1",
          beginDate: DateTime.parse("2020-09-05"),
          createdDate: DateTime.parse("2020-09-05"),
          endDate: DateTime.parse("2020-09-07"),
        );
        final restDuration2 = RestDuration(
          id: "rest_duration_id_2",
          beginDate: DateTime.parse("2020-09-15"),
          createdDate: DateTime.parse("2020-09-15"),
          endDate: null,
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
          restDurations: [restDuration1, restDuration2],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // restDurations.last を参照するため、最後の休薬期間がアクティブとして判定される
        expect(pillSheetGroup.lastActiveRestDuration, restDuration2);
      });

      test("最後の休薬期間が終了している場合はnullを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final restDuration1 = RestDuration(
          id: "rest_duration_id_1",
          beginDate: DateTime.parse("2020-09-05"),
          createdDate: DateTime.parse("2020-09-05"),
          endDate: DateTime.parse("2020-09-07"),
        );
        final restDuration2 = RestDuration(
          id: "rest_duration_id_2",
          beginDate: DateTime.parse("2020-09-15"),
          createdDate: DateTime.parse("2020-09-15"),
          endDate: DateTime.parse("2020-09-17"),
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
          restDurations: [restDuration1, restDuration2],
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        // restDurations.last の endDate が null でないため null を返す
        expect(pillSheetGroup.lastActiveRestDuration, null);
      });
    });
  });
}
