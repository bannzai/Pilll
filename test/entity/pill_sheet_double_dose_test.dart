import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

void main() {
  final mockNow = DateTime.parse('2024-01-15T10:00:00');

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(mockNow);
  });

  group('#PillSheet 2錠飲み関連プロパティ', () {
    group('#todayPillsAreAlreadyTaken', () {
      group('pillTakenCount = 1', () {
        test('lastTakenDateがnullの場合、false', () {
          final pillSheet = PillSheet.create(
            PillSheetType.pillsheet_28_7,
            beginDate: mockNow,
            lastTakenDate: null,
            pillTakenCount: 1,
          );

          expect(pillSheet.todayPillsAreAlreadyTaken, false);
        });

        test('lastTakenDateが今日の場合、true', () {
          final pillSheet = PillSheet.create(
            PillSheetType.pillsheet_28_7,
            beginDate: mockNow,
            lastTakenDate: mockNow,
            pillTakenCount: 1,
          );

          expect(pillSheet.todayPillsAreAlreadyTaken, true);
        });
      });

      group('pillTakenCount = 2', () {
        test('pillsが空の場合、false', () {
          final pillSheet = PillSheet.create(
            PillSheetType.pillsheet_28_7,
            beginDate: mockNow,
            lastTakenDate: null,
            pillTakenCount: 2,
          );

          expect(pillSheet.todayPillsAreAlreadyTaken, false);
        });

        test('今日のピルのpillTakens.lengthが0の場合、false', () {
          final pills = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_28_7,
            fromDate: mockNow,
            lastTakenDate: null,
            pillTakenCount: 2,
          );

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: null,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.todayPillsAreAlreadyTaken, false);
        });

        test('今日のピルのpillTakens.lengthが1の場合、false（2錠必要なので）', () {
          // 手動で1回分だけ服用済みの状態を作成
          final pills = List.generate(28, (index) {
            if (index == 0) {
              // 今日のピルは1回だけ服用済み
              return Pill(
                index: index,
                createdDateTime: mockNow,
                updatedDateTime: mockNow,
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: mockNow,
                    createdDateTime: mockNow,
                    updatedDateTime: mockNow,
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              createdDateTime: mockNow,
              updatedDateTime: mockNow,
              pillTakens: [],
            );
          });

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: null,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.todayPillsAreAlreadyTaken, false);
        });

        test('今日のピルのpillTakens.lengthが2の場合、true', () {
          final pills = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_28_7,
            fromDate: mockNow,
            lastTakenDate: mockNow,
            pillTakenCount: 2,
          );

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: mockNow,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.todayPillsAreAlreadyTaken, true);
        });
      });
    });

    group('#anyTodayPillsAreAlreadyTaken', () {
      group('pillTakenCount = 2', () {
        test('今日のピルのpillTakens.lengthが0の場合、false', () {
          final pills = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_28_7,
            fromDate: mockNow,
            lastTakenDate: null,
            pillTakenCount: 2,
          );

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: null,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.anyTodayPillsAreAlreadyTaken, false);
        });

        test('今日のピルのpillTakens.lengthが1の場合、true', () {
          final pills = List.generate(28, (index) {
            if (index == 0) {
              return Pill(
                index: index,
                createdDateTime: mockNow,
                updatedDateTime: mockNow,
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: mockNow,
                    createdDateTime: mockNow,
                    updatedDateTime: mockNow,
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              createdDateTime: mockNow,
              updatedDateTime: mockNow,
              pillTakens: [],
            );
          });

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: null,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.anyTodayPillsAreAlreadyTaken, true);
        });
      });
    });

    group('#lastCompletedPillNumber', () {
      group('pillTakenCount = 2', () {
        test('すべてのpillTakensが空の場合、0', () {
          final pills = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_28_7,
            fromDate: mockNow,
            lastTakenDate: null,
            pillTakenCount: 2,
          );

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: null,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.lastCompletedPillNumber, 0);
        });

        test('最初のピルが2回服用済みの場合、1', () {
          final pills = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_28_7,
            fromDate: mockNow,
            lastTakenDate: mockNow,
            pillTakenCount: 2,
          );

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: mockNow,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.lastCompletedPillNumber, 1);
        });

        test('最初のピルが1回のみ服用済み（完了していない）の場合、0', () {
          final pills = List.generate(28, (index) {
            if (index == 0) {
              return Pill(
                index: index,
                createdDateTime: mockNow,
                updatedDateTime: mockNow,
                pillTakens: [
                  PillTaken(
                    recordedTakenDateTime: mockNow,
                    createdDateTime: mockNow,
                    updatedDateTime: mockNow,
                  ),
                ],
              );
            }
            return Pill(
              index: index,
              createdDateTime: mockNow,
              updatedDateTime: mockNow,
              pillTakens: [],
            );
          });

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: null,
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.lastCompletedPillNumber, 0);
        });
      });
    });

    group('#isEnded', () {
      group('pillTakenCount = 2', () {
        test('すべてのピルが2回服用済みの場合、true', () {
          final pills = Pill.generateAndFillTo(
            pillSheetType: PillSheetType.pillsheet_28_7,
            fromDate: mockNow,
            lastTakenDate: mockNow.add(const Duration(days: 27)),
            pillTakenCount: 2,
          );

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: mockNow.add(const Duration(days: 27)),
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.isEnded, true);
        });

        test('最後のピルが1回のみ服用済みの場合、false', () {
          // 最後の1つ手前まで2回服用済み、最後は1回のみ
          final pills = List.generate(28, (index) {
            if (index < 27) {
              return Pill(
                index: index,
                createdDateTime: mockNow,
                updatedDateTime: mockNow,
                pillTakens: [
                  PillTaken(recordedTakenDateTime: mockNow, createdDateTime: mockNow, updatedDateTime: mockNow),
                  PillTaken(recordedTakenDateTime: mockNow, createdDateTime: mockNow, updatedDateTime: mockNow),
                ],
              );
            }
            return Pill(
              index: index,
              createdDateTime: mockNow,
              updatedDateTime: mockNow,
              pillTakens: [
                PillTaken(recordedTakenDateTime: mockNow, createdDateTime: mockNow, updatedDateTime: mockNow),
              ],
            );
          });

          final pillSheet = PillSheet(
            id: 'test_id',
            groupIndex: 0,
            typeInfo: PillSheetType.pillsheet_28_7.typeInfo,
            beginingDate: mockNow,
            lastTakenDate: mockNow.add(const Duration(days: 27)),
            createdAt: mockNow,
            pillTakenCount: 2,
            pills: pills,
          );

          expect(pillSheet.isEnded, false);
        });
      });
    });
  });
}
