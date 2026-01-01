import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
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

  group("#displayPillSheetDate", () {
    group("ピルシートが一つの場合", () {
      test("begin: 2020-09-01, end: 2020-09-28", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");
      });

      group("服用お休み期間を持つ場合", () {
        test("服用お休みが終わっていない場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
              )
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            createdAt: now(),
          );

          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 22), "9/24");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/30");
        });

        test("服用お休みが終わっている場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
                endDate: DateTime.parse("2020-09-23"),
              )
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            createdAt: now(),
          );

          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 22), "9/23");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/29");
        });
        group("複数の服用お休み期間を持つ場合", () {
          test("最後の服用お休みが終わっていない場合", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

            const sheetType = PillSheetType.pillsheet_21;
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              createdAt: now(),
              restDurations: [
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-22"),
                  createdDate: DateTime.parse("2020-09-22"),
                )
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
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              createdAt: now(),
            );
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 12), "9/15");
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 22), "10/1");
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "10/7");
          });
          test("最後の服用お休み期間が終わっている場合", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

            const sheetType = PillSheetType.pillsheet_21;
            // 服用お休みを考慮しない場合は28日間
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              createdAt: now(),
              restDurations: [
                // 3日分
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                // 3日分
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-22"),
                  createdDate: DateTime.parse("2020-09-22"),
                  endDate: DateTime.parse("2020-09-25"),
                )
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
              pillSheetAppearanceMode: PillSheetAppearanceMode.number,
              createdAt: now(),
            );
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 12), "9/15");
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 22), "9/28");
            expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "10/4");
          });
        });
      });
    });
    group("ピルシートが複数(2つ)の場合", () {
      test("(begin: 2020-09-01, end: 2020-09-28),(begin: 2020-09-29, end: 2020-10-26)", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
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
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 10), "10/8");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/26");
      });
    });

    group("ピルシートが複数(3つ)の場合", () {
      test("1枚目から3枚目までの境界値を確認", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: DateTime.parse("2020-10-26"),
          groupIndex: 1,
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
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          groupIndex: 2,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        // 1枚目の境界値
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");

        // 1枚目の最後と2枚目の最初が連続しているか
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/26");

        // 2枚目の最後と3枚目の最初が連続しているか
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 2, pillNumberInPillSheet: 1), "10/27");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 2, pillNumberInPillSheet: 28), "11/23");
      });
    });

    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_24_0（24錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 24), "9/24");
      });

      test("pillsheet_21_0（21錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 21), "9/21");
      });

      test("pillsheet_28_0（28錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");
      });
    });

    group("異なるPillSheetTypeを混合した場合", () {
      test("pillsheet_21（28錠）とpillsheet_24_0（24錠）の組み合わせ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType1 = PillSheetType.pillsheet_21;
        const sheetType2 = PillSheetType.pillsheet_24_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        // 1枚目は28錠なので、2枚目は9/29から開始
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        // 1枚目（pillsheet_21 = 28錠タイプ）
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");

        // 2枚目（pillsheet_24_0 = 24錠タイプ）
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 24), "10/22");
      });

      test("pillsheet_21_0（21錠）とpillsheet_28_0（28錠）の組み合わせ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType1 = PillSheetType.pillsheet_21_0;
        const sheetType2 = PillSheetType.pillsheet_28_0;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-21"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType1.dosingPeriod,
            name: sheetType1.fullName,
            totalCount: sheetType1.totalCount,
            pillSheetTypeReferencePath: sheetType1.rawPath,
          ),
        );
        // 1枚目は21錠なので、2枚目は9/22から開始
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-22"),
          lastTakenDate: null,
          groupIndex: 1,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType2.dosingPeriod,
            name: sheetType2.fullName,
            totalCount: sheetType2.totalCount,
            pillSheetTypeReferencePath: sheetType2.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        // 1枚目（pillsheet_21_0 = 21錠タイプ）
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 21), "9/21");

        // 2枚目（pillsheet_28_0 = 28錠タイプ）
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/22");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/19");
      });
    });
  });

  group("#displayCycleSequentialPillSheetNumber", () {
    group("ピルシートが一つの場合", () {
      test("begin: 2020-09-01, end: 2020-09-28", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
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
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);
      });

      group("服用お休み期間を持つ場合", () {
        test("服用お休みが終わっていない場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
              )
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 22);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);
        });

        test("服用お休みが終わっている場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
                endDate: DateTime.parse("2020-09-23"),
              )
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

          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 7);
        });
        group("複数の服用お休み期間を持つ場合", () {
          test("最後の服用お休みが終わっていない場合", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

            const sheetType = PillSheetType.pillsheet_21;
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              createdAt: now(),
              restDurations: [
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-22"),
                  createdDate: DateTime.parse("2020-09-22"),
                )
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
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), 1);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 11);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 17);
          });
          test("最後の服用お休み期間が終わっている場合", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

            const sheetType = PillSheetType.pillsheet_21;
            // 服用お休みを考慮しない場合は28日間
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              createdAt: now(),
              restDurations: [
                // 3日分
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                // 3日分
                RestDuration(
                  id: "rest_duration_id",
                  beginDate: DateTime.parse("2020-09-22"),
                  createdDate: DateTime.parse("2020-09-22"),
                  endDate: DateTime.parse("2020-09-25"),
                )
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
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), 1);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 18), 7);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 4);
            expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 10);
          });
        });
      });

      group("displayNumberSettingの設定がある場合", () {
        test("開始番号が設定されている", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [],
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
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 10),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 19);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 31);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 37);
        });

        test("終了番号が設定されている", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

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
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(endPillNumber: 11),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 11), 11);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 11);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 6);
        });
        test("開始と終了どちらも設定されている", () {
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
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
              beginPillNumber: 10,
              endPillNumber: 20,
            ),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 19);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 11);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 17);
        });
      });
    });
    group("ピルシートが複数(2つ)の場合", () {
      test("(begin: 2020-09-01, end: 2020-09-28),(begin: 2020-09-29, end: 2020-10-26)", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
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
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 29);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 10), 38);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 56);
      });

      group("displayNumberSettingの設定がある場合", () {
        test("開始番号が設定されている", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            groupIndex: 1,
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 10),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 19);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 37);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 38);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 10), 47);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 65);
        });

        test("開始番号が設定されている", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            groupIndex: 1,
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(endPillNumber: 40),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 29);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 10), 38);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 16);
        });
        test("開始と終了どちらも設定されている", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            groupIndex: 1,
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 10, endPillNumber: 40),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), 19);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 37);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 38);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 10), 7);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 25);
        });
      });
    });
  });

  group("#displayPillNumberOrDate", () {
    // displayPillNumberOrDate は pillSheetAppearanceMode と premiumOrTrial に応じて表示を切り替える
    // - number: pillNumberInPillSheet をそのまま返す
    // - date: premiumOrTrial が true なら日付、false なら番号
    // - sequential/cyclicSequential: 連続番号を返す

    group("PillSheetAppearanceMode.number の場合", () {
      test("pillNumberInPillSheet をそのまま文字列として返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        // premiumOrTrial の値に関わらず番号を返す
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: false, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 10), "10");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "28");
      });
    });

    group("PillSheetAppearanceMode.date の場合", () {
      test("premiumOrTrial が true の場合は日付を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          createdAt: now(),
        );

        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "9/28");
      });

      test("premiumOrTrial が false の場合は番号を返す（日付表示はプレミアム機能のため）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          pillSheetAppearanceMode: PillSheetAppearanceMode.date,
          createdAt: now(),
        );

        // 非プレミアムユーザーには番号が表示される
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: false, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: false, pageIndex: 0, pillNumberInPillSheet: 10), "10");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: false, pageIndex: 0, pillNumberInPillSheet: 28), "28");
      });

      group("服用お休み期間がある場合", () {
        test("premiumOrTrial が true の場合は服用お休み期間を考慮した日付を返す", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
                endDate: DateTime.parse("2020-09-25"),
              )
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.date,
            createdAt: now(),
          );

          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "9/1");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 22), "9/25");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "10/1");
        });
      });
    });

    group("PillSheetAppearanceMode.sequential の場合", () {
      test("連続番号を文字列として返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.sequential,
          createdAt: now(),
        );

        // premiumOrTrial の値に関わらず連続番号を返す
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: false, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "28");
        // 2枚目のピルシート
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 1), "29");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 28), "56");
      });
    });

    group("PillSheetAppearanceMode.cyclicSequential の場合", () {
      test("連続番号を文字列として返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          createdAt: now(),
        );

        // premiumOrTrial の値に関わらず連続番号を返す
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: false, pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "28");
        // 2枚目のピルシート（ピルシート間の境界値）
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 1), "29");
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 28), "56");
      });

      group("displayNumberSettingがある場合", () {
        test("開始番号が設定されている場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            groupIndex: 1,
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
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 10),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            createdAt: now(),
          );

          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "10");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "37");
          // 2枚目のピルシート（境界値）
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 1), "38");
        });

        test("終了番号が設定されている場合、終了番号を超えると1から再開", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: null,
            groupIndex: 1,
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
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(endPillNumber: 40),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            createdAt: now(),
          );

          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "1");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "28");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 1), "29");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 10), "38");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 12), "40");
          // 40を超えると1から再開
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 13), "1");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 28), "16");
        });
      });

      group("服用お休み期間がある場合", () {
        test("服用お休み終了後は1から再開", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
                endDate: DateTime.parse("2020-09-25"),
              )
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
            createdAt: now(),
          );

          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 1), "1");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 21), "21");
          // 服用お休み終了日(2020-09-25)が22番目のピルに対応、1から再開
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 22), "1");
          expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "7");
        });
      });
    });

    group("ピルシート間の境界値テスト", () {
      test("1枚目の最後と2枚目の最初の番号の連続性", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
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
          beginingDate: DateTime.parse("2020-10-27"),
          lastTakenDate: null,
          groupIndex: 2,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet, pillSheet2, pillSheet3],
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          createdAt: now(),
        );

        // 1枚目の最後
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 0, pillNumberInPillSheet: 28), "28");
        // 2枚目の最初（1枚目の次の番号）
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 1), "29");
        // 2枚目の最後
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 1, pillNumberInPillSheet: 28), "56");
        // 3枚目の最初（2枚目の次の番号）
        expect(pillSheetGroup.displayPillNumberOrDate(premiumOrTrial: true, pageIndex: 2, pillNumberInPillSheet: 1), "57");
      });
    });
  });
}
