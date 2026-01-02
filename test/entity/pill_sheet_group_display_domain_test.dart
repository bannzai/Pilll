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

      group("2枚目のピルシートに服用お休み期間がある場合", () {
        test("2枚目の服用お休みが終わっていない場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

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
            lastTakenDate: DateTime.parse("2020-10-10"),
            groupIndex: 1,
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-10-11"),
                createdDate: DateTime.parse("2020-10-11"),
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet, pillSheet2],
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            createdAt: now(),
          );

          // 1枚目は影響を受けない
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");

          // 2枚目の服用お休み前
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 12), "10/10");

          // 2枚目の服用お休み後（now()が10/15なので4日分ずれる）
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 13), "10/15");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/30");
        });

        test("2枚目の服用お休みが終わっている場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

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
            lastTakenDate: DateTime.parse("2020-10-20"),
            groupIndex: 1,
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-10-11"),
                createdDate: DateTime.parse("2020-10-11"),
                endDate: DateTime.parse("2020-10-14"),
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet, pillSheet2],
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
            createdAt: now(),
          );

          // 1枚目は影響を受けない
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");

          // 2枚目の服用お休み前
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 12), "10/10");

          // 2枚目の服用お休み後（3日分ずれる：10/11,10/12,10/13）
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 13), "10/14");
          expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/29");
        });
      });
    });

    group("ピルシートが3枚の場合", () {
      test("境界値: 1枚目の最後、2枚目の最初と最後、3枚目の最初", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-11-01"));

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
          pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        // 1枚目と2枚目の境界
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");

        // 2枚目と3枚目の境界
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/26");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 2, pillNumberInPillSheet: 1), "10/27");

        // 3枚目の最後
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 2, pillNumberInPillSheet: 28), "11/23");
      });
    });

    group("異なるPillSheetTypeが混在する場合", () {
      test("1枚目28錠、2枚目21錠の境界値", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-10"));

        const sheetType28 = PillSheetType.pillsheet_28_0;
        const sheetType21 = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28.dosingPeriod,
            name: sheetType28.fullName,
            totalCount: sheetType28.totalCount,
            pillSheetTypeReferencePath: sheetType28.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          createdAt: now(),
        );

        // 1枚目28錠の範囲
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");

        // 2枚目21錠（28錠タイプでtotalCountが28のため、pillSheet_21はtotalCountが28）
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 1), "9/29");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 21), "10/19");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 1, pillNumberInPillSheet: 28), "10/26");
      });
    });

    group("displayNumberSettingの影響", () {
      test("displayNumberSettingが設定されていてもdisplayPillSheetDateには影響しない", () {
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
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(
            beginPillNumber: 10,
            endPillNumber: 20,
          ),
        );

        // displayNumberSettingは連続番号表示モードにのみ影響し、日付表示には影響しない
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 1), '9/1');
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 10), "9/10");
        expect(pillSheetGroup.displayPillSheetDate(pageIndex: 0, pillNumberInPillSheet: 28), "9/28");
      });
    });
  });

  group("#cycleSequentialPillSheetNumber", () {
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

        test("終了番号が設定されている", () {
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

      group("服用お休み期間を持つ場合", () {
        test("2枚目のピルシートに服用お休み期間がある場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

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
            lastTakenDate: DateTime.parse("2020-10-20"),
            groupIndex: 1,
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-10-10"),
                createdDate: DateTime.parse("2020-10-10"),
                endDate: DateTime.parse("2020-10-12"),
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          // 1枚目のピルシート（通常通り連続番号）
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);

          // 2枚目のピルシート（服用お休み期間後に番号がリセット）
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 29);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 12), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 17);
        });

        test("両方のピルシートに服用お休み期間がある場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            groupIndex: 0,
            restDurations: [
              // 2020-09-15から開始、2020-09-17に終了（2日間）
              RestDuration(
                id: "rest_duration_id_1",
                beginDate: DateTime.parse("2020-09-15"),
                createdDate: DateTime.parse("2020-09-15"),
                endDate: DateTime.parse("2020-09-17"),
              )
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
            beginingDate: DateTime.parse("2020-09-29"),
            lastTakenDate: DateTime.parse("2020-10-20"),
            groupIndex: 1,
            createdAt: now(),
            restDurations: [
              // 2020-10-10から開始、2020-10-12に終了（2日間）
              RestDuration(
                id: "rest_duration_id_2",
                beginDate: DateTime.parse("2020-10-10"),
                createdDate: DateTime.parse("2020-10-10"),
                endDate: DateTime.parse("2020-10-12"),
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
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          // 1枚目のピルシート:
          // - 1-14番目: 連続番号 1-14
          // - 15番目: 日付は2020-09-17（休薬終了日）→ 番号が1にリセット
          // - 16-28番目: 連続番号 2-14
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 14), 14);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 15), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 16), 2);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 14);

          // 2枚目のピルシート:
          // - 1枚目の最後が14なので、1番目は15から
          // - 12番目: 日付は2020-10-12（休薬終了日）→ 番号が1にリセット
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 15);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 11), 25);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 12), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 17);
        });
      });
    });

    group("ピルシートが複数(3つ)の場合", () {
      test("シート間の境界値: 1枚目の最後と2枚目の最初、2枚目の最後と3枚目の最初の連続性を確認", () {
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
          pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
          pillSheets: [pillSheet1, pillSheet2, pillSheet3],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        // 1枚目の境界値
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);

        // 1枚目→2枚目の境界: 28→29の連続性確認
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 29);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 56);

        // 2枚目→3枚目の境界: 56→57の連続性確認
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 2, pillNumberInPillSheet: 1), 57);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 2, pillNumberInPillSheet: 28), 84);
      });

      group("displayNumberSettingの設定がある場合", () {
        test("開始番号と終了番号が設定されている場合、3枚目でも正しくリセットされる", () {
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
            pillSheetIDs: ["sheet_id1", "sheet_id2", "sheet_id3"],
            pillSheets: [pillSheet1, pillSheet2, pillSheet3],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 1, endPillNumber: 30),
            pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
          );

          // 1枚目: 1-28
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);

          // 2枚目: 29-30でリセットされ1に戻る
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 29);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 2), 30);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 3), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 26);

          // 3枚目: 27-30でリセット、1に戻る
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 2, pillNumberInPillSheet: 1), 27);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 2, pillNumberInPillSheet: 4), 30);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 2, pillNumberInPillSheet: 5), 1);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 2, pillNumberInPillSheet: 28), 24);
        });
      });
    });

    group("異なるPillSheetTypeの組み合わせの場合", () {
      test("21錠タイプと28錠タイプ（偽薬4日）の組み合わせ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-20"));

        const sheetType21 = PillSheetType.pillsheet_21;
        const sheetType28_4 = PillSheetType.pillsheet_28_4;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-29"),
          lastTakenDate: null,
          groupIndex: 1,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType28_4.dosingPeriod,
            name: sheetType28_4.fullName,
            totalCount: sheetType28_4.totalCount,
            pillSheetTypeReferencePath: sheetType28_4.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        // 1枚目（21錠+休薬7日タイプ=28日周期）
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 28);

        // 2枚目（28錠タイプ）: 1枚目の最後から続く
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 29);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 56);
      });

      test("24錠タイプと21錠タイプの組み合わせ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType24 = PillSheetType.pillsheet_24_0;
        const sheetType21 = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType24.dosingPeriod,
            name: sheetType24.fullName,
            totalCount: sheetType24.totalCount,
            pillSheetTypeReferencePath: sheetType24.rawPath,
          ),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-25"),
          lastTakenDate: null,
          groupIndex: 1,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType21.dosingPeriod,
            name: sheetType21.fullName,
            totalCount: sheetType21.totalCount,
            pillSheetTypeReferencePath: sheetType21.rawPath,
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id1", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.cyclicSequential,
        );

        // 1枚目（24錠タイプ）
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), 1);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 24), 24);

        // 2枚目（21錠+休薬7日タイプ=28日周期）: 24から続く
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), 25);
        expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 52);
      });
    });
  });
}
