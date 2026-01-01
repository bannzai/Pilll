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
  });
}
