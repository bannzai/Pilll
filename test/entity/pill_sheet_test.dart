import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
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
  group("#todayPillNumber", () {
    test("開始日から6日目の場合は6番", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      );
      expect(model.todayPillNumber, 6);
    });
    test("境界値テスト：開始日と同じ日の場合は1番", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.todayPillNumber, 1);
    });
    test("境界値テスト：開始日より前の日の場合でも1番を返す（max関数による下限保護）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.todayPillNumber, 1);
    });
    test("境界値テスト：28日目の場合は28番", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.todayPillNumber, 28);
    });
    test("境界値テスト：開始日の翌日の場合は2番", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.todayPillNumber, 2);
    });
    group("休薬期間がある場合", () {
      test("休薬期間が終了していない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 22);
      });

      test("休薬期間が終了している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 25);
      });
      test("境界値テスト：休薬期間開始日と同日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-21"),
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
        expect(model.todayPillNumber, 22);
      });
      test("境界値テスト：休薬期間終了日と同日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-21"),
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
        expect(model.todayPillNumber, 22);
      });
      test("境界値テスト：休薬期間終了日の翌日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-26"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-21"),
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
        expect(model.todayPillNumber, 23);
      });
      group("複数の休薬期間がある場合", () {
        test("最後の休薬期間が終了していない場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
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
          expect(model.todayPillNumber, 19);
        });
        test("最後の休薬期間が終了している場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
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
          expect(model.todayPillNumber, 22);
        });
      });
    });
  });
  group("#isActive", () {
    group("開始日の境界値テスト", () {
      test("開始日当日（00:00:00）はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActive, true);
      });
      test("開始日当日の23:59:59はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 1, 23, 59, 59));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActive, true);
      });
      test("開始日前日は非アクティブ（境界値）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-08-31"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActive, false);
      });
      test("開始日前日の23:59:59は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime(2020, 8, 31, 23, 59, 59));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActive, false);
      });
    });
    test("it is active pattern. today: 2020-09-19, begin: 2020-09-14", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isActive, true);
    });
    test("it is active pattern. Boundary testing. today: 2020-09-28, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isActive, true);
    });
    test("it is deactive pattern. Boundary testing. today: 2020-09-29, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isActive, false);
    });
    test("it is active pattern. Boundary testing. now: 2020-09-28 23:59:59, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 28, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isActive, true);
    });
    test("it is active pattern. for avoid out of active duration when during rest duration", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
          RestDuration(id: "rest_duration_id", beginDate: DateTime.parse("2020-09-20"), createdDate: DateTime.parse("2020-09-20"), endDate: null),
        ],
      );
      expect(model.isActive, true);
    });
    test("it is active pattern. for avoid out of active duration when contains ended rest duration", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
              beginDate: DateTime.parse("2020-09-20"),
              createdDate: DateTime.parse("2020-09-20"),
              endDate: DateTime.parse("2020-09-22")),
        ],
      );
      expect(model.isActive, true);
    });
    test("it is deactive pattern. Boundary testing. now: 2020-09-29 23:59:59, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isActive, false);
    });
    test("it is deactive pattern.  now: 2020-06-29 begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-06-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isActive, false);
    });
    test("it is deactive pattern. for contains ended rest duration", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 30, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
            beginDate: DateTime.parse("2020-09-20"),
            createdDate: DateTime.parse("2020-09-20"),
            endDate: DateTime.parse("2020-09-21"),
          ),
        ],
      );
      expect(model.isActive, false);
    });
    group("複数の休薬期間がある場合", () {
      test("複数の終了した休薬期間を含み、期間内でアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 9/1開始、21錠 + 7休薬 = 28日 → 9/28が最終日
        // 休薬1: 9/5-9/7 → daysBetween(9/5, 9/7) = 2日延長 → 9/30が最終日
        // 休薬2: 9/15-9/17 → daysBetween(9/15, 9/17) = 2日延長 → 10/2が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-02"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        expect(model.isActive, true);
      });
      test("複数の終了した休薬期間を含み、延長された最終日の翌日で非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 9/1開始、21錠 + 7休薬 = 28日 → 9/28が最終日
        // 休薬1: 9/5-9/7 → daysBetween(9/5, 9/7) = 2日延長 → 9/30が最終日
        // 休薬2: 9/15-9/17 → daysBetween(9/15, 9/17) = 2日延長 → 10/2が最終日
        // 10/3は期間外
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-03"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        expect(model.isActive, false);
      });
    });
  });
  group("#isActiveFor", () {
    // isActiveFor は引数で日付を受け取り、その日付がピルシートのアクティブ期間内かを判定する
    // isActive は isActiveFor(now()) のラッパー
    // estimatedEndTakenDate の計算に today() が使われるため、モックが必要

    group("開始日の境界値テスト", () {
      test("開始日当日はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-01")), true);
      });
      test("開始日当日の23:59:59はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime(2020, 9, 1, 23, 59, 59)), true);
      });
      test("開始日前日は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-08-31")), false);
      });
      test("開始日前日の23:59:59は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime(2020, 8, 31, 23, 59, 59)), false);
      });
    });
    group("終了日の境界値テスト（pillsheet_21: 21錠）", () {
      // pillsheet_21: totalCount=21, 9/1開始 → 9/21が最終日（9/1が1日目）
      test("終了日当日（21日目）はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-21")), true);
      });
      test("終了日当日の23:59:59はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime(2020, 9, 21, 23, 59, 59)), true);
      });
      test("終了日翌日（22日目）は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-22")), false);
      });
    });
    group("終了日の境界値テスト（pillsheet_28_4: 24錠+偽薬4錠）", () {
      // pillsheet_28_4: totalCount=28, 9/1開始 → 9/28が最終日
      test("終了日当日（28日目）はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-28")), true);
      });
      test("終了日翌日（29日目）は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-29")), false);
      });
    });
    group("終了日の境界値テスト（pillsheet_24_0: 24錠+休薬4日）", () {
      // pillsheet_24_0: totalCount=28, 9/1開始 → 9/28が最終日
      test("終了日当日（28日目）はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-28")), true);
      });
      test("終了日翌日（29日目）は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-29")), false);
      });
    });
    group("期間中のテスト", () {
      test("期間中の日付（10日目）はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-10")), true);
      });
    });
    group("休薬期間がある場合", () {
      test("終了した休薬期間により延長された終了日当日はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 休薬期間: 9/5-9/7 → daysBetween(9/5, 9/7) = 2日延長 → 9/23が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-23"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
          ],
        );
        expect(model.isActiveFor(DateTime.parse("2020-09-23")), true);
      });
      test("終了した休薬期間により延長された終了日の翌日は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 休薬期間: 9/5-9/7 → daysBetween(9/5, 9/7) = 2日延長 → 9/23が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
          ],
        );
        expect(model.isActiveFor(DateTime.parse("2020-09-24")), false);
      });
      test("継続中の休薬期間がある場合、休薬期間中はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 継続中の休薬期間: 9/10開始、endDate=null
        // today = 9/25 の場合、休薬期間は15日間
        // estimatedEndTakenDate の計算で today() が使われるため、モックが必要
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(DateTime.parse("2020-09-25")), true);
      });
    });
    group("複数の休薬期間がある場合", () {
      test("複数の終了した休薬期間により延長された終了日当日はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 休薬1: 9/5-9/7 → 2日延長 → 9/23が最終日
        // 休薬2: 9/15-9/17 → 2日延長 → 9/25が最終日
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        expect(model.isActiveFor(DateTime.parse("2020-09-25")), true);
      });
      test("複数の終了した休薬期間により延長された終了日の翌日は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // pillsheet_21: totalCount=21, 9/1開始 → 通常9/21が最終日
        // 休薬1: 9/5-9/7 → 2日延長 → 9/23が最終日
        // 休薬2: 9/15-9/17 → 2日延長 → 9/25が最終日
        // 9/26は期間外
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-26"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-17"),
            ),
          ],
        );
        expect(model.isActiveFor(DateTime.parse("2020-09-26")), false);
      });
    });
    group("isActiveとの整合性テスト", () {
      test("isActiveFor(now()) と isActive は同じ結果を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isActiveFor(now()), model.isActive);
      });
    });
  });
  group("#isBegan", () {
    test("開始日より後の場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isBegan, true);
    });
    test("開始日と同日の場合はfalseを返す（境界値: beginingDate.date() < now() で等しい場合はfalse）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      // DateTime.parse は 00:00:00 を返すため、beginingDate.date() と now() が同じ値になる
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isBegan, false);
    });
    test("開始日の翌日の場合はtrueを返す（境界値）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-02"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isBegan, true);
    });
    test("開始日より前の場合はfalseを返す（未来のピルシート）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-06-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.isBegan, false);
    });
  });
  group("#inNotTakenDuration", () {
    // inNotTakenDuration は todayPillNumber > typeInfo.dosingPeriod で判定される
    // 休薬期間・偽薬期間に入っているかどうかを判定する

    group("休薬期間/偽薬期間があるピルシートタイプ（pillsheet_21: 21錠+休薬7日）", () {
      // pillsheet_21: totalCount=28, dosingPeriod=21
      test("todayPillNumber が dosingPeriod より小さい場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から10日目 -> todayPillNumber = 10
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 10);
        expect(model.inNotTakenDuration, false);
      });

      test("境界値テスト：todayPillNumber が dosingPeriod と同じ（21番）の場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から21日目 -> todayPillNumber = 21
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 21);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, false);
      });

      test("境界値テスト：todayPillNumber が dosingPeriod + 1（22番）の場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から22日目 -> todayPillNumber = 22
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 22);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, true);
      });

      test("todayPillNumber が totalCount（28番）の場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から28日目 -> todayPillNumber = 28
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 28);
        expect(model.inNotTakenDuration, true);
      });
    });

    group("偽薬期間があるピルシートタイプ（pillsheet_28_4: 24錠+4日偽薬）", () {
      // pillsheet_28_4: totalCount=28, dosingPeriod=24
      test("境界値テスト：todayPillNumber が dosingPeriod と同じ（24番）の場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から24日目 -> todayPillNumber = 24
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 24);
        expect(sheetType.dosingPeriod, 24);
        expect(model.inNotTakenDuration, false);
      });

      test("境界値テスト：todayPillNumber が dosingPeriod + 1（25番）の場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から25日目 -> todayPillNumber = 25
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 25);
        expect(sheetType.dosingPeriod, 24);
        expect(model.inNotTakenDuration, true);
      });
    });

    group("偽薬期間があるピルシートタイプ（pillsheet_28_7: 21錠+7日偽薬）", () {
      // pillsheet_28_7: totalCount=28, dosingPeriod=21
      test("境界値テスト：todayPillNumber が dosingPeriod + 1（22番）の場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

        const sheetType = PillSheetType.pillsheet_28_7;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 22);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, true);
      });
    });

    group("休薬期間があるピルシートタイプ（pillsheet_24_rest_4: 24錠+4日休薬）", () {
      // pillsheet_24_rest_4: totalCount=28, dosingPeriod=24
      test("境界値テスト：todayPillNumber が dosingPeriod + 1（25番）の場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_24_rest_4;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 25);
        expect(sheetType.dosingPeriod, 24);
        expect(model.inNotTakenDuration, true);
      });
    });

    group("全て実薬のピルシートタイプ（pillsheet_28_0: 28錠すべて実薬）", () {
      // pillsheet_28_0: totalCount=28, dosingPeriod=28
      // totalCount == dosingPeriod なので、inNotTakenDuration は常に false となるべき
      test("todayPillNumber が 1番の場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 1);
        expect(model.inNotTakenDuration, false);
      });

      test("境界値テスト：todayPillNumber が dosingPeriod と同じ（28番）の場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 28);
        expect(sheetType.dosingPeriod, 28);
        expect(model.inNotTakenDuration, false);
      });
    });

    group("全て実薬のピルシートタイプ（pillsheet_24_0: 24錠すべて実薬）", () {
      // pillsheet_24_0: totalCount=24, dosingPeriod=24
      test("境界値テスト：todayPillNumber が dosingPeriod と同じ（24番）の場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 24);
        expect(sheetType.dosingPeriod, 24);
        expect(model.inNotTakenDuration, false);
      });
    });

    group("全て実薬のピルシートタイプ（pillsheet_21_0: 21錠すべて実薬）", () {
      // pillsheet_21_0: totalCount=21, dosingPeriod=21
      test("境界値テスト：todayPillNumber が dosingPeriod と同じ（21番）の場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final model = PillSheet(
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
        expect(model.todayPillNumber, 21);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, false);
      });
    });

    group("休薬期間（RestDuration）がある場合", () {
      // RestDuration により todayPillNumber が遅延するため、inNotTakenDuration の判定に影響する
      test("RestDuration により todayPillNumber が dosingPeriod 以下に留まっている場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日から25日目だが、3日間の休薬があるため todayPillNumber = 25 - 3 = 22
        // しかし、休薬期間がまだ終わっていないため計算が異なる
        // 休薬開始日: 9/20、今日: 9/25（休薬開始から6日目）
        // todayPillNumber = daysBetween(9/1, 9/25) - summarizedRestDuration + 1
        //                 = 24 - 5 + 1 = 20（休薬期間が継続中なので5日間がカウントされる）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-19"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-20"),
              createdDate: DateTime.parse("2020-09-20"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 20);
        expect(model.inNotTakenDuration, false);
      });

      test("RestDuration が終了し、todayPillNumber が dosingPeriod を超えた場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日: 9/1、今日: 9/25、休薬期間: 9/5-9/6（2日間）
        // todayPillNumber = daysBetween(9/1, 9/25) - 2 + 1 = 24 - 2 + 1 = 23
        // しかし dosingPeriod = 21 なので、23 > 21 → true
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-06"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 23);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, true);
      });

      test("境界値テスト：RestDuration により todayPillNumber が dosingPeriod と同じになる場合は false を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日: 9/1、今日: 9/23、休薬期間: 9/10-9/11（2日間）
        // todayPillNumber = daysBetween(9/1, 9/23) - 2 + 1 = 22 - 2 + 1 = 21
        // dosingPeriod = 21 なので、21 > 21 → false
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-23"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-11"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 21);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, false);
      });

      test("境界値テスト：RestDuration により todayPillNumber が dosingPeriod + 1 になる場合は true を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 開始日: 9/1、今日: 9/24、休薬期間: 9/10-9/11（2日間）
        // todayPillNumber = daysBetween(9/1, 9/24) - 2 + 1 = 23 - 2 + 1 = 22
        // dosingPeriod = 21 なので、22 > 21 → true
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-23"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-11"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 22);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, true);
      });
    });
  });
  group("#lastTakenOrZeroPillNumber", () {
    test("未服用の場合は0になる", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.lastTakenOrZeroPillNumber, 0);
    });
    test("beginingDate > lastTakenDateの場合は0になる。服用日が開始日より前になる。「今日飲むピル番号」の調整機能で1つ目のピルを選択した時", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-13"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenOrZeroPillNumber, 0);
    });
    test("境界値テスト：開始日と同日に服用した場合は1番を返す", () {
      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-14"),
        createdAt: DateTime.parse("2020-09-14"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenOrZeroPillNumber, 1);
    });
    test("境界値テスト：開始日の翌日に服用した場合は2番を返す", () {
      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-15"),
        createdAt: DateTime.parse("2020-09-15"),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenOrZeroPillNumber, 2);
    });
    test("6日目だが4番まで服用済み", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-17"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenOrZeroPillNumber, 4);
    });
    test("境界値テスト。28番を服用", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.lastTakenOrZeroPillNumber, 28);
    });
    test("服用お休み期間がある場合。服用お休みが終了してない場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-22"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      );
      expect(model.lastTakenOrZeroPillNumber, 22);
    });
    test("服用お休み期間がある場合。服用お休みが終了している場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-27"),
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
      expect(model.lastTakenOrZeroPillNumber, 25);
    });
    test("服用お休みが終了しているが、まだピルを服用していない場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.lastTakenOrZeroPillNumber, 0);
    });
    test("境界値テスト：休薬期間開始日と同日が最終服用日の場合", () {
      const sheetType = PillSheetType.pillsheet_21;
      // 休薬期間開始日は2020-09-23、最終服用日も2020-09-23
      // 開始日から23日目まで服用しているので、23番を返すべき
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-23"),
        createdAt: DateTime.parse("2020-09-28"),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      );
      expect(model.lastTakenOrZeroPillNumber, 23);
    });
    test("境界値テスト：休薬期間終了日と同日が最終服用日の場合", () {
      const sheetType = PillSheetType.pillsheet_21;
      // 休薬期間は2020-09-20から2020-09-22（2日間）
      // 最終服用日は2020-09-22（休薬終了日と同日）
      // 休薬期間中は番号が進まないので、休薬開始前の最終服用番号のまま
      // beginingDate: 2020-09-01, lastTakenDate: 2020-09-22
      // 休薬期間がlastTakenDate以前なので、20-1+1=20番...ではなく、
      // summarizedRestDurationがupperDate=lastTakenDateで計算される
      // 休薬期間開始日=9/20、休薬終了日=9/22、upperDate=9/22
      // 9/20は9/22より前なので休薬期間としてカウント、daysBetween(9/20, 9/22)=2日
      // pillNumber = daysBetween(9/1, 9/22) - 2 + 1 = 21 - 2 + 1 = 20
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-22"),
        createdAt: DateTime.parse("2020-09-28"),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      expect(model.lastTakenOrZeroPillNumber, 20);
    });
    test("境界値テスト：休薬期間終了日の翌日が最終服用日の場合", () {
      const sheetType = PillSheetType.pillsheet_21;
      // 休薬期間は2020-09-20から2020-09-22（2日間）
      // 最終服用日は2020-09-23（休薬終了日の翌日）
      // daysBetween(9/1, 9/23) = 22, 休薬期間2日
      // pillNumber = 22 - 2 + 1 = 21
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-23"),
        createdAt: DateTime.parse("2020-09-28"),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      expect(model.lastTakenOrZeroPillNumber, 21);
    });

    group("服用お休みを同じピルシートで複数している場合", () {
      test("最後の服用お休みが終了していない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
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
        );
        expect(model.lastTakenOrZeroPillNumber, 19);
      });
      test("最後の服用お休みが終了している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
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
        );
        expect(model.lastTakenOrZeroPillNumber, 19);
      });
    });
  });
  group("#lastTakenPillNumber", () {
    test("未服用の場合はnullになる", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.lastTakenPillNumber, isNull);
    });
    test("beginingDate > lastTakenDateの場合はnullになる。服用日が開始日より前になる。「今日飲むピル番号」の調整機能で1つ目のピルを選択した時", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-13"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenPillNumber, isNull);
    });
    test("境界値テスト：開始日と同日に服用した場合は1番を返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-14"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenPillNumber, 1);
    });
    test("境界値テスト：開始日の翌日に服用した場合は2番を返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-15"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenPillNumber, 2);
    });
    test("6日目だが4番まで服用済み", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-17"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.lastTakenPillNumber, 4);
    });
    test("境界値テスト。28番を服用", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.lastTakenPillNumber, 28);
    });
    test("服用お休み期間がある場合。服用お休みが終了してない場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-22"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      );
      expect(model.lastTakenPillNumber, 22);
    });
    test("服用お休み期間がある場合。服用お休みが終了している場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-27"),
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
      expect(model.lastTakenPillNumber, 25);
    });
    test("服用お休みが終了しているが、まだピルを服用していない場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.lastTakenPillNumber, isNull);
    });
    test("境界値テスト：休薬期間開始日と同日が最終服用日の場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      // 休薬期間開始日は2020-09-23、最終服用日も2020-09-23
      // 開始日から23日目まで服用しているので、23番を返すべき
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-23"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      );
      expect(model.lastTakenPillNumber, 23);
    });
    test("境界値テスト：休薬期間終了日と同日が最終服用日の場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      // 休薬期間は2020-09-20から2020-09-22（3日間）
      // 最終服用日は2020-09-22（休薬終了日と同日）
      // 休薬期間中は番号が進まないので、休薬開始前の最終服用番号のまま
      // beginingDate: 2020-09-01, lastTakenDate: 2020-09-22
      // 休薬期間がlastTakenDate以前なので、20-1+1=20番...ではなく、
      // summarizedRestDurationがupperDate=lastTakenDateで計算される
      // 休薬期間開始日=9/20、休薬終了日=9/22、upperDate=9/22
      // 9/20は9/22より前なので休薬期間としてカウント、daysBetween(9/20, 9/22)=2日
      // pillNumber = daysBetween(9/1, 9/22) - 2 + 1 = 21 - 2 + 1 = 20
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-22"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      expect(model.lastTakenPillNumber, 20);
    });
    test("境界値テスト：休薬期間終了日の翌日が最終服用日の場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      // 休薬期間は2020-09-20から2020-09-22（2日間）
      // 最終服用日は2020-09-23（休薬終了日の翌日）
      // daysBetween(9/1, 9/23) = 22, 休薬期間2日
      // pillNumber = 22 - 2 + 1 = 21
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-23"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
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
      expect(model.lastTakenPillNumber, 21);
    });

    group("服用お休みを同じピルシートで複数している場合", () {
      test("最後の服用お休みが終了していない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
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
        );
        expect(model.lastTakenPillNumber, 19);
      });
      test("最後の服用お休みが終了している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
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
        );
        expect(model.lastTakenPillNumber, 19);
      });
    });
  });
  group("#todayPillIsAlreadyTaken", () {
    test("lastTakenDateがnullの場合はfalseを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      expect(model.todayPillIsAlreadyTaken, false);
    });
    test("lastTakenDateが今日と同日の場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-19"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("境界値テスト：lastTakenDateが今日の0:00:00の場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 19, 12, 0, 0));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime(2020, 9, 19, 0, 0, 0),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("境界値テスト：lastTakenDateが今日の23:59:59の場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 19, 8, 0, 0));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime(2020, 9, 19, 23, 59, 59),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("lastTakenDateが今日より1日前の場合はfalseを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
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
      );
      expect(model.todayPillIsAlreadyTaken, false);
    });
    test("境界値テスト：lastTakenDateが昨日の23:59:59の場合はfalseを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 19, 0, 0, 0));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime(2020, 9, 18, 23, 59, 59),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, false);
    });
    test("lastTakenDateが今日より1日後の場合はtrueを返す（まとめ飲みのケース）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-20"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("境界値テスト：lastTakenDateが明日の0:00:00の場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 19, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime(2020, 9, 20, 0, 0, 0),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("lastTakenDateが今日より2日前の場合はfalseを返す（飲み忘れのケース）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-17"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, false);
    });
    test("lastTakenDateが今日より複数日後の場合はtrueを返す（複数日分まとめ飲みのケース）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-22"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("ピルシート開始日と同日に服用した場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-14"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(model.todayPillIsAlreadyTaken, true);
    });
    test("ピルシート最終日（28日目）に服用した場合はtrueを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_28_7;
      final model = PillSheet(
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
      expect(model.todayPillIsAlreadyTaken, true);
    });
  });
  group("#isTakenAll", () {
    group("lastTakenDate が null の場合", () {
      test("28錠タイプ - isTakenAll は false を返す", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
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
        expect(model.isTakenAll, false);
      });
    });

    group("lastTakenDate が beginingDate より前の場合", () {
      test("28錠タイプ - isTakenAll は false を返す", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-08-31"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.isTakenAll, false);
      });
    });

    group("途中のピル番号で服用が止まっている場合", () {
      test("28錠タイプで10番目まで服用 - isTakenAll は false を返す", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
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
        expect(model.isTakenAll, false);
      });

      test("24錠タイプで1番目まで服用 - isTakenAll は false を返す", () {
        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
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
        expect(model.isTakenAll, false);
      });

      test("21錠タイプで20番目まで服用（境界値-1）- isTakenAll は false を返す", () {
        const sheetType = PillSheetType.pillsheet_21_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
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
        expect(model.isTakenAll, false);
      });
    });

    group("最後のピルまで服用した場合", () {
      test("28錠タイプで28番目まで服用 - isTakenAll は true を返す", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
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
        expect(model.isTakenAll, true);
      });

      test("24錠タイプで24番目まで服用 - isTakenAll は true を返す", () {
        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.isTakenAll, true);
      });

      test("21錠タイプで21番目まで服用 - isTakenAll は true を返す", () {
        const sheetType = PillSheetType.pillsheet_21_0;
        final model = PillSheet(
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
        expect(model.isTakenAll, true);
      });

      test("21錠+休薬7日タイプで28番目まで服用 - isTakenAll は true を返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.isTakenAll, true);
      });
    });
  });
  group("#estimatedEndTakenDate", () {
    test("spec", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
    });

    group("pillsheet has rest durations", () {
      test("rest duration is not ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-05-03"),
              createdDate: DateTime.parse("2022-05-03"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-05").subtract(const Duration(seconds: 1)));
      });
      test("rest duration is ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-05-03"),
              createdDate: DateTime.parse("2022-05-03"),
              endDate: DateTime.parse("2022-05-05"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-31").subtract(const Duration(seconds: 1)));
      });

      group("pillsheet has plural rest duration", () {
        test("last rest duration is not ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-05-01"),
            lastTakenDate: null,
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2022-05-03"),
                createdDate: DateTime.parse("2022-05-03"),
                endDate: DateTime.parse("2022-05-05"),
              ),
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2022-05-07"),
                createdDate: DateTime.parse("2022-05-07"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-03").subtract(const Duration(seconds: 1)));
        });
        test("last rest duration is ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-05-01"),
            lastTakenDate: null,
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2022-05-03"),
                createdDate: DateTime.parse("2022-05-03"),
                endDate: DateTime.parse("2022-05-05"),
              ),
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2022-05-07"),
                createdDate: DateTime.parse("2022-05-07"),
                endDate: DateTime.parse("2022-05-08"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-01").subtract(const Duration(seconds: 1)));
        });
      });
    });

    group("異なるPillSheetTypeでのテスト", () {
      test("pillsheet_24_0の場合、totalCount=24なので開始日から24日目がestimatedEndTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 5/1 + 23日 = 5/24、翌日 - 1秒 = 5/25 00:00:00 - 1秒 = 5/24 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-25").subtract(const Duration(seconds: 1)));
      });

      test("pillsheet_21_0の場合、totalCount=21なので開始日から21日目がestimatedEndTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 5/1 + 20日 = 5/21、翌日 - 1秒 = 5/22 00:00:00 - 1秒 = 5/21 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-22").subtract(const Duration(seconds: 1)));
      });

      test("pillsheet_28_4の場合、totalCount=28なので開始日から28日目がestimatedEndTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 5/1 + 27日 = 5/28、翌日 - 1秒 = 5/29 00:00:00 - 1秒 = 5/28 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });

      test("pillsheet_24_rest_4の場合、totalCount=28なので開始日から28日目がestimatedEndTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_24_rest_4;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 5/1 + 27日 = 5/28、翌日 - 1秒 = 5/29 00:00:00 - 1秒 = 5/28 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });
    });

    group("境界値テスト", () {
      test("now()が開始日当日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 開始日当日でも計算は同じ: 5/1 + 27日 = 5/28、翌日 - 1秒 = 5/28 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });

      test("now()が終了日当日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 終了日当日でも計算は同じ
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });

      test("now()が終了日翌日の場合（ピルシート終了後）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // ピルシート終了後でも計算結果は変わらない
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });
    });

    group("now()の日付による休薬期間計算の違い", () {
      test("now()が休薬期間開始前の場合、休薬期間は計算に含まれない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間開始(5/10)より前の日付
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-05-10"),
              createdDate: DateTime.parse("2022-05-10"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間開始前なので、休薬期間は0日として計算される
        // 5/1 + 27日 + 0日 = 5/28、翌日 - 1秒 = 5/28 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });

      test("now()が休薬期間中の場合、開始日からnow()までの日数が休薬期間として計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間中(5/10開始、now=5/13なので3日経過)
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-13"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-05-10"),
              createdDate: DateTime.parse("2022-05-10"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間: 5/10〜5/13(now) = 3日
        // 5/1 + 27日 + 3日 = 5/31、翌日 - 1秒 = 5/31 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-01").subtract(const Duration(seconds: 1)));
      });

      test("now()が休薬期間終了後の場合、終了した休薬期間全体が計算に含まれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間終了(5/15)後の日付
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-05-10"),
              createdDate: DateTime.parse("2022-05-10"),
              endDate: DateTime.parse("2022-05-15"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間: 5/10〜5/15 = 5日
        // 5/1 + 27日 + 5日 = 6/2、翌日 - 1秒 = 6/2 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-03").subtract(const Duration(seconds: 1)));
      });

      test("now()が休薬期間開始日当日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 休薬期間開始日と同じ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2022-05-10"),
              createdDate: DateTime.parse("2022-05-10"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間開始日当日は0日として計算される(daysBetween(5/10, 5/10) = 0)
        // 5/1 + 27日 + 0日 = 5/28、翌日 - 1秒 = 5/28 23:59:59
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
      });
    });
  });
  group("#activeRestDuration", () {
    test("restDurationsが空の場合はnullを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.activeRestDuration, isNull);
    });

    test("最後のRestDurationのendDateがnullでbeginDateがnow()より前の場合はそのRestDurationを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-08"),
        createdDate: DateTime.parse("2022-05-08"),
        endDate: null,
      );
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [restDuration],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.activeRestDuration, restDuration);
    });

    test("境界値テスト：最後のRestDurationのbeginDateがnow()と同日の場合はnullを返す（isBeforeは同日を含まない）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-10"),
            createdDate: DateTime.parse("2022-05-10"),
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
      expect(pillSheet.activeRestDuration, isNull);
    });

    test("境界値テスト：最後のRestDurationのbeginDateがnow()の前日の場合はそのRestDurationを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-09"),
        createdDate: DateTime.parse("2022-05-09"),
        endDate: null,
      );
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [restDuration],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.activeRestDuration, restDuration);
    });

    test("最後のRestDurationのbeginDateがnow()より後の場合はnullを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-11"),
            createdDate: DateTime.parse("2022-05-10"),
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
      expect(pillSheet.activeRestDuration, isNull);
    });

    test("最後のRestDurationのendDateが設定されている場合はnullを返す（休薬期間が終了済み）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: "rest_duration_id",
            beginDate: DateTime.parse("2022-05-05"),
            createdDate: DateTime.parse("2022-05-05"),
            endDate: DateTime.parse("2022-05-08"),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.activeRestDuration, isNull);
    });

    test("複数のRestDurationがある場合、最後の要素のみを確認する（最後以外にendDateがnullのものがあっても無視）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-15"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          // 1つ目は終了済み
          RestDuration(
            id: "rest_duration_id_1",
            beginDate: DateTime.parse("2022-05-05"),
            createdDate: DateTime.parse("2022-05-05"),
            endDate: DateTime.parse("2022-05-07"),
          ),
          // 2つ目（最後）も終了済み
          RestDuration(
            id: "rest_duration_id_2",
            beginDate: DateTime.parse("2022-05-10"),
            createdDate: DateTime.parse("2022-05-10"),
            endDate: DateTime.parse("2022-05-12"),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.activeRestDuration, isNull);
    });

    test("複数のRestDurationがある場合、最後の要素がアクティブならそれを返す", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-15"));

      const sheetType = PillSheetType.pillsheet_21;
      final activeRestDuration = RestDuration(
        id: "rest_duration_id_2",
        beginDate: DateTime.parse("2022-05-12"),
        createdDate: DateTime.parse("2022-05-12"),
        endDate: null,
      );
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          // 1つ目は終了済み
          RestDuration(
            id: "rest_duration_id_1",
            beginDate: DateTime.parse("2022-05-05"),
            createdDate: DateTime.parse("2022-05-05"),
            endDate: DateTime.parse("2022-05-07"),
          ),
          // 2つ目（最後）はアクティブ
          activeRestDuration,
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      expect(pillSheet.activeRestDuration, activeRestDuration);
    });
  });
  group("#dates", () {
    test("服用お休みが無いパターン", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      final expected = [
        DateTime.parse("2022-05-01"),
        DateTime.parse("2022-05-02"),
        DateTime.parse("2022-05-03"),
        DateTime.parse("2022-05-04"),
        DateTime.parse("2022-05-05"),
        DateTime.parse("2022-05-06"),
        DateTime.parse("2022-05-07"),
        DateTime.parse("2022-05-08"),
        DateTime.parse("2022-05-09"),
        DateTime.parse("2022-05-10"),
        DateTime.parse("2022-05-11"),
        DateTime.parse("2022-05-12"),
        DateTime.parse("2022-05-13"),
        DateTime.parse("2022-05-14"),
        DateTime.parse("2022-05-15"),
        DateTime.parse("2022-05-16"),
        DateTime.parse("2022-05-17"),
        DateTime.parse("2022-05-18"),
        DateTime.parse("2022-05-19"),
        DateTime.parse("2022-05-20"),
        DateTime.parse("2022-05-21"),
        DateTime.parse("2022-05-22"),
        DateTime.parse("2022-05-23"),
        DateTime.parse("2022-05-24"),
        DateTime.parse("2022-05-25"),
        DateTime.parse("2022-05-26"),
        DateTime.parse("2022-05-27"),
        DateTime.parse("2022-05-28"),
      ];
      expect(actual, expected);
    });
    test("終わってない服用お休みが有るパターン", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(id: firestoreIDGenerator(), beginDate: DateTime.parse("2022-05-08"), createdDate: now()),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      final expected = [
        DateTime.parse("2022-05-01"),
        DateTime.parse("2022-05-02"),
        DateTime.parse("2022-05-03"),
        DateTime.parse("2022-05-04"),
        DateTime.parse("2022-05-05"),
        DateTime.parse("2022-05-06"),
        DateTime.parse("2022-05-07"),
        DateTime.parse("2022-05-10"),
        DateTime.parse("2022-05-11"),
        DateTime.parse("2022-05-12"),
        DateTime.parse("2022-05-13"),
        DateTime.parse("2022-05-14"),
        DateTime.parse("2022-05-15"),
        DateTime.parse("2022-05-16"),
        DateTime.parse("2022-05-17"),
        DateTime.parse("2022-05-18"),
        DateTime.parse("2022-05-19"),
        DateTime.parse("2022-05-20"),
        DateTime.parse("2022-05-21"),
        DateTime.parse("2022-05-22"),
        DateTime.parse("2022-05-23"),
        DateTime.parse("2022-05-24"),
        DateTime.parse("2022-05-25"),
        DateTime.parse("2022-05-26"),
        DateTime.parse("2022-05-27"),
        DateTime.parse("2022-05-28"),
        DateTime.parse("2022-05-29"),
        DateTime.parse("2022-05-30"),
      ];
      expect(actual, expected);
    });
    test("終わっている服用お休みが有るパターン", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-08"),
            endDate: DateTime.parse("2022-05-09"),
            createdDate: now(),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      final expected = [
        DateTime.parse("2022-05-01"),
        DateTime.parse("2022-05-02"),
        DateTime.parse("2022-05-03"),
        DateTime.parse("2022-05-04"),
        DateTime.parse("2022-05-05"),
        DateTime.parse("2022-05-06"),
        DateTime.parse("2022-05-07"),
        DateTime.parse("2022-05-09"),
        DateTime.parse("2022-05-10"),
        DateTime.parse("2022-05-11"),
        DateTime.parse("2022-05-12"),
        DateTime.parse("2022-05-13"),
        DateTime.parse("2022-05-14"),
        DateTime.parse("2022-05-15"),
        DateTime.parse("2022-05-16"),
        DateTime.parse("2022-05-17"),
        DateTime.parse("2022-05-18"),
        DateTime.parse("2022-05-19"),
        DateTime.parse("2022-05-20"),
        DateTime.parse("2022-05-21"),
        DateTime.parse("2022-05-22"),
        DateTime.parse("2022-05-23"),
        DateTime.parse("2022-05-24"),
        DateTime.parse("2022-05-25"),
        DateTime.parse("2022-05-26"),
        DateTime.parse("2022-05-27"),
        DateTime.parse("2022-05-28"),
        DateTime.parse("2022-05-29"),
      ];
      expect(actual, expected);
    });
    test("服用お休みが複数有るパターン", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-08"),
            endDate: DateTime.parse("2022-05-09"),
            createdDate: now(),
          ),
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-12"),
            endDate: DateTime.parse("2022-05-14"),
            createdDate: now(),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      final expected = [
        DateTime.parse("2022-05-01"),
        DateTime.parse("2022-05-02"),
        DateTime.parse("2022-05-03"),
        DateTime.parse("2022-05-04"),
        DateTime.parse("2022-05-05"),
        DateTime.parse("2022-05-06"),
        DateTime.parse("2022-05-07"),
        DateTime.parse("2022-05-09"),
        DateTime.parse("2022-05-10"),
        DateTime.parse("2022-05-11"),
        DateTime.parse("2022-05-14"),
        DateTime.parse("2022-05-15"),
        DateTime.parse("2022-05-16"),
        DateTime.parse("2022-05-17"),
        DateTime.parse("2022-05-18"),
        DateTime.parse("2022-05-19"),
        DateTime.parse("2022-05-20"),
        DateTime.parse("2022-05-21"),
        DateTime.parse("2022-05-22"),
        DateTime.parse("2022-05-23"),
        DateTime.parse("2022-05-24"),
        DateTime.parse("2022-05-25"),
        DateTime.parse("2022-05-26"),
        DateTime.parse("2022-05-27"),
        DateTime.parse("2022-05-28"),
        DateTime.parse("2022-05-29"),
        DateTime.parse("2022-05-30"),
        DateTime.parse("2022-05-31"),
      ];
      expect(actual, expected);
    });
    test("PillSheetType.pillsheet_24_0の場合は24日分の日付が返る", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_24_0;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      expect(actual.length, 24);
      expect(actual.first, DateTime.parse("2022-05-01"));
      expect(actual.last, DateTime.parse("2022-05-24"));
    });
    test("PillSheetType.pillsheet_21_0の場合は21日分の日付が返る", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21_0;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      expect(actual.length, 21);
      expect(actual.first, DateTime.parse("2022-05-01"));
      expect(actual.last, DateTime.parse("2022-05-21"));
    });
    test("境界値：休薬期間の開始日が最初のピルの日付と同じ場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-01"),
            endDate: DateTime.parse("2022-05-03"),
            createdDate: now(),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      // 休薬期間が開始日と同じなので、最初のピルは2日後の05-03になる
      expect(actual[0], DateTime.parse("2022-05-03"));
      expect(actual[1], DateTime.parse("2022-05-04"));
      expect(actual.length, 28);
    });
    test("境界値：休薬期間の開始日がピルシートの最後の日付の場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-30"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-28"),
            endDate: DateTime.parse("2022-05-30"),
            createdDate: now(),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );
      final actual = pillSheet.dates;
      // 27日目までは通常通り
      expect(actual[26], DateTime.parse("2022-05-27"));
      // 28日目は休薬期間の影響で05-30になる
      expect(actual[27], DateTime.parse("2022-05-30"));
    });
  });
  group("#displayPillTakeDate", () {
    // displayPillTakeDateはdates[pillNumberInPillSheet - 1]を返すメソッド
    // ピル番号から服用予定日を取得する

    group("休薬期間なしの場合", () {
      test("ピル番号1の場合はbeginingDateを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2022-05-01"));
      });

      test("ピル番号がtotalCountの場合は最終日を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // pillsheet_21のtotalCountは28
        expect(pillSheet.displayPillTakeDate(28), DateTime.parse("2022-05-28"));
      });

      test("中間のピル番号の場合は正しい日付を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // ピル番号10 = beginingDate + 9日 = 2022-05-10
        expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2022-05-10"));
        expect(pillSheet.displayPillTakeDate(15), DateTime.parse("2022-05-15"));
        expect(pillSheet.displayPillTakeDate(21), DateTime.parse("2022-05-21"));
      });
    });

    group("休薬期間あり（終了していない）の場合", () {
      test("休薬期間前のピル番号は通常の日付を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2022-05-08"),
              createdDate: now(),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間は05-08から開始、今日は05-10
        // ピル番号1〜7は休薬期間前なので通常の日付
        expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2022-05-01"));
        expect(pillSheet.displayPillTakeDate(7), DateTime.parse("2022-05-07"));
      });

      test("休薬期間後のピル番号は休薬日数分ずれた日付を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2022-05-08"),
              createdDate: now(),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間は05-08から開始、今日は05-10なので2日間休薬
        // ピル番号8は本来05-08だが、2日分ずれて05-10になる
        expect(pillSheet.displayPillTakeDate(8), DateTime.parse("2022-05-10"));
        expect(pillSheet.displayPillTakeDate(9), DateTime.parse("2022-05-11"));
      });
    });

    group("休薬期間あり（終了済み）の場合", () {
      test("休薬期間前のピル番号は通常の日付を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2022-05-08"),
              endDate: DateTime.parse("2022-05-10"),
              createdDate: now(),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間は05-08から05-10まで（2日間）
        expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2022-05-01"));
        expect(pillSheet.displayPillTakeDate(7), DateTime.parse("2022-05-07"));
      });

      test("休薬期間後のピル番号は休薬日数分ずれた日付を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2022-05-08"),
              endDate: DateTime.parse("2022-05-10"),
              createdDate: now(),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 休薬期間は05-08から05-10まで（2日間）
        // ピル番号8は本来05-08だが、2日分ずれて05-10になる
        expect(pillSheet.displayPillTakeDate(8), DateTime.parse("2022-05-10"));
        expect(pillSheet.displayPillTakeDate(9), DateTime.parse("2022-05-11"));
        expect(pillSheet.displayPillTakeDate(10), DateTime.parse("2022-05-12"));
      });
    });

    group("複数の休薬期間がある場合", () {
      test("各休薬期間の日数分累積してずれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-20"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2022-05-05"),
              endDate: DateTime.parse("2022-05-06"),
              createdDate: now(),
            ),
            RestDuration(
              id: firestoreIDGenerator(),
              beginDate: DateTime.parse("2022-05-10"),
              endDate: DateTime.parse("2022-05-12"),
              createdDate: now(),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 最初の休薬期間: 05-05から05-06まで（1日間）
        // 2番目の休薬期間: 05-10から05-12まで（2日間）
        expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2022-05-01"));
        expect(pillSheet.displayPillTakeDate(4), DateTime.parse("2022-05-04"));
        // ピル番号5は本来05-05だが、1日分ずれて05-06になる
        expect(pillSheet.displayPillTakeDate(5), DateTime.parse("2022-05-06"));
        // ピル番号8は本来05-08だが、1日分ずれて05-09になり、さらに2日分ずれて05-12になる
        expect(pillSheet.displayPillTakeDate(8), DateTime.parse("2022-05-12"));
      });
    });

    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_24_0（24錠タイプ）の場合はピル番号24が最終日", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-24"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2022-05-01"));
        expect(pillSheet.displayPillTakeDate(24), DateTime.parse("2022-05-24"));
      });

      test("pillsheet_21_0（21錠タイプ）の場合はピル番号21が最終日", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-21"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(pillSheet.displayPillTakeDate(1), DateTime.parse("2022-05-01"));
        expect(pillSheet.displayPillTakeDate(21), DateTime.parse("2022-05-21"));
      });
    });

    group("境界値テスト", () {
      test("ピル番号0の場合はRangeErrorが発生する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // ピル番号0は配列インデックス-1となりRangeError
        expect(() => pillSheet.displayPillTakeDate(0), throwsRangeError);
      });

      test("ピル番号がtotalCountを超える場合はRangeErrorが発生する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // pillsheet_21のtotalCountは28なので、ピル番号29は範囲外
        expect(() => pillSheet.displayPillTakeDate(29), throwsRangeError);
      });

      test("負のピル番号の場合はRangeErrorが発生する", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(() => pillSheet.displayPillTakeDate(-1), throwsRangeError);
      });
    });
  });
  group("#buildDates", () {
    test("estimatedEventCausingDateが指定された場合、その日付を上限として計算する", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-20"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-08"),
            endDate: null, // 継続中
            createdDate: now(),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );

      // estimatedEventCausingDateを2022-05-15に設定
      // 休薬期間は05-08から継続中だが、estimatedEventCausingDateが05-15なので
      // 休薬期間は05-08から05-15までの7日間として計算される
      final actualWithEstimatedDate = pillSheet.buildDates(estimatedEventCausingDate: DateTime.parse("2022-05-15"));

      // 1日目〜7日目は通常通り
      expect(actualWithEstimatedDate[0], DateTime.parse("2022-05-01"));
      expect(actualWithEstimatedDate[6], DateTime.parse("2022-05-07"));
      // 8日目は休薬期間の影響で05-15になる (beginDate:05-08 から estimatedEventCausingDate:05-15 まで7日間休薬)
      expect(actualWithEstimatedDate[7], DateTime.parse("2022-05-15"));
    });
    test("estimatedEventCausingDateがnullの場合はtodayを上限として計算する", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-08"),
            endDate: null, // 継続中
            createdDate: now(),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
      );

      // estimatedEventCausingDateを指定しない（nullの場合）
      final actualWithoutEstimatedDate = pillSheet.buildDates();
      // todayが2022-05-10なので、休薬期間は05-08から05-10までの2日間として計算される
      // 8日目は05-10になる
      expect(actualWithoutEstimatedDate[7], DateTime.parse("2022-05-10"));

      // dates getter と同じ結果になるはず
      expect(actualWithoutEstimatedDate, pillSheet.dates);
    });
  });
  group("#summarizedRestDuration", () {
    test("restDurations isEmpty", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      expect(summarizedRestDuration(restDurations: [], upperDate: today()), 0);
    });
    test("last restDuration is not ended", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      final restDurations = [
        RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2022-05-07"),
          createdDate: DateTime.parse("2022-05-07"),
        ),
      ];
      expect(summarizedRestDuration(restDurations: restDurations, upperDate: today()), 3);
    });
    test("last restDuration is ended", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      final restDurations = [
        RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime.parse("2022-05-07"),
          createdDate: DateTime.parse("2022-05-07"),
          endDate: DateTime.parse("2022-05-08"),
        ),
      ];
      expect(summarizedRestDuration(restDurations: restDurations, upperDate: today()), 1);
    });
  });

  group("#pillNumberFor", () {
    group("基本ケース（休薬期間なし）", () {
      test("targetDate = beginDate の場合は1番を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-14")), 1);
      });

      test("targetDate = beginDate + 1日 の場合は2番を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15")), 2);
      });

      test("targetDate = beginDate + 5日 の場合は6番を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-19")), 6);
      });

      test("targetDate = beginDate + 20日（21日シートの最終日）の場合は21番を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-04"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-10-04")), 21);
      });
    });

    group("境界値テスト", () {
      test("targetDate < beginDate の場合は1を返す（max関数による下限保護）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-13")), 1);
      });

      test("targetDate が beginDate より10日前の場合でも1を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-04"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-04")), 1);
      });

      test("targetDate がピルシートの範囲を超えている場合も計算通りの値を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        // 2020-09-14 から 2020-10-15 は32日間なので32番を返す
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-10-15")), 32);
      });
    });

    group("休薬期間あり（終了済み）の場合", () {
      test("休薬期間が3日間の場合、その分だけピル番号が減る", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-13"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/28 は28日間、休薬期間3日を引くと25番
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 25);
      });

      test("targetDate が休薬期間開始日より前の場合、休薬期間は計算に含まれない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-09"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-13"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/9 は9日間、休薬期間は未来なので計算に含まれない
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-09")), 9);
      });

      test("targetDate が休薬期間開始日と同日の場合、休薬期間は計算に含まれない", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-13"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // summarizedRestDurationはbeginDateがupperDateより前の場合のみカウントするので、同日は含まれない
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-10")), 10);
      });

      test("targetDate が休薬期間終了日と同日の場合、休薬期間の一部が計算に含まれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-13"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              endDate: DateTime.parse("2020-09-13"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/13 は13日間、休薬期間3日（9/10-9/13）を引くと10番
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-13")), 10);
      });
    });

    group("休薬期間あり（継続中）の場合", () {
      test("継続中の休薬期間がある場合、targetDateまでの日数が休薬期間として計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
              // endDate が null なので継続中
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/15 は15日間、休薬期間5日（9/10から9/15まで）を引くと10番
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15")), 10);
      });

      test("targetDate が休薬期間開始日と同日の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-10"),
              createdDate: DateTime.parse("2020-09-10"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate = 休薬期間開始日の場合、休薬期間は計算に含まれない
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-10")), 10);
      });
    });

    group("複数の休薬期間がある場合", () {
      test("2つの終了済み休薬期間がある場合、両方の期間がピル番号から引かれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/28 は28日間、休薬期間2日（9/5-9/7）+ 3日（9/15-9/18）= 5日を引くと23番
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 23);
      });

      test("1つ目の休薬期間のみがtargetDateより前の場合、1つ目のみ計算に含まれる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-12"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              endDate: DateTime.parse("2020-09-18"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/12 は12日間、休薬期間2日（9/5-9/7）のみを引くと10番
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-12")), 10);
      });

      test("1つ目が終了済み、2つ目が継続中の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
              // endDate が null なので継続中
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 9/1 から 9/20 は20日間、休薬期間2日（9/5-9/7）+ 5日（9/15-9/20）= 7日を引くと13番
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-20")), 13);
      });
    });

    group("異なるPillSheetTypeでのテスト", () {
      test("pillsheet_28_0（28錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 28);
      });

      test("pillsheet_28_4（24錠+4日偽薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 28);
      });

      test("pillsheet_24_rest_4（24錠+休薬4日）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_24_rest_4;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-24")), 24);
      });

      test("pillsheet_24_0（24錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-24"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-24")), 24);
      });

      test("pillsheet_21_0（21錠すべて実薬）の場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-21"));

        const sheetType = PillSheetType.pillsheet_21_0;
        final model = PillSheet(
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
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-21")), 21);
      });
    });

    group("日付の時刻部分のテスト", () {
      test("同じ日付でも時刻が異なる場合、同じピル番号を返す（日付ベースの計算）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
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
        // 午前0時と午後11時59分で同じピル番号を返す
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15T00:00:00")), 2);
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15T23:59:59")), 2);
      });
    });
  });
}
