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
        final pillShee$2 = PillSheet(
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
          pillSheets: [pillSheet, pillShee$2],
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

  group("#displaySequentialPillSheetNumber", () {
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
        );
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), "1");
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), "10");
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), "28");
      });

      // NOTE: 直接このテストケースの結果に関わってこない部分ではあるが、書いちゃったので残している
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
          );

          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), "1");
          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), "10");
          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), "22");
          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), "28");
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
          );

          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), "1");
          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), "10");
          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), "22");
          expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), "28");
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
            );
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), "1");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), "10");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), "12");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), "22");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), "28");
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
            );
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), '1');
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), "10");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 12), "12");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 22), "22");
            expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), "28");
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
        final pillShee$2 = PillSheet(
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
          pillSheets: [pillSheet, pillShee$2],
          createdAt: now(),
        );
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 1), '1');
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 10), "10");
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 0, pillNumberInPillSheet: 28), "28");
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 1), "29");
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 10), "38");
        expect(pillSheetGroup.displaySequentialPillSheetNumber(pageIndex: 1, pillNumberInPillSheet: 28), "56");
      });
    });
  });
}
