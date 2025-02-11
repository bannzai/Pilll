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
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
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
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), 10);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), 20);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), 15);
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
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
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
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
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
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 10), 16);
          expect(pillSheetGroup.cycleSequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), 34);
        });
      });
    });
  });
}
