import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/components/history_blur_teaser.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/components/summary_stats_teaser.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog.dart';
import 'package:pilll/features/ended_pill_sheet_dialog/ended_pill_sheet_dialog_variant.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../helper/mock.mocks.dart';

PillSheetGroup _pillSheetGroup({String id = 'group_id', DateTime? lastTakenDate}) => PillSheetGroup(
      id: id,
      pillSheetIDs: ['pill_sheet_id_1'],
      pillSheets: [
        PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: lastTakenDate ?? DateTime(2020, 9, 28),
          createdAt: DateTime(2020, 9, 1),
        ),
      ],
      createdAt: DateTime(2020, 9, 1),
    );

PillSheetModifiedHistory _takenHistory({required String groupID, required DateTime date}) => PillSheetModifiedHistory(
      id: 'taken_$date',
      actionType: PillSheetModifiedActionType.takenPill.name,
      estimatedEventCausingDate: date,
      createdAt: date,
      value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
      beforePillSheetGroup: _pillSheetGroup(id: groupID, lastTakenDate: date.subtract(const Duration(days: 1))),
      afterPillSheetGroup: _pillSheetGroup(id: groupID, lastTakenDate: date),
    );

PillSheetModifiedHistory _revertHistory({
  required String groupID,
  required DateTime date,
  required DateTime beforeLastTakenDate,
  required DateTime? afterLastTakenDate,
}) =>
    PillSheetModifiedHistory(
      id: 'revert_$date',
      actionType: PillSheetModifiedActionType.revertTakenPill.name,
      estimatedEventCausingDate: date,
      createdAt: date,
      value: const PillSheetModifiedHistoryValue(revertTakenPill: RevertTakenPillValue()),
      beforePillSheetGroup: _pillSheetGroup(id: groupID, lastTakenDate: beforeLastTakenDate),
      afterPillSheetGroup: _pillSheetGroup(id: groupID, lastTakenDate: afterLastTakenDate),
    );

