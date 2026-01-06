import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/provider/remove_one_pill_taken.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../helper/mock.mocks.dart';

void main() {
  final mockNow = DateTime.parse("2022-07-24T19:02:00");
  late MockBatchFactory mockBatchFactory;
  late MockWriteBatch mockBatch;
  late MockBatchSetPillSheetModifiedHistory mockBatchSetPillSheetModifiedHistory;
  late MockBatchSetPillSheetGroup mockBatchSetPillSheetGroup;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(mockNow);

    mockBatchFactory = MockBatchFactory();
    mockBatch = MockWriteBatch();
    mockBatchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
    mockBatchSetPillSheetGroup = MockBatchSetPillSheetGroup();

    when(mockBatchFactory.batch()).thenReturn(mockBatch);
    when(mockBatch.commit()).thenAnswer((_) async {});
    when(mockBatchSetPillSheetGroup(mockBatch, any)).thenReturn(PillSheetGroup(id: 'dummy', pillSheetIDs: [], pillSheets: [], createdAt: mockNow));
    when(mockBatchSetPillSheetModifiedHistory(mockBatch, any)).thenReturn(null);
  });

  group('#RemoveOnePillTaken', () {
    group('pillTakenCount = 2', () {
      test('2錠服用済みの場合、1錠だけ取り消される', () async {
        // 2回服用記録があるピル
        final baseDate = DateTime(2022, 7, 23);
        final pills = List<Pill>.generate(
          28,
          (index) {
            if (index == 0) {
              // 1番目のピルは2回服用記録がある
              return Pill(
                index: index,
                createdDateTime: baseDate,
                updatedDateTime: baseDate,
                pillTakens: [
                  PillTaken(recordedTakenDateTime: baseDate, createdDateTime: baseDate, updatedDateTime: baseDate),
                  PillTaken(recordedTakenDateTime: baseDate.add(const Duration(hours: 12)), createdDateTime: baseDate, updatedDateTime: baseDate),
                ],
              );
            }
            return Pill(index: index, createdDateTime: baseDate, updatedDateTime: baseDate, pillTakens: []);
          },
        );

        final pillSheet = PillSheet.v2(
          id: 'sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: baseDate,
          lastTakenDate: baseDate,
          createdAt: baseDate,
          pillTakenCount: 2,
          pills: pills,
        );

        final pillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['sheet_id'],
          pillSheets: [pillSheet],
          createdAt: baseDate,
        );

        final removeOnePillTaken = RemoveOnePillTaken(
          batchFactory: mockBatchFactory,
          batchSetPillSheetModifiedHistory: mockBatchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: mockBatchSetPillSheetGroup,
        );

        final result = await removeOnePillTaken(
          pillSheetGroup: pillSheetGroup,
          pageIndex: 0,
          pillNumberInPillSheet: 1,
        );

        expect(result, isNotNull);

        // 更新されたPillSheetを検証
        verify(mockBatchSetPillSheetGroup(
          mockBatch,
          argThat(predicate<PillSheetGroup>((group) {
            final updatedPillSheet = group.pillSheets[0] as PillSheetV2;
            final updatedPill = updatedPillSheet.pills[0];
            // 2錠から1錠に減っているはず
            return updatedPill.pillTakens.length == 1;
          })),
        )).called(1);

        verify(mockBatchSetPillSheetModifiedHistory(
          mockBatch,
          argThat(isA<PillSheetModifiedHistory>()),
        )).called(1);

        verify(mockBatch.commit()).called(1);
      });

      test('1錠服用済みの場合、0錠になる', () async {
        final baseDate = DateTime(2022, 7, 23);
        final pills = List<Pill>.generate(
          28,
          (index) {
            if (index == 0) {
              // 1番目のピルは1回だけ服用記録がある
              return Pill(
                index: index,
                createdDateTime: baseDate,
                updatedDateTime: baseDate,
                pillTakens: [
                  PillTaken(recordedTakenDateTime: baseDate, createdDateTime: baseDate, updatedDateTime: baseDate),
                ],
              );
            }
            return Pill(index: index, createdDateTime: baseDate, updatedDateTime: baseDate, pillTakens: []);
          },
        );

        final pillSheet = PillSheet.v2(
          id: 'sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: baseDate,
          lastTakenDate: baseDate,
          createdAt: baseDate,
          pillTakenCount: 2,
          pills: pills,
        );

        final pillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['sheet_id'],
          pillSheets: [pillSheet],
          createdAt: baseDate,
        );

        final removeOnePillTaken = RemoveOnePillTaken(
          batchFactory: mockBatchFactory,
          batchSetPillSheetModifiedHistory: mockBatchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: mockBatchSetPillSheetGroup,
        );

        final result = await removeOnePillTaken(
          pillSheetGroup: pillSheetGroup,
          pageIndex: 0,
          pillNumberInPillSheet: 1,
        );

        expect(result, isNotNull);

        verify(mockBatchSetPillSheetGroup(
          mockBatch,
          argThat(predicate<PillSheetGroup>((group) {
            final updatedPillSheet = group.pillSheets[0] as PillSheetV2;
            final updatedPill = updatedPillSheet.pills[0];
            // 1錠から0錠に減っているはず
            return updatedPill.pillTakens.isEmpty;
          })),
        )).called(1);
      });

      test('服用記録がない場合、nullを返す', () async {
        final baseDate = DateTime(2022, 7, 23);
        final pills = List<Pill>.generate(
          28,
          (index) => Pill(index: index, createdDateTime: baseDate, updatedDateTime: baseDate, pillTakens: []),
        );

        final pillSheet = PillSheet.v2(
          id: 'sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: baseDate,
          lastTakenDate: null,
          createdAt: baseDate,
          pillTakenCount: 2,
          pills: pills,
        );

        final pillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['sheet_id'],
          pillSheets: [pillSheet],
          createdAt: baseDate,
        );

        final removeOnePillTaken = RemoveOnePillTaken(
          batchFactory: mockBatchFactory,
          batchSetPillSheetModifiedHistory: mockBatchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: mockBatchSetPillSheetGroup,
        );

        final result = await removeOnePillTaken(
          pillSheetGroup: pillSheetGroup,
          pageIndex: 0,
          pillNumberInPillSheet: 1,
        );

        expect(result, isNull);
        verifyNever(mockBatch.commit());
      });

      test('lastTakenDateが再計算される（最後の服用記録が他のピルにある場合）', () async {
        final baseDate = DateTime(2022, 7, 23);
        final day2 = baseDate.add(const Duration(days: 1));
        final pills = List<Pill>.generate(
          28,
          (index) {
            if (index == 0) {
              // 1番目のピルは2錠服用済み
              return Pill(
                index: index,
                createdDateTime: baseDate,
                updatedDateTime: baseDate,
                pillTakens: [
                  PillTaken(recordedTakenDateTime: baseDate, createdDateTime: baseDate, updatedDateTime: baseDate),
                  PillTaken(recordedTakenDateTime: baseDate.add(const Duration(hours: 12)), createdDateTime: baseDate, updatedDateTime: baseDate),
                ],
              );
            } else if (index == 1) {
              // 2番目のピルは1錠服用済み
              return Pill(
                index: index,
                createdDateTime: day2,
                updatedDateTime: day2,
                pillTakens: [
                  PillTaken(recordedTakenDateTime: day2, createdDateTime: day2, updatedDateTime: day2),
                ],
              );
            }
            return Pill(index: index, createdDateTime: baseDate, updatedDateTime: baseDate, pillTakens: []);
          },
        );

        final pillSheet = PillSheet.v2(
          id: 'sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: baseDate,
          lastTakenDate: day2,
          createdAt: baseDate,
          pillTakenCount: 2,
          pills: pills,
        );

        final pillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['sheet_id'],
          pillSheets: [pillSheet],
          createdAt: baseDate,
        );

        final removeOnePillTaken = RemoveOnePillTaken(
          batchFactory: mockBatchFactory,
          batchSetPillSheetModifiedHistory: mockBatchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: mockBatchSetPillSheetGroup,
        );

        // 2番目のピル（index: 1, pillNumber: 2）の服用記録を削除
        final result = await removeOnePillTaken(
          pillSheetGroup: pillSheetGroup,
          pageIndex: 0,
          pillNumberInPillSheet: 2,
        );

        expect(result, isNotNull);

        verify(mockBatchSetPillSheetGroup(
          mockBatch,
          argThat(predicate<PillSheetGroup>((group) {
            final updatedPillSheet = group.pillSheets[0] as PillSheetV2;
            // 2番目のピルの服用記録が消えているはず
            expect(updatedPillSheet.pills[1].pillTakens, isEmpty);
            // lastTakenDateは1番目のピルの日付（baseDate）に戻るはず
            expect(updatedPillSheet.lastTakenDate, baseDate);
            return true;
          })),
        )).called(1);
      });
    });

    group('V1 PillSheetの場合', () {
      test('V1の場合はnullを返す（フォールバックを示唆）', () async {
        final baseDate = DateTime(2022, 7, 23);
        final pillSheet = PillSheet.v1(
          id: 'sheet_id',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginingDate: baseDate,
          lastTakenDate: baseDate,
          createdAt: baseDate,
        );

        final pillSheetGroup = PillSheetGroup(
          id: 'group_id',
          pillSheetIDs: ['sheet_id'],
          pillSheets: [pillSheet],
          createdAt: baseDate,
        );

        final removeOnePillTaken = RemoveOnePillTaken(
          batchFactory: mockBatchFactory,
          batchSetPillSheetModifiedHistory: mockBatchSetPillSheetModifiedHistory,
          batchSetPillSheetGroup: mockBatchSetPillSheetGroup,
        );

        final result = await removeOnePillTaken(
          pillSheetGroup: pillSheetGroup,
          pageIndex: 0,
          pillNumberInPillSheet: 1,
        );

        // V1の場合はnullを返し、呼び出し元でrevertTakePillにフォールバックする
        expect(result, isNull);
        verifyNever(mockBatch.commit());
      });
    });
  });
}
