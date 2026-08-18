import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/before_pill_sheet_group_history/component/rest_duration/provider.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');

    // 前回のピルシートグループは過去のものなので、今日は各テストのピルシート期間よりも十分後ろに固定する
    final mockTodayRepository = MockTodayService();
    when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-12-01'));
    todayRepository = mockTodayRepository;
  });

  // 28錠タイプを2枚。1枚目: 2020-09-01〜09-28、2枚目: 2020-09-29〜10-26
  PillSheetV1 v1PillSheet({
    required String id,
    required int groupIndex,
    required DateTime beginDate,
    required DateTime? lastTakenDate,
    List<RestDuration> restDurations = const [],
  }) {
    return PillSheet.v1(
      id: id,
      typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
      beginDate: beginDate,
      lastTakenDate: lastTakenDate,
      createdAt: DateTime.parse('2020-09-01'),
      groupIndex: groupIndex,
      restDurations: restDurations,
    ) as PillSheetV1;
  }

  PillSheetV2 v2PillSheet({
    required String id,
    required int groupIndex,
    required DateTime beginDate,
    required DateTime? lastTakenDate,
    List<RestDuration> restDurations = const [],
  }) {
    return PillSheet.v2(
      id: id,
      typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
      beginDate: beginDate,
      createdAt: DateTime.parse('2020-09-01'),
      groupIndex: groupIndex,
      restDurations: restDurations,
      pills: Pill.testGenerateAndIterateTo(
        pillSheetType: PillSheetType.pillsheet_28_0,
        fromDate: beginDate,
        lastTakenDate: lastTakenDate,
        pillTakenCount: 2,
      ),
    ) as PillSheetV2;
  }

  PillSheetGroup pillSheetGroupOf(List<PillSheet> pillSheets) {
    return PillSheetGroup(
      id: 'group_id',
      pillSheetIDs: pillSheets.map((e) => e.id!).toList(),
      pillSheets: pillSheets,
      createdAt: DateTime.parse('2020-09-01'),
      pillSheetAppearanceMode: PillSheetAppearanceMode.number,
    );
  }

  RestDuration restDuration(
      {required String id,
      required DateTime beginDate,
      required DateTime? endDate}) {
    return RestDuration(
        id: id,
        beginDate: beginDate,
        endDate: endDate,
        createdDate: DateTime.parse('2020-12-01'));
  }

  group('#latestSelectableRestDurationBeginDateForBeforePillSheetGroup', () {
    test('服用記録が無い場合は先頭のピルシートの開始日', () {
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: null),
        v1PillSheet(
            id: 'sheet_2',
            groupIndex: 1,
            beginDate: DateTime.parse('2020-09-29'),
            lastTakenDate: null),
      ]);
      expect(
          pillSheetGroup
              .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
          DateTime.parse('2020-09-01'));
    });

    test('途中まで服用している場合は最終服用日の翌日', () {
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: DateTime.parse('2020-09-21 10:00')),
        v1PillSheet(
            id: 'sheet_2',
            groupIndex: 1,
            beginDate: DateTime.parse('2020-09-29'),
            lastTakenDate: null),
      ]);
      expect(
          pillSheetGroup
              .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
          DateTime.parse('2020-09-22'));
    });

    test('1枚目を飲み切って2枚目が未服用の場合は2枚目の開始日 (1枚目の最終服用日の翌日)', () {
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: DateTime.parse('2020-09-28')),
        v1PillSheet(
            id: 'sheet_2',
            groupIndex: 1,
            beginDate: DateTime.parse('2020-09-29'),
            lastTakenDate: null),
      ]);
      expect(
          pillSheetGroup
              .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
          DateTime.parse('2020-09-29'));
    });

    test('最終シートを飲み切っている場合は最終服用日の翌日ではなく最終シートの終了予定日 (次のピルシートグループの期間には開始できない)',
        () {
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: DateTime.parse('2020-09-28')),
        v1PillSheet(
            id: 'sheet_2',
            groupIndex: 1,
            beginDate: DateTime.parse('2020-09-29'),
            lastTakenDate: DateTime.parse('2020-10-26')),
      ]);
      expect(
          pillSheetGroup
              .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
          DateTime.parse('2020-10-26'));
    });

    test('服用お休み期間で終了予定日が延びている場合は延びた後の終了予定日と比較する', () {
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
          id: 'sheet_1',
          groupIndex: 0,
          beginDate: DateTime.parse('2020-09-01'),
          lastTakenDate: DateTime.parse('2020-10-02'),
          restDurations: [
            restDuration(
                id: 'rest_1',
                beginDate: DateTime.parse('2020-09-10'),
                endDate: DateTime.parse('2020-09-15'))
          ],
        ),
      ]);
      // 09-28 + 5日 = 10-03 が終了予定日。最終服用日 10-02 の翌日 10-03 と同じ
      expect(
          pillSheetGroup
              .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
          DateTime.parse('2020-10-03'));
    });

    group('v2', () {
      test('途中まで服用している場合は最終服用日の翌日', () {
        final pillSheetGroup = pillSheetGroupOf([
          v2PillSheet(
              id: 'sheet_1',
              groupIndex: 0,
              beginDate: DateTime.parse('2020-09-01'),
              lastTakenDate: DateTime.parse('2020-09-21')),
        ]);
        expect(
            pillSheetGroup
                .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
            DateTime.parse('2020-09-22'));
      });

      test('最終シートを飲み切っている場合は最終シートの終了予定日', () {
        final pillSheetGroup = pillSheetGroupOf([
          v2PillSheet(
              id: 'sheet_1',
              groupIndex: 0,
              beginDate: DateTime.parse('2020-09-01'),
              lastTakenDate: DateTime.parse('2020-09-28')),
        ]);
        expect(
            pillSheetGroup
                .latestSelectableRestDurationBeginDateForBeforePillSheetGroup,
            DateTime.parse('2020-09-28'));
      });
    });
  });

  group('#overlapsOtherRestDurationForBeforePillSheetGroup', () {
    final existing = restDuration(
        id: 'rest_1',
        beginDate: DateTime.parse('2020-09-10'),
        endDate: DateTime.parse('2020-09-15'));
    final ongoing = restDuration(
        id: 'rest_2', beginDate: DateTime.parse('2020-10-10'), endDate: null);
    final pillSheetGroup = pillSheetGroupOf([
      v1PillSheet(
          id: 'sheet_1',
          groupIndex: 0,
          beginDate: DateTime.parse('2020-09-01'),
          lastTakenDate: null,
          restDurations: [existing]),
      v1PillSheet(
          id: 'sheet_2',
          groupIndex: 1,
          beginDate: DateTime.parse('2020-10-04'),
          lastTakenDate: null,
          restDurations: [ongoing]),
    ]);

    test('終了日が既存の開始日と同じ日は重ならない (終了日は服用再開日で服用お休み期間に含まれない)', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-05'),
              end: DateTime.parse('2020-09-10')),
          excludingRestDuration: null,
        ),
        isFalse,
      );
    });

    test('終了日が既存の開始日の翌日だと重なる', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-05'),
              end: DateTime.parse('2020-09-11')),
          excludingRestDuration: null,
        ),
        isTrue,
      );
    });

    test('開始日が既存の終了日と同じ日は重ならない', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-15'),
              end: DateTime.parse('2020-09-20')),
          excludingRestDuration: null,
        ),
        isFalse,
      );
    });

    test('開始日が既存の終了日の前日だと重なる', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-14'),
              end: DateTime.parse('2020-09-20')),
          excludingRestDuration: null,
        ),
        isTrue,
      );
    });

    test('既存の期間を内側に含む場合は重なる', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-05'),
              end: DateTime.parse('2020-09-20')),
          excludingRestDuration: null,
        ),
        isTrue,
      );
    });

    test('継続中の服用お休みの開始日より後に終わる期間は重なる', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-10-05'),
              end: DateTime.parse('2020-10-11')),
          excludingRestDuration: null,
        ),
        isTrue,
      );
    });

    test('継続中の服用お休みの開始日に終わる期間は重ならない', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-10-05'),
              end: DateTime.parse('2020-10-10')),
          excludingRestDuration: null,
        ),
        isFalse,
      );
    });

    test('変更対象の服用お休み期間自身とは重なりを判定しない', () {
      expect(
        pillSheetGroup.overlapsOtherRestDurationForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-08'),
              end: DateTime.parse('2020-09-16')),
          excludingRestDuration: existing,
        ),
        isFalse,
      );
    });
  });

  group('#restDurationRangeErrorMessageForBeforePillSheetGroup', () {
    final pillSheetGroup = pillSheetGroupOf([
      v1PillSheet(
        id: 'sheet_1',
        groupIndex: 0,
        beginDate: DateTime.parse('2020-09-01'),
        lastTakenDate: DateTime.parse('2020-09-21'),
        restDurations: [
          restDuration(
              id: 'rest_1',
              beginDate: DateTime.parse('2020-09-05'),
              endDate: DateTime.parse('2020-09-08'))
        ],
      ),
    ]);

    test('開始日が最終服用日の翌日ならエラーなし', () {
      expect(
        pillSheetGroup.restDurationRangeErrorMessageForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-22'),
              end: DateTime.parse('2020-09-30')),
          excludingRestDuration: null,
        ),
        isNull,
      );
    });

    test('開始日が最終服用日の翌々日なら開始日のエラー', () {
      expect(
        pillSheetGroup.restDurationRangeErrorMessageForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-23'),
              end: DateTime.parse('2020-09-30')),
          excludingRestDuration: null,
        ),
        // 曜日の表記は実行環境のロケールに依存するので同じフォーマッタで組み立てる
        L.pauseStartDateMustBeOnOrBefore(
          '${DateTimeFormatter.monthAndDay(DateTime.parse('2020-09-22'))}(${DateTimeFormatter.shortWeekday(DateTime.parse('2020-09-22'))})',
        ),
      );
    });

    test('他の服用お休み期間と重なる場合は重なりのエラー', () {
      expect(
        pillSheetGroup.restDurationRangeErrorMessageForBeforePillSheetGroup(
          dateTimeRange: DateTimeRange(
              start: DateTime.parse('2020-09-07'),
              end: DateTime.parse('2020-09-10')),
          excludingRestDuration: null,
        ),
        L.pausePeriodOverlapsOther,
      );
    });
  });

  group('#AddCompletedRestDuration', () {
    test('終了日が無い服用お休み期間は追加できない', () async {
      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: MockBatchFactory(),
        batchSetPillSheetGroup: MockBatchSetPillSheetGroup(),
        batchSetPillSheetModifiedHistory:
            MockBatchSetPillSheetModifiedHistory(),
      );
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: null),
      ]);
      expect(
        () => addCompletedRestDuration(
          restDuration: restDuration(
              id: 'rest_1',
              beginDate: DateTime.parse('2020-09-10'),
              endDate: null),
          pillSheetGroup: pillSheetGroup,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('開始日がどのピルシートの期間にも含まれない場合は追加できない', () async {
      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: MockBatchFactory(),
        batchSetPillSheetGroup: MockBatchSetPillSheetGroup(),
        batchSetPillSheetModifiedHistory:
            MockBatchSetPillSheetModifiedHistory(),
      );
      final pillSheetGroup = pillSheetGroupOf([
        v1PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: null),
      ]);
      // 最終シートの終了予定日 09-28 の翌日
      expect(
        () => addCompletedRestDuration(
          restDuration: restDuration(
              id: 'rest_1',
              beginDate: DateTime.parse('2020-09-29'),
              endDate: DateTime.parse('2020-10-05')),
          pillSheetGroup: pillSheetGroup,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('1枚目の期間に開始する服用お休み期間を追加すると1枚目に追加され、2枚目の開始日が服用お休みの日数分後ろにずれる', () async {
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      final batchSetPillSheetModifiedHistory =
          MockBatchSetPillSheetModifiedHistory();

      final pillSheet1 = v1PillSheet(
          id: 'sheet_1',
          groupIndex: 0,
          beginDate: DateTime.parse('2020-09-01'),
          lastTakenDate: DateTime.parse('2020-09-21'));
      final pillSheet2 = v1PillSheet(
          id: 'sheet_2',
          groupIndex: 1,
          beginDate: DateTime.parse('2020-09-29'),
          lastTakenDate: null);
      final pillSheetGroup = pillSheetGroupOf([pillSheet1, pillSheet2]);
      // 09-22〜10-01 の10日間
      final added = restDuration(
          id: 'rest_1',
          beginDate: DateTime.parse('2020-09-22'),
          endDate: DateTime.parse('2020-10-02'));

      final updatedPillSheetGroup = pillSheetGroupOf([
        pillSheet1.copyWith(restDurations: [added]),
        // 1枚目の終了予定日 09-28 + 10日 = 10-08。その翌日
        pillSheet2.copyWith(beginDate: DateTime.parse('2020-10-09')),
      ]);
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
      );
      final result = await addCompletedRestDuration(
          restDuration: added, pillSheetGroup: pillSheetGroup);

      // NOTE: verify の引数の評価中は mock の呼び出しが検証対象として扱われ now() が値を返さないので、期待する履歴は verify の前に作る
      final beganHistory = PillSheetModifiedHistoryServiceActionFactory
          .createBeganRestDurationAction(
        restDuration: added,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );
      final endedHistory = PillSheetModifiedHistoryServiceActionFactory
          .createEndedRestDurationAction(
        restDuration: added,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      expect(result, updatedPillSheetGroup);
      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, beganHistory)).called(1);
      verify(batchSetPillSheetModifiedHistory(batch, endedHistory)).called(1);
      verify(batch.commit()).called(1);
    });

    test('2枚目の開始日に開始する服用お休み期間は2枚目に追加され、1枚目は変わらない', () async {
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final pillSheet1 = v1PillSheet(
          id: 'sheet_1',
          groupIndex: 0,
          beginDate: DateTime.parse('2020-09-01'),
          lastTakenDate: DateTime.parse('2020-09-28'));
      final pillSheet2 = v1PillSheet(
          id: 'sheet_2',
          groupIndex: 1,
          beginDate: DateTime.parse('2020-09-29'),
          lastTakenDate: null);
      final pillSheetGroup = pillSheetGroupOf([pillSheet1, pillSheet2]);
      final added = restDuration(
          id: 'rest_1',
          beginDate: DateTime.parse('2020-09-29'),
          endDate: DateTime.parse('2020-10-06'));

      final updatedPillSheetGroup = pillSheetGroupOf([
        pillSheet1,
        pillSheet2.copyWith(restDurations: [added])
      ]);
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory:
            MockBatchSetPillSheetModifiedHistory(),
      );
      final result = await addCompletedRestDuration(
          restDuration: added, pillSheetGroup: pillSheetGroup);

      expect(result, updatedPillSheetGroup);
      verify(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).called(1);
    });

    test('1枚目の終了予定日に開始する服用お休み期間は1枚目に追加される (境界)', () async {
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final pillSheet1 = v1PillSheet(
          id: 'sheet_1',
          groupIndex: 0,
          beginDate: DateTime.parse('2020-09-01'),
          lastTakenDate: DateTime.parse('2020-09-27'));
      final pillSheet2 = v1PillSheet(
          id: 'sheet_2',
          groupIndex: 1,
          beginDate: DateTime.parse('2020-09-29'),
          lastTakenDate: null);
      final pillSheetGroup = pillSheetGroupOf([pillSheet1, pillSheet2]);
      final added = restDuration(
          id: 'rest_1',
          beginDate: DateTime.parse('2020-09-28'),
          endDate: DateTime.parse('2020-09-30'));

      final updatedPillSheetGroup = pillSheetGroupOf([
        pillSheet1.copyWith(restDurations: [added]),
        // 09-28 + 2日 = 09-30 の翌日
        pillSheet2.copyWith(beginDate: DateTime.parse('2020-10-01')),
      ]);
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory:
            MockBatchSetPillSheetModifiedHistory(),
      );
      final result = await addCompletedRestDuration(
          restDuration: added, pillSheetGroup: pillSheetGroup);

      expect(result, updatedPillSheetGroup);
    });

    test('後ろにずれたピルシートに服用記録があり服用お休み期間が無い場合は服用記録がクリアされる', () async {
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final pillSheet1 = v1PillSheet(
          id: 'sheet_1',
          groupIndex: 0,
          beginDate: DateTime.parse('2020-09-01'),
          lastTakenDate: DateTime.parse('2020-09-28'));
      final pillSheet2 = v1PillSheet(
          id: 'sheet_2',
          groupIndex: 1,
          beginDate: DateTime.parse('2020-09-29'),
          lastTakenDate: DateTime.parse('2020-10-05'));
      final pillSheetGroup = pillSheetGroupOf([pillSheet1, pillSheet2]);
      final added = restDuration(
          id: 'rest_1',
          beginDate: DateTime.parse('2020-09-10'),
          endDate: DateTime.parse('2020-09-13'));

      final updatedPillSheetGroup = pillSheetGroupOf([
        pillSheet1.copyWith(restDurations: [added]),
        pillSheet2.copyWith(
            beginDate: DateTime.parse('2020-10-02'), lastTakenDate: null),
      ]);
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory:
            MockBatchSetPillSheetModifiedHistory(),
      );
      final result = await addCompletedRestDuration(
          restDuration: added, pillSheetGroup: pillSheetGroup);

      expect(result, updatedPillSheetGroup);
    });

    test('過去の期間を追加しても、同じピルシートの継続中の服用お休みが末尾に残る (activeRestDurationが末尾を参照するため)',
        () async {
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

      final ongoing = restDuration(
          id: 'rest_ongoing',
          beginDate: DateTime.parse('2020-09-22'),
          endDate: null);
      final pillSheet1 = v1PillSheet(
        id: 'sheet_1',
        groupIndex: 0,
        beginDate: DateTime.parse('2020-09-01'),
        lastTakenDate: DateTime.parse('2020-09-21'),
        restDurations: [ongoing],
      );
      final pillSheetGroup = pillSheetGroupOf([pillSheet1]);
      final added = restDuration(
          id: 'rest_1',
          beginDate: DateTime.parse('2020-09-05'),
          endDate: DateTime.parse('2020-09-08'));

      final updatedPillSheetGroup = pillSheetGroupOf([
        pillSheet1.copyWith(restDurations: [added, ongoing])
      ]);
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
          .thenReturn(updatedPillSheetGroup);

      final addCompletedRestDuration = AddCompletedRestDuration(
        batchFactory: batchFactory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
        batchSetPillSheetModifiedHistory:
            MockBatchSetPillSheetModifiedHistory(),
      );
      final result = await addCompletedRestDuration(
          restDuration: added, pillSheetGroup: pillSheetGroup);

      expect(result, updatedPillSheetGroup);
      expect(result.pillSheets.first.activeRestDuration, ongoing);
    });

    group('v2', () {
      test('後ろにずれたピルシートに服用記録があり服用お休み期間が無い場合はpillsのpillTakensがクリアされる', () async {
        final batchFactory = MockBatchFactory();
        final batch = MockWriteBatch();
        when(batchFactory.batch()).thenReturn(batch);
        final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();

        final pillSheet1 = v2PillSheet(
            id: 'sheet_1',
            groupIndex: 0,
            beginDate: DateTime.parse('2020-09-01'),
            lastTakenDate: DateTime.parse('2020-09-28'));
        final pillSheet2 = v2PillSheet(
            id: 'sheet_2',
            groupIndex: 1,
            beginDate: DateTime.parse('2020-09-29'),
            lastTakenDate: DateTime.parse('2020-10-05'));
        final pillSheetGroup = pillSheetGroupOf([pillSheet1, pillSheet2]);
        final added = restDuration(
            id: 'rest_1',
            beginDate: DateTime.parse('2020-09-10'),
            endDate: DateTime.parse('2020-09-13'));

        final updatedPillSheetGroup = pillSheetGroupOf([
          pillSheet1.copyWith(restDurations: [added]),
          pillSheet2.copyWith(
            beginDate: DateTime.parse('2020-10-02'),
            pills: pillSheet2.pills
                .map((p) => p.copyWith(pillTakens: []))
                .toList(),
          ),
        ]);
        when(batchSetPillSheetGroup(batch, updatedPillSheetGroup))
            .thenReturn(updatedPillSheetGroup);

        final addCompletedRestDuration = AddCompletedRestDuration(
          batchFactory: batchFactory,
          batchSetPillSheetGroup: batchSetPillSheetGroup,
          batchSetPillSheetModifiedHistory:
              MockBatchSetPillSheetModifiedHistory(),
        );
        final result = await addCompletedRestDuration(
            restDuration: added, pillSheetGroup: pillSheetGroup);

        expect(result, updatedPillSheetGroup);
        expect(result.pillSheets[1].lastTakenDate, isNull);
      });
    });
  });
}
