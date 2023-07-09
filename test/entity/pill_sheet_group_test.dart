import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
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
  });

  group("#sequentialTodayPillNumber", () {
    group("has one pill sheet", () {
      test("today: 2020-09-19, begin: 2020-09-14, end: 2020-09-18", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: DateTime.parse("2020-09-18"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), toDate: DateTime.parse("2020-09-18"), pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 6);
      });
      test("today: 2020-09-28, begin: 2020-09-01, end: 2020-09-28", () {
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
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 28);
      });
      group("pillsheet has rest durations", () {
        test("rest duration is not end", () {
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
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
          );
          expect(pillSheetGroup.sequentialTodayPillNumber, 22);
        });

        test("rest duration is ended", () {
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
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
          );
          expect(pillSheetGroup.sequentialTodayPillNumber, 25);
        });
        group("pill sheet has plural rest duration. ", () {
          test("last rest duration is not ended", () {
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
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                RestDuration(
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
              pills: Pill.generateAndFillTo(
                  pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
            );
            // created at and id are anything value
            final pillSheetGroup = PillSheetGroup(
              pillSheetIDs: ["sheet_id"],
              pillSheets: [pillSheet],
              createdAt: now(),
            );
            expect(pillSheetGroup.sequentialTodayPillNumber, 19);
          });
          test("last rest duration is ended", () {
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
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                RestDuration(
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
              pills: Pill.generateAndFillTo(
                  pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
            );
            // created at and id are anything value
            final pillSheetGroup = PillSheetGroup(
              pillSheetIDs: ["sheet_id"],
              pillSheets: [pillSheet],
              createdAt: now(),
            );
            expect(pillSheetGroup.sequentialTodayPillNumber, 22);
          });
        });
      });
    });
    group("has two pill sheets", () {
      test("it is plane pattern", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-01"),
          lastTakenDate: DateTime.parse("2020-03-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-29"),
          lastTakenDate: null,
          groupIndex: 1,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: null, pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 29);
      });
      test("with begin display number setting", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-01"),
          lastTakenDate: DateTime.parse("2020-03-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-29"),
          lastTakenDate: null,
          createdAt: now(),
          groupIndex: 1,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: null, pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 2),
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 30);
      });
      test("with end display number setting", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-01"),
          lastTakenDate: DateTime.parse("2020-03-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-29"),
          lastTakenDate: null,
          createdAt: now(),
          groupIndex: 1,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: null, pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(endPillNumber: 28),
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 1);
      });
      test("with begin and end display number setting", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet1 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-01"),
          lastTakenDate: DateTime.parse("2020-03-28"),
          createdAt: now(),
          groupIndex: 0,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
        );
        final pillSheet2 = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-03-29"),
          lastTakenDate: null,
          createdAt: now(),
          groupIndex: 1,
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.generateAndFillTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: null, pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id", "sheet_id2"],
          pillSheets: [pillSheet1, pillSheet2],
          createdAt: now(),
          displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 2, endPillNumber: 28),
        );
        expect(pillSheetGroup.sequentialTodayPillNumber, 2);
      });
    });
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
          pills: Pill.generateAndFillTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), toDate: null, pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
      });
      test("it is taken", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: DateTime.parse("2020-09-17"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          createdAt: now(),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), toDate: DateTime.parse("2020-09-17"), pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 4);
      });
      test("it is boundary test", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          createdAt: now(),
          pills: Pill.generateAndFillTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
        );
        // created at and id are anything value
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["sheet_id"],
          pillSheets: [pillSheet],
          createdAt: now(),
        );
        expect(pillSheetGroup.sequentialLastTakenPillNumber, 28);
      });
      group("pillsheet has rest durations", () {
        test("rest duration is not ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-22"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-23"),
                createdDate: DateTime.parse("2020-09-23"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-22"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 22);
        });
        test("rest duration is ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-27"),
            createdAt: now(),
            restDurations: [
              RestDuration(
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
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-27"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 25);
        });
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
            pills: Pill.generateAndFillTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: null, pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id"],
            pillSheets: [pillSheet],
            createdAt: now(),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 0);
        });

        group("pillsheet has plural rest durations", () {
          test("last rest duration is not ended", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

            const sheetType = PillSheetType.pillsheet_21;
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-22"),
              createdAt: now(),
              restDurations: [
                RestDuration(
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                RestDuration(
                  beginDate: DateTime.parse("2020-09-26"),
                  createdDate: DateTime.parse("2020-09-26"),
                ),
              ],
              typeInfo: PillSheetTypeInfo(
                dosingPeriod: sheetType.dosingPeriod,
                name: sheetType.fullName,
                totalCount: sheetType.totalCount,
                pillSheetTypeReferencePath: sheetType.rawPath,
              ),
              pills: Pill.generateAndFillTo(
                  pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-22"), pillTakenCount: 1),
            );
            // created at and id are anything value
            final pillSheetGroup = PillSheetGroup(
              pillSheetIDs: ["sheet_id"],
              pillSheets: [pillSheet],
              createdAt: now(),
            );
            expect(pillSheetGroup.sequentialLastTakenPillNumber, 19);
          });
          test("last rest duration is ended", () {
            final mockTodayRepository = MockTodayService();
            todayRepository = mockTodayRepository;
            when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

            const sheetType = PillSheetType.pillsheet_21;
            final pillSheet = PillSheet(
              id: firestoreIDGenerator(),
              beginingDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-22"),
              createdAt: now(),
              restDurations: [
                RestDuration(
                  beginDate: DateTime.parse("2020-09-12"),
                  createdDate: DateTime.parse("2020-09-12"),
                  endDate: DateTime.parse("2020-09-15"),
                ),
                RestDuration(
                  beginDate: DateTime.parse("2020-09-26"),
                  createdDate: DateTime.parse("2020-09-26"),
                  endDate: DateTime.parse("2020-09-27"),
                ),
              ],
              typeInfo: PillSheetTypeInfo(
                dosingPeriod: sheetType.dosingPeriod,
                name: sheetType.fullName,
                totalCount: sheetType.totalCount,
                pillSheetTypeReferencePath: sheetType.rawPath,
              ),
              pills: Pill.generateAndFillTo(
                  pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), toDate: DateTime.parse("2020-09-22"), pillTakenCount: 1),
            );
            // created at and id are anything value
            final pillSheetGroup = PillSheetGroup(
              pillSheetIDs: ["sheet_id"],
              pillSheets: [pillSheet],
              createdAt: now(),
            );
            expect(pillSheetGroup.sequentialLastTakenPillNumber, 19);
          });
        });
      });
      group("has two pill sheets", () {
        test("it is plane pattern", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-30"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-01"),
            lastTakenDate: DateTime.parse("2020-03-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-29"),
            lastTakenDate: DateTime.parse("2022-03-29"),
            createdAt: now(),
            groupIndex: 1,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: DateTime.parse("2022-03-29"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 29);
        });
        test("with begin display number setting", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-30"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-01"),
            lastTakenDate: DateTime.parse("2020-03-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-29"),
            lastTakenDate: DateTime.parse("2022-03-29"),
            createdAt: now(),
            groupIndex: 1,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: DateTime.parse("2022-03-29"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 2),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 30);
        });
        test("with end display number setting", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-30"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-01"),
            lastTakenDate: DateTime.parse("2020-03-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-29"),
            lastTakenDate: DateTime.parse("2022-03-29"),
            createdAt: now(),
            groupIndex: 1,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: DateTime.parse("2022-03-29"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(endPillNumber: 28),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 1);
        });

        test("with end display number setting", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-30"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-01"),
            lastTakenDate: DateTime.parse("2020-03-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-29"),
            lastTakenDate: DateTime.parse("2022-03-29"),
            createdAt: now(),
            groupIndex: 1,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: DateTime.parse("2022-03-29"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(endPillNumber: 28),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 1);
        });
        test("with begin and end display number setting", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-03-30"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet1 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-01"),
            lastTakenDate: DateTime.parse("2020-03-28"),
            createdAt: now(),
            groupIndex: 0,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-01"), toDate: DateTime.parse("2022-03-28"), pillTakenCount: 1),
          );
          final pillSheet2 = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-03-29"),
            lastTakenDate: DateTime.parse("2022-03-29"),
            createdAt: now(),
            groupIndex: 1,
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.generateAndFillTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-03-29"), toDate: DateTime.parse("2022-03-29"), pillTakenCount: 1),
          );
          // created at and id are anything value
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["sheet_id", "sheet_id2"],
            pillSheets: [pillSheet1, pillSheet2],
            createdAt: now(),
            displayNumberSetting: const PillSheetGroupDisplayNumberSetting(beginPillNumber: 2, endPillNumber: 28),
          );
          expect(pillSheetGroup.sequentialLastTakenPillNumber, 2);
        });
      });
    });
  });
}