void main() {
  group('#EndedPillSheetDialog', () {
    testWidgets('variant=historyBlur のとき HistoryBlurTeaser を表示し SummaryStatsTeaser は表示しない', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pillSheetModifiedHistoriesWithLimitProvider(limit: 30).overrideWith((ref) => Stream.value(<PillSheetModifiedHistory>[])),
          ],
          child: MaterialApp(
            home: EndedPillSheetDialog(
              variant: EndedPillSheetDialogVariant.historyBlur,
              pillSheetGroup: _pillSheetGroup(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(HistoryBlurTeaser), findsOneWidget);
      expect(find.byType(SummaryStatsTeaser), findsNothing);
    });

    testWidgets('variant=summaryStats のとき SummaryStatsTeaser を表示し HistoryBlurTeaser は表示しない', (tester) async {
      final pillSheetGroup = _pillSheetGroup();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pillSheetModifiedHistoriesWithRangeProvider(
              begin: pillSheetGroup.pillSheets.first.beginDate,
              end: pillSheetGroup.pillSheets.last.estimatedEndTakenDate,
            ).overrideWith((ref) => Stream.value(<PillSheetModifiedHistory>[])),
          ],
          child: MaterialApp(
            home: EndedPillSheetDialog(
              variant: EndedPillSheetDialogVariant.summaryStats,
              pillSheetGroup: pillSheetGroup,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SummaryStatsTeaser), findsOneWidget);
      expect(find.byType(HistoryBlurTeaser), findsNothing);
    });
  });

  group('#HistoryBlurTeaser', () {
    Widget buildTeaser({required List<PillSheetModifiedHistory> histories, required PillSheetGroup pillSheetGroup}) {
      return ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
          pillSheetModifiedHistoriesWithLimitProvider(limit: 30).overrideWith((ref) => Stream.value(histories)),
        ],
        child: MaterialApp(
          home: Scaffold(body: HistoryBlurTeaser(pillSheetGroup: pillSheetGroup)),
        ),
      );
    }

    testWidgets('対象グループの服用記録が最新3件まで表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      // 提供順は provider と同じ降順（新しい順）
      final histories = [
        for (int day = 28; day >= 25; day--) _takenHistory(groupID: 'group_id', date: DateTime(2020, 9, day, 10)),
      ];

      await tester.pumpWidget(buildTeaser(histories: histories, pillSheetGroup: _pillSheetGroup()));
      await tester.pump();

      expect(find.byType(PillSheetModifiedHistoryTakenPillAction), findsNWidgets(3));
    });

    testWidgets('別グループの服用記録は表示されない', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      final histories = [
        for (int day = 28; day >= 26; day--) _takenHistory(groupID: 'other_group_id', date: DateTime(2020, 9, day, 10)),
      ];

      await tester.pumpWidget(buildTeaser(histories: histories, pillSheetGroup: _pillSheetGroup()));
      await tester.pump();

      expect(find.byType(PillSheetModifiedHistoryTakenPillAction), findsNothing);
    });

    testWidgets('取り消し(revertTakenPill)されたままの服用記録は表示されない', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      // 9/26〜9/28 に服用後、9/28 の記録を取り消してそのまま（lastTakenDate: 9/28 → 9/27）
      final histories = [
        _revertHistory(
          groupID: 'group_id',
          date: DateTime(2020, 9, 28, 20),
          beforeLastTakenDate: DateTime(2020, 9, 28),
          afterLastTakenDate: DateTime(2020, 9, 27),
        ),
        for (int day = 28; day >= 26; day--) _takenHistory(groupID: 'group_id', date: DateTime(2020, 9, day, 10)),
      ];

      await tester.pumpWidget(buildTeaser(histories: histories, pillSheetGroup: _pillSheetGroup()));
      await tester.pump();

      // 取り消された 9/28 は表示されず、9/27・9/26 の2件のみ表示される
      expect(find.byType(PillSheetModifiedHistoryTakenPillAction), findsNWidgets(2));
    });

    testWidgets('過去日のピルを後から記録した履歴（操作日と記録対象日が異なる）も表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      final histories = [
        // 9/28 の操作で 9/27 分のピルを記録（lastTakenDate: 9/26 → 9/27）
        PillSheetModifiedHistory(
          id: 'taken_past_day',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: DateTime(2020, 9, 28, 10),
          createdAt: DateTime(2020, 9, 28, 10),
          value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
          beforePillSheetGroup: _pillSheetGroup(id: 'group_id', lastTakenDate: DateTime(2020, 9, 26)),
          afterPillSheetGroup: _pillSheetGroup(id: 'group_id', lastTakenDate: DateTime(2020, 9, 27)),
        ),
      ];

      await tester.pumpWidget(buildTeaser(histories: histories, pillSheetGroup: _pillSheetGroup()));
      await tester.pump();

      expect(find.byType(PillSheetModifiedHistoryTakenPillAction), findsOneWidget);
    });

    testWidgets('一部だけ取り消されたまとめ記録の行は表示されない', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      final histories = [
        // 9/28 の記録だけを取り消し（lastTakenDate: 9/28 → 9/27）
        _revertHistory(
          groupID: 'group_id',
          date: DateTime(2020, 9, 28, 20),
          beforeLastTakenDate: DateTime(2020, 9, 28),
          afterLastTakenDate: DateTime(2020, 9, 27),
        ),
        // 9/28 の操作で 9/26〜9/28 の3日分をまとめて記録（lastTakenDate: 9/25 → 9/28）
        PillSheetModifiedHistory(
          id: 'taken_bulk',
          actionType: PillSheetModifiedActionType.takenPill.name,
          estimatedEventCausingDate: DateTime(2020, 9, 28, 10),
          createdAt: DateTime(2020, 9, 28, 10),
          value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
          beforePillSheetGroup: _pillSheetGroup(id: 'group_id', lastTakenDate: DateTime(2020, 9, 25)),
          afterPillSheetGroup: _pillSheetGroup(id: 'group_id', lastTakenDate: DateTime(2020, 9, 28)),
        ),
      ];

      await tester.pumpWidget(buildTeaser(histories: histories, pillSheetGroup: _pillSheetGroup()));
      await tester.pump();

      // まとめ記録の行表示は afterPillSheetGroup（9/28 まで記録済み）ベースのため、
      // 一部が取り消された状態では実態とずれる。記録対象日が全て残っている履歴のみ表示する
      expect(find.byType(PillSheetModifiedHistoryTakenPillAction), findsNothing);
    });

    testWidgets('履歴の読み込み中は服用記録行を表示せずインジケータを表示する', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
            // 値を流さない Stream でローディング状態を維持する
            pillSheetModifiedHistoriesWithLimitProvider(limit: historyBlurTeaserHistoriesLimit)
                .overrideWith((ref) => const Stream<List<PillSheetModifiedHistory>>.empty()),
          ],
          child: MaterialApp(
            home: Scaffold(body: HistoryBlurTeaser(pillSheetGroup: _pillSheetGroup())),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Indicator), findsOneWidget);
      expect(find.byType(PillSheetModifiedHistoryTakenPillAction), findsNothing);
    });
  });

  group('#SummaryStatsTeaser', () {
    Widget buildTeaser({required List<PillSheetModifiedHistory> histories, required PillSheetGroup pillSheetGroup}) {
      return ProviderScope(
        overrides: [
          pillSheetModifiedHistoriesWithRangeProvider(
            begin: pillSheetGroup.pillSheets.first.beginDate,
            end: pillSheetGroup.pillSheets.last.estimatedEndTakenDate,
          ).overrideWith((ref) => Stream.value(histories)),
        ],
        child: MaterialApp(
          home: Scaffold(body: SummaryStatsTeaser(pillSheetGroup: pillSheetGroup)),
        ),
      );
    }

    testWidgets('集計開始日が履歴TTL(180日)の窓内なら集計メッセージが表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-10-01'));

      final pillSheetGroup = _pillSheetGroup();
      await tester.pumpWidget(
        buildTeaser(
          histories: [_takenHistory(groupID: 'group_id', date: DateTime(2020, 9, 1, 10))],
          pillSheetGroup: pillSheetGroup,
        ),
      );
      await tester.pump();

      // タイトルと集計メッセージの2つの Text が表示される
      expect(find.descendant(of: find.byType(SummaryStatsTeaser), matching: find.byType(Text)), findsNWidgets(2));
    });

    testWidgets('集計開始日が履歴TTL(180日)の窓外なら、履歴が部分的に削除されている可能性があるため集計メッセージを表示しない', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      // beginDate(2020-09-01) の履歴は TTL 切れの時期（273日後）
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2021-06-01'));

      final pillSheetGroup = _pillSheetGroup();
      await tester.pumpWidget(
        buildTeaser(
          histories: [_takenHistory(groupID: 'group_id', date: DateTime(2020, 9, 20, 10))],
          pillSheetGroup: pillSheetGroup,
        ),
      );
      await tester.pump();

      // 履歴が残っていても集計メッセージは出さず、タイトルの Text のみ表示される
      expect(find.descendant(of: find.byType(SummaryStatsTeaser), matching: find.byType(Text)), findsOneWidget);
    });

    testWidgets('対象グループの履歴が無い場合は集計メッセージを表示しない', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-10-01'));

      final pillSheetGroup = _pillSheetGroup();
      await tester.pumpWidget(
        buildTeaser(
          histories: [_takenHistory(groupID: 'other_group_id', date: DateTime(2020, 9, 1, 10))],
          pillSheetGroup: pillSheetGroup,
        ),
      );
      await tester.pump();

      // 別グループの履歴しか無い場合はタイトルの Text のみ表示される
      expect(find.descendant(of: find.byType(SummaryStatsTeaser), matching: find.byType(Text)), findsOneWidget);
    });
  });
}
