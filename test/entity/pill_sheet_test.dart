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
    group("totalCountを超えた日の場合", () {
      test("21錠タイプで22日目の場合は22番を返す（上限がない）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));

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
        expect(model.todayPillNumber, 22);
      });
      test("28錠タイプで30日目の場合は30番を返す（上限がない）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-30"));

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
        expect(model.todayPillNumber, 30);
      });
    });
    group("時刻を含むDateTimeの場合", () {
      test("同じ日の異なる時刻でも日付レベルで比較される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 23:59:59 という夜遅い時刻
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-06T23:59:59"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          // 朝の時刻で開始
          beginingDate: DateTime.parse("2020-09-01T08:00:00"),
          lastTakenDate: DateTime.parse("2020-09-05T20:00:00"),
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
      test("開始日と同日で時刻が開始時刻より前でも1番を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 朝6時
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01T06:00:00"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          // 朝8時に開始
          beginingDate: DateTime.parse("2020-09-01T08:00:00"),
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
    });
    group("月をまたぐ場合", () {
      test("9/30開始で10/1が2番目", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-30"),
          lastTakenDate: DateTime.parse("2020-09-30"),
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
      test("9/15開始で10/15が31番目", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-15"),
          lastTakenDate: DateTime.parse("2020-10-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 31);
      });
    });
    group("年をまたぐ場合", () {
      test("12/31開始で1/1が2番目", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-12-31"),
          lastTakenDate: DateTime.parse("2020-12-31"),
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
      test("12/15開始で1/15が32番目", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2021-01-15"));

        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-12-15"),
          lastTakenDate: DateTime.parse("2021-01-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 32);
      });
    });
    group("うるう年の場合", () {
      test("2/28開始で2/29が2番目（うるう年）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-02-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-02-28"),
          lastTakenDate: DateTime.parse("2020-02-28"),
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
      test("2/28開始で3/1が3番目（うるう年）", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-03-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-02-28"),
          lastTakenDate: DateTime.parse("2020-02-29"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 3);
      });
    });
    group("異なるPillSheetTypeの場合", () {
      test("24錠タイプ（pillsheet_24_0）でも正しく計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-10"));

        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
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
        );
        expect(model.todayPillNumber, 10);
      });
      test("28錠+4日偽薬タイプ（pillsheet_28_4）でも正しく計算される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-15"));

        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-14"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.todayPillNumber, 15);
      });
    });
  });
  group("#pillNumberFor", () {
    group("基本的なケース（休薬期間なし）", () {
      test("targetDateが開始日と同日の場合は1番を返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-01")), 1);
      });

      test("targetDateが開始日の翌日の場合は2番を返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-02")), 2);
      });

      test("targetDateが開始日から6日目の場合は6番を返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-06")), 6);
      });

      test("targetDateが開始日より前の場合はmax関数により1を返す（下限保護）", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-08-31")), 1);
      });

      test("targetDateが開始日の2日前の場合でも1を返す（下限保護）", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-08-30")), 1);
      });

      test("境界値テスト：21日目の場合は21番を返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-21")), 21);
      });

      test("境界値テスト：28日目の場合は28番を返す", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 28);
      });

      test("ピルシート範囲外の日付（29日目以降）でも計算結果を返す（上限制限なし）", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-29")), 29);
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-30")), 30);
      });
    });

    group("時刻を含む境界値テスト", () {
      test("targetDateの00:00:00とtargetDateの23:59:59は同じピル番号を返す", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime(2020, 9, 10, 0, 0, 0)), 10);
        expect(model.pillNumberFor(targetDate: DateTime(2020, 9, 10, 23, 59, 59)), 10);
      });

      test("開始日に時刻が含まれていてもtargetDateの日付で正しく計算される", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime(2020, 9, 1, 10, 30, 0),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // 開始日の時刻に関係なく、日付ベースで計算される
        expect(model.pillNumberFor(targetDate: DateTime(2020, 9, 1, 0, 0, 0)), 1);
        expect(model.pillNumberFor(targetDate: DateTime(2020, 9, 2, 8, 0, 0)), 2);
      });
    });

    group("休薬期間がある場合", () {
      test("休薬期間が終了していない場合、targetDateが休薬開始後だと休薬日数分が差し引かれる", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-15
        // 休薬期間開始: 2020-09-11
        // 通常なら15日目だが、休薬期間が4日間（9/11～9/15）あるので
        // pillNumber = 15 - 4 + 1 - 1 = 11（daysBetween(9/1, 9/15) = 14, summarizedRestDuration = 4）
        // pillNumber = 14 - 4 + 1 = 11
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15")), 11);
      });

      test("休薬期間が終了している場合、休薬期間の日数のみが差し引かれる", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
              endDate: DateTime.parse("2020-09-14"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-15
        // 休薬期間: 9/11～9/14（3日間）
        // pillNumber = daysBetween(9/1, 9/15) - 3 + 1 = 14 - 3 + 1 = 12
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15")), 12);
      });

      test("境界値テスト：targetDateが休薬期間開始日より前の場合は休薬期間の影響を受けない", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-10（休薬開始前）
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-10")), 10);
      });

      test("境界値テスト：targetDateが休薬期間開始日と同日の場合、休薬期間の影響は0日", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-11（休薬開始日）
        // summarizedRestDurationはupperDateより前のbeginDateのみカウント
        // 9/11のbeginDate == 9/11のtargetDate なので、休薬期間は計算されない
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-11")), 11);
      });

      test("境界値テスト：targetDateが休薬期間開始日の翌日の場合は1日分差し引かれる", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-12
        // daysBetween(9/1, 9/12) = 11, summarizedRestDuration = 1（9/11～9/12）
        // pillNumber = 11 - 1 + 1 = 11
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-12")), 11);
      });

      test("境界値テスト：targetDateが休薬期間終了日と同日の場合", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
              endDate: DateTime.parse("2020-09-14"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-14（休薬終了日）
        // daysBetween(9/1, 9/14) = 13, summarizedRestDuration = 3（9/11～9/14）
        // pillNumber = 13 - 3 + 1 = 11
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-14")), 11);
      });

      test("境界値テスト：targetDateが休薬期間終了日の翌日の場合", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id",
              beginDate: DateTime.parse("2020-09-11"),
              createdDate: DateTime.parse("2020-09-11"),
              endDate: DateTime.parse("2020-09-14"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-15（休薬終了日の翌日）
        // daysBetween(9/1, 9/15) = 14, summarizedRestDuration = 3（9/11～9/14）
        // pillNumber = 14 - 3 + 1 = 12
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-15")), 12);
      });
    });

    group("複数の休薬期間がある場合", () {
      test("複数の休薬期間がすべて終了している場合、合計日数が差し引かれる", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-06"),
              createdDate: DateTime.parse("2020-09-06"),
              endDate: DateTime.parse("2020-09-08"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
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
        // targetDate: 2020-09-20
        // 休薬期間1: 9/6～9/8（2日間）
        // 休薬期間2: 9/15～9/17（2日間）
        // daysBetween(9/1, 9/20) = 19, summarizedRestDuration = 4
        // pillNumber = 19 - 4 + 1 = 16
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-20")), 16);
      });

      test("最初の休薬期間のみ終了していて、2番目の休薬期間が継続中の場合", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-06"),
              createdDate: DateTime.parse("2020-09-06"),
              endDate: DateTime.parse("2020-09-08"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
              beginDate: DateTime.parse("2020-09-15"),
              createdDate: DateTime.parse("2020-09-15"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        // targetDate: 2020-09-20
        // 休薬期間1: 9/6～9/8（2日間）
        // 休薬期間2: 9/15～（継続中、9/20まで5日間）
        // daysBetween(9/1, 9/20) = 19, summarizedRestDuration = 2 + 5 = 7
        // pillNumber = 19 - 7 + 1 = 13
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-20")), 13);
      });

      test("境界値テスト：targetDateが最初の休薬期間と2番目の休薬期間の間の場合", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-06"),
              createdDate: DateTime.parse("2020-09-06"),
              endDate: DateTime.parse("2020-09-08"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
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
        // targetDate: 2020-09-12（休薬期間1終了後、休薬期間2開始前）
        // 休薬期間1: 9/6～9/8（2日間）
        // 休薬期間2: まだ開始していないので影響なし
        // daysBetween(9/1, 9/12) = 11, summarizedRestDuration = 2
        // pillNumber = 11 - 2 + 1 = 10
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-12")), 10);
      });

      test("境界値テスト：targetDateが最初の休薬期間より前の場合、休薬期間の影響を受けない", () {
        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          restDurations: [
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-06"),
              createdDate: DateTime.parse("2020-09-06"),
              endDate: DateTime.parse("2020-09-08"),
            ),
            RestDuration(
              id: "rest_duration_id_2",
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
        // targetDate: 2020-09-05（休薬期間1開始前）
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-05")), 5);
      });
    });

    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_28_0（28錠すべて実薬）の場合", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 28);
      });

      test("pillsheet_24_0（24錠すべて実薬）の場合", () {
        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
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
        const sheetType = PillSheetType.pillsheet_21_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-21")), 21);
      });

      test("pillsheet_28_4（24錠+4日偽薬）の場合", () {
        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.pillNumberFor(targetDate: DateTime.parse("2020-09-28")), 28);
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
    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_28_7（21錠実薬+7錠偽薬）: 28日目はアクティブ、29日目は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

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

        // 28日目（2020-09-28）はアクティブ
        expect(model.isActive, true);

        // 29日目（2020-09-29）は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));
        expect(model.isActive, false);
      });

      test("pillsheet_28_4（24錠実薬+4錠偽薬）: 28日目はアクティブ、29日目は非アクティブ", () {
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

        // 28日目（2020-09-28）はアクティブ
        expect(model.isActive, true);

        // 29日目（2020-09-29）は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));
        expect(model.isActive, false);
      });

      test("pillsheet_24_rest_4（24錠+4日休薬）: 28日目はアクティブ、29日目は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

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

        // 28日目（2020-09-28）はアクティブ
        expect(model.isActive, true);

        // 29日目（2020-09-29）は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));
        expect(model.isActive, false);
      });

      test("pillsheet_21_0（21錠すべて実薬）: 21日目はアクティブ、22日目は非アクティブ", () {
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

        // 21日目（2020-09-21）はアクティブ
        expect(model.isActive, true);

        // 22日目（2020-09-22）は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-22"));
        expect(model.isActive, false);
      });

      test("pillsheet_24_0（24錠すべて実薬）: 24日目はアクティブ、25日目は非アクティブ", () {
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

        // 24日目（2020-09-24）はアクティブ
        expect(model.isActive, true);

        // 25日目（2020-09-25）は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-25"));
        expect(model.isActive, false);
      });

      test("pillsheet_28_0（28錠すべて実薬）: 28日目はアクティブ、29日目は非アクティブ", () {
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

        // 28日目（2020-09-28）はアクティブ
        expect(model.isActive, true);

        // 29日目（2020-09-29）は非アクティブ
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));
        expect(model.isActive, false);
      });
    });
  });
  group("#isActiveFor", () {
    // isActiveFor(date) は beginingDate から estimatedEndTakenDate の範囲内に date が含まれるかを判定
    // isActive は isActiveFor(now()) を呼び出しているので、isActiveFor はより汎用的なメソッド

    group("基本的なアクティブ判定", () {
      test("シート期間の中間日を渡した場合はアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

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
        // 2020-09-15 は 9/1 開始の 28日シートの中間日
        expect(model.isActiveFor(DateTime.parse("2020-09-15")), true);
      });

      test("過去の日付を渡した場合でも範囲内ならアクティブ", () {
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
        // 2020-09-05 は範囲内
        expect(model.isActiveFor(DateTime.parse("2020-09-05")), true);
      });
    });

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
    });

    group("終了日の境界値テスト", () {
      test("終了日（28日目）はアクティブ", () {
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
        // pillsheet_21 は totalCount=28 なので、9/1開始で9/28が終了日
        expect(model.isActiveFor(DateTime.parse("2020-09-28")), true);
      });

      test("終了日の23:59:59はアクティブ", () {
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
        expect(model.isActiveFor(DateTime(2020, 9, 28, 23, 59, 59)), true);
      });

      test("終了日の翌日は非アクティブ", () {
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
        expect(model.isActiveFor(DateTime.parse("2020-09-29")), false);
      });
    });

    group("異なるPillSheetTypeの場合", () {
      test("pillsheet_28_0（28錠すべて実薬）の場合、28日目はアクティブ", () {
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
        expect(model.isActiveFor(DateTime.parse("2020-09-28")), true);
        expect(model.isActiveFor(DateTime.parse("2020-09-29")), false);
      });

      test("pillsheet_21_0（21錠すべて実薬）の場合、21日目はアクティブ、22日目は非アクティブ", () {
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
        expect(model.isActiveFor(DateTime.parse("2020-09-21")), true);
        expect(model.isActiveFor(DateTime.parse("2020-09-22")), false);
      });

      test("pillsheet_24_0（24錠すべて実薬）の場合、24日目はアクティブ、25日目は非アクティブ", () {
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
        expect(model.isActiveFor(DateTime.parse("2020-09-24")), true);
        expect(model.isActiveFor(DateTime.parse("2020-09-25")), false);
      });
    });

    group("RestDurationがある場合", () {
      test("休薬期間中は終了日が延長されるため、元の終了日翌日でもアクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 今日を9/29に設定（estimatedEndTakenDateの計算に影響）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            // 9/20-9/22の休薬期間（2日間）
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
        // 元の終了日は9/28だが、2日間の休薬で9/30に延長
        expect(model.isActiveFor(DateTime.parse("2020-09-29")), true);
        expect(model.isActiveFor(DateTime.parse("2020-09-30")), true);
      });

      test("休薬期間終了後、延長された終了日の翌日は非アクティブ", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-01"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            // 9/20-9/22の休薬期間（2日間）
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
        // 元の終了日は9/28だが、2日間の休薬で9/30に延長、10/1は非アクティブ
        expect(model.isActiveFor(DateTime.parse("2020-10-01")), false);
      });

      test("継続中の休薬期間がある場合は終了日が今日まで延長される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 今日を10/5に設定（休薬期間が継続中）
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-05"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            // 9/20から継続中の休薬期間（endDateがnull）
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
        // 休薬が継続中なので、今日(10/5)はまだアクティブ
        expect(model.isActiveFor(DateTime.parse("2020-10-05")), true);
      });
    });

    group("複数のRestDurationがある場合", () {
      test("複数の休薬期間により終了日が延長される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-02"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            // 休薬1: 9/5-9/7 → 2日間延長
            RestDuration(
              id: "rest_duration_id_1",
              beginDate: DateTime.parse("2020-09-05"),
              createdDate: DateTime.parse("2020-09-05"),
              endDate: DateTime.parse("2020-09-07"),
            ),
            // 休薬2: 9/15-9/17 → 2日間延長
            RestDuration(
              id: "rest_duration_id_2",
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
        // 元の終了日は9/28、合計4日延長で10/2が終了日
        expect(model.isActiveFor(DateTime.parse("2020-10-02")), true);
        expect(model.isActiveFor(DateTime.parse("2020-10-03")), false);
      });

      test("複数の休薬期間の境界値テスト", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-10-03"));

        const sheetType = PillSheetType.pillsheet_21;
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
        // 延長された終了日の翌日は非アクティブ
        expect(model.isActiveFor(DateTime.parse("2020-10-03")), false);
      });
    });

    group("時刻を含む境界値テスト", () {
      test("開始日の00:00:00はアクティブ", () {
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
        expect(model.isActiveFor(DateTime(2020, 9, 1, 0, 0, 0)), true);
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
    test("開始日当日で時刻部分がある場合はtrueを返す（beginingDate.date()は00:00:00に正規化されるため）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      // now()に時刻部分があると、beginingDate.date() = 00:00:00 < now() = 12:00:00 となりtrue
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 1, 12, 0, 0));

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
    test("開始日当日の深夜0時1秒の場合はtrueを返す（境界値: 1秒でも経過すればtrue）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 1, 0, 0, 1));

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
    test("開始日当日の23:59:59の場合はtrueを返す", () {
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
      expect(model.isBegan, true);
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
        // 開始日: 9/1、今日: 9/24、休薬期間: 9/5-9/6（9/5の1日間休薬、9/6に復帰）
        // todayPillNumber = daysBetween(9/1, 9/24) - 1 + 1 = 23 - 1 + 1 = 23
        // dosingPeriod = 21 なので、23 > 21 → true
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
        // 開始日: 9/1、今日: 9/22、休薬期間: 9/10-9/11（9/10の1日間休薬、9/11に復帰）
        // todayPillNumber = daysBetween(9/1, 9/22) - 1 + 1 = 21 - 1 + 1 = 21
        // dosingPeriod = 21 なので、21 > 21 → false
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
        // 開始日: 9/1、今日: 9/23、休薬期間: 9/10-9/11（9/10の1日間休薬、9/11に復帰）
        // todayPillNumber = daysBetween(9/1, 9/23) - 1 + 1 = 22 - 1 + 1 = 22
        // dosingPeriod = 21 なので、22 > 21 → true
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
        expect(model.todayPillNumber, 22);
        expect(sheetType.dosingPeriod, 21);
        expect(model.inNotTakenDuration, true);
      });
    });
  });
  group("#pillSheetHasRestOrFakeDuration", () {
    // pillSheetHasRestOrFakeDuration は pillSheetType.hasRestOrFakeDuration を返す
    // hasRestOrFakeDuration は totalCount != dosingPeriod で判定される
    // すべてのPillSheetTypeをswitchで網羅してテストする
    for (final sheetType in PillSheetType.values) {
      group('PillSheetType.${sheetType.name}の場合', () {
        test('期待値が正しい', () {
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: null,
            createdAt: DateTime.parse("2020-09-01"),
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
          );
          // hasRestOrFakeDuration は totalCount != dosingPeriod
          final expectedValue = sheetType.totalCount != sheetType.dosingPeriod;
          switch (sheetType) {
            case PillSheetType.pillsheet_21:
              // 28錠中21錠が実薬、7日間休薬 → true
              expect(model.pillSheetHasRestOrFakeDuration, true);
              expect(expectedValue, true);
            case PillSheetType.pillsheet_28_4:
              // 28錠中24錠が実薬、4錠が偽薬 → true
              expect(model.pillSheetHasRestOrFakeDuration, true);
              expect(expectedValue, true);
            case PillSheetType.pillsheet_28_7:
              // 28錠中21錠が実薬、7錠が偽薬 → true
              expect(model.pillSheetHasRestOrFakeDuration, true);
              expect(expectedValue, true);
            case PillSheetType.pillsheet_28_0:
              // 28錠すべてが実薬 → false
              expect(model.pillSheetHasRestOrFakeDuration, false);
              expect(expectedValue, false);
            case PillSheetType.pillsheet_24_0:
              // 24錠すべてが実薬 → false
              expect(model.pillSheetHasRestOrFakeDuration, false);
              expect(expectedValue, false);
            case PillSheetType.pillsheet_21_0:
              // 21錠すべてが実薬 → false
              expect(model.pillSheetHasRestOrFakeDuration, false);
              expect(expectedValue, false);
            case PillSheetType.pillsheet_24_rest_4:
              // 28錠中24錠が実薬、4日間休薬 → true
              expect(model.pillSheetHasRestOrFakeDuration, true);
              expect(expectedValue, true);
          }
        });
      });
    }
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

    group("異なるPillSheetTypeでの動作", () {
      test("24錠型（pillsheet_24_0）で最後まで服用した場合は24番を返す", () {
        const sheetType = PillSheetType.pillsheet_24_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"),
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.lastTakenOrZeroPillNumber, 24);
      });
      test("28錠型（pillsheet_28_0）で最後まで服用した場合は28番を返す", () {
        const sheetType = PillSheetType.pillsheet_28_0;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.lastTakenOrZeroPillNumber, 28);
      });
      test("24錠+4日偽薬型（pillsheet_28_4）で偽薬期間も含めて28番まで服用した場合", () {
        // pillsheet_28_4はtotalCount=28, dosingPeriod=24
        // 偽薬期間の4錠も含めて28番目を服用した場合
        const sheetType = PillSheetType.pillsheet_28_4;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.lastTakenOrZeroPillNumber, 28);
      });
    });

    group("totalCountとの境界値", () {
      test("totalCountと一致する番号まで服用した場合", () {
        const sheetType = PillSheetType.pillsheet_21_0;
        // pillsheet_21_0はtotalCount=21, dosingPeriod=21
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-21"),
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.lastTakenOrZeroPillNumber, 21);
      });
      test("24錠+4日休薬型（pillsheet_24_rest_4）で24錠目（実薬最終日）を服用した場合", () {
        // pillsheet_24_rest_4はtotalCount=28, dosingPeriod=24
        // 実薬24錠を服用し、休薬期間に入る前の最終服用
        const sheetType = PillSheetType.pillsheet_24_rest_4;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-24"),
          createdAt: DateTime.parse("2020-09-01"),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
        );
        expect(model.lastTakenOrZeroPillNumber, 24);
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

    group("時刻境界値テスト", () {
      test("同日だがlastTakenDateの時刻がbeginingDateより前の場合はnullを返す", () {
        // lastTakenPillNumber は lastTakenDate.isBefore(beginingDate) で時刻も含めて比較している
        // 同日でも時刻が前であればnullを返す
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime(2020, 9, 14, 12, 0, 0),
          lastTakenDate: DateTime(2020, 9, 14, 10, 0, 0),
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
      test("同日でlastTakenDateの時刻がbeginingDateより後の場合は1を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime(2020, 9, 14, 10, 0, 0),
          lastTakenDate: DateTime(2020, 9, 14, 12, 0, 0),
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
      test("同日で同時刻の場合は1を返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-14"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime(2020, 9, 14, 12, 0, 0),
          lastTakenDate: DateTime(2020, 9, 14, 12, 0, 0),
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

    group("RestDuration（休薬期間）がある場合", () {
      group("終了済みのRestDuration", () {
        test("28錠タイプで休薬期間中断後に全て服用完了 - isTakenAll は true を返す", () {
          // 28錠シートで5日間の休薬期間がある場合
          // 休薬期間分だけ日付がずれるので、最終服用日は開始日+27日+休薬5日=2020-10-03
          const sheetType = PillSheetType.pillsheet_28_0;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-10-03"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-15"),
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
          expect(model.isTakenAll, true);
        });

        test("28錠タイプで休薬期間中断後も途中まで服用 - isTakenAll は false を返す", () {
          const sheetType = PillSheetType.pillsheet_28_0;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-20"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                endDate: DateTime.parse("2020-09-15"),
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
          expect(model.isTakenAll, false);
        });

        test("21錠タイプで複数回の休薬期間後に全て服用完了 - isTakenAll は true を返す", () {
          // 21錠シートで合計7日間（3日+4日）の休薬期間がある場合
          // 最終服用日は開始日+20日+休薬7日=2020-09-28
          const sheetType = PillSheetType.pillsheet_21_0;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id_1",
                beginDate: DateTime.parse("2020-09-05"),
                endDate: DateTime.parse("2020-09-08"),
                createdDate: DateTime.parse("2020-09-05"),
              ),
              RestDuration(
                id: "rest_duration_id_2",
                beginDate: DateTime.parse("2020-09-15"),
                endDate: DateTime.parse("2020-09-19"),
                createdDate: DateTime.parse("2020-09-15"),
              ),
            ],
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

      group("継続中のRestDuration（endDateがnull）", () {
        test("休薬期間継続中の場合 - 休薬期間開始前のピル番号で判定される", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-20"));

          const sheetType = PillSheetType.pillsheet_28_0;
          // 9日目まで服用して、10日目から休薬期間開始（継続中）
          // lastTakenDate は休薬期間開始前の日付
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-09"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                id: "rest_duration_id",
                beginDate: DateTime.parse("2020-09-10"),
                endDate: null,
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
          // 9番目のピルまでしか服用していないので false
          expect(model.isTakenAll, false);
        });
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

      test("pillsheet_28_7の場合、totalCount=28なので開始日から28日目がestimatedEndTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_28_7;
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

      test("pillsheet_28_0の場合、totalCount=28なので開始日から28日目がestimatedEndTakenDate", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_28_0;
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

    test("境界値テスト：最後のRestDurationのbeginDateがnow()と同日の場合はRestDurationを返す（!isAfterは同日を含む）", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final restDuration = RestDuration(
        id: "rest_duration_id",
        beginDate: DateTime.parse("2022-05-10"),
        createdDate: DateTime.parse("2022-05-10"),
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
      // !isAfter は同日を含むため、beginDateが今日と同日の場合はRestDurationを返す
      expect(pillSheet.activeRestDuration, restDuration);
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

    group("境界値テスト：服用お休み開始日が今日の場合", () {
      test("beginDateの時刻がnow()より後でもRestDurationを返す。beginDateは日付レベルで比較される", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 現在時刻: 2022-05-10 08:00:00
        when(mockTodayRepository.now()).thenReturn(DateTime(2022, 5, 10, 8, 0, 0));

        const sheetType = PillSheetType.pillsheet_21;
        // lastTakenDate: 2022-05-09 22:45:27 -> beginDate: 2022-05-10 22:45:27 (addDays(1)により時刻が保持される)
        // このケースでは、beginDateの時刻(22:45)がnow()の時刻(8:00)より後だが、
        // 日付レベルで比較されるため、activeRestDurationはnullではなくなる
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime(2022, 5, 10, 22, 45, 27),
          createdDate: DateTime(2022, 5, 10, 8, 0, 0),
        );
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: DateTime(2022, 5, 9, 22, 45, 27),
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

      test("beginDateの時刻がnow()より前の場合もRestDurationを返す", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        // 現在時刻: 2022-05-10 23:00:00
        when(mockTodayRepository.now()).thenReturn(DateTime(2022, 5, 10, 23, 0, 0));

        const sheetType = PillSheetType.pillsheet_21;
        final restDuration = RestDuration(
          id: "rest_duration_id",
          beginDate: DateTime(2022, 5, 10, 8, 0, 0),
          createdDate: DateTime(2022, 5, 10, 8, 0, 0),
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
    test("休薬期間（RestDuration）がない場合、開始日から連続した日付が返される", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-30"));

      // pillsheet_21 は 21錠+休薬7日 = 合計28日のサイクル
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

      final actual = pillSheet.buildDates();

      // pillsheet_21はtotalCount=28なので28個の日付が返される
      expect(actual.length, 28);
      // 1日目から28日目まで連続した日付
      expect(actual[0], DateTime.parse("2022-05-01"));
      expect(actual[1], DateTime.parse("2022-05-02"));
      expect(actual[10], DateTime.parse("2022-05-11"));
      expect(actual[20], DateTime.parse("2022-05-21"));
      expect(actual[27], DateTime.parse("2022-05-28"));
    });
    test("休薬期間が終了している場合、その期間分だけ日付がシフトする", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-25"));

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
            endDate: DateTime.parse("2022-05-10"), // 2日間の休薬期間
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

      final actual = pillSheet.buildDates();

      // 1日目〜7日目は通常通り
      expect(actual[0], DateTime.parse("2022-05-01"));
      expect(actual[6], DateTime.parse("2022-05-07"));
      // 8日目は休薬期間（2日間）の影響で05-10になる
      expect(actual[7], DateTime.parse("2022-05-10"));
      // 9日目以降も2日ずれる
      expect(actual[8], DateTime.parse("2022-05-11"));
      expect(actual[20], DateTime.parse("2022-05-23"));
    });
    test("複数の休薬期間がある場合、すべての期間分だけ日付がシフトする", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-06-10"));

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
            endDate: DateTime.parse("2022-05-07"), // 2日間
            createdDate: now(),
          ),
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-15"),
            endDate: DateTime.parse("2022-05-18"), // 3日間
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

      final actual = pillSheet.buildDates();

      // 1日目〜4日目は通常通り
      expect(actual[0], DateTime.parse("2022-05-01"));
      expect(actual[3], DateTime.parse("2022-05-04"));
      // 5日目は1回目の休薬期間（2日間）の影響で05-07になる
      expect(actual[4], DateTime.parse("2022-05-07"));
      // 6日目〜12日目は2日ずれる
      expect(actual[5], DateTime.parse("2022-05-08"));
      expect(actual[11], DateTime.parse("2022-05-14"));
      // 13日目は2回目の休薬期間（3日間）の影響でさらに3日ずれる（合計5日ずれ）
      expect(actual[12], DateTime.parse("2022-05-18"));
      // 21日目は合計5日ずれて05-26になる
      expect(actual[20], DateTime.parse("2022-05-26"));
    });
    test("休薬期間がピルシートの開始日と同じ日に始まる場合", () {
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
            beginDate: DateTime.parse("2022-05-01"), // 開始日と同じ
            endDate: DateTime.parse("2022-05-03"), // 2日間
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

      final actual = pillSheet.buildDates();

      // 1日目から休薬期間の影響で2日ずれる
      expect(actual[0], DateTime.parse("2022-05-03"));
      expect(actual[1], DateTime.parse("2022-05-04"));
      expect(actual[2], DateTime.parse("2022-05-05"));
    });
    test("28日型ピルシートの場合、28個の日付が返される", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-06-01"));

      const sheetType = PillSheetType.pillsheet_28_7;
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

      final actual = pillSheet.buildDates();

      // 28日型なので28個の日付が返される
      expect(actual.length, 28);
      expect(actual[0], DateTime.parse("2022-05-01"));
      expect(actual[20], DateTime.parse("2022-05-21"));
      expect(actual[27], DateTime.parse("2022-05-28"));
    });
    test("28日型ピルシートで休薬期間がある場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-06-10"));

      const sheetType = PillSheetType.pillsheet_28_7;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            id: firestoreIDGenerator(),
            beginDate: DateTime.parse("2022-05-15"),
            endDate: DateTime.parse("2022-05-18"), // 3日間
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

      final actual = pillSheet.buildDates();

      // 28日型なので28個の日付が返される
      expect(actual.length, 28);
      // 1日目〜14日目は通常通り
      expect(actual[0], DateTime.parse("2022-05-01"));
      expect(actual[13], DateTime.parse("2022-05-14"));
      // 15日目は休薬期間（3日間）の影響で05-18になる
      expect(actual[14], DateTime.parse("2022-05-18"));
      // 28日目は3日ずれて05-31になる
      expect(actual[27], DateTime.parse("2022-05-31"));
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
}
