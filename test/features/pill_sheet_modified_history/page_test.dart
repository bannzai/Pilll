import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/pill_sheet_modified_history/page.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../helper/mock.mocks.dart';

PillSheetGroup _pillSheetGroup({required DateTime lastTakenDate}) => PillSheetGroup(
      id: 'group_id',
      pillSheetIDs: ['pill_sheet_id_1'],
      pillSheets: [
        PillSheet.v1(
          id: 'pill_sheet_id_1',
          typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
          beginDate: DateTime(2020, 9, 1),
          lastTakenDate: lastTakenDate,
          createdAt: DateTime(2020, 9, 1),
        ),
      ],
      createdAt: DateTime(2020, 9, 1),
    );

// 同じ履歴レコードの estimatedEventCausingDate だけを変えた状態を作る。時刻編集(updateTakenValue)後の履歴に相当する
PillSheetModifiedHistory _takenHistory({required DateTime estimatedEventCausingDate}) => PillSheetModifiedHistory(
      id: 'taken_pill_history_id',
      actionType: PillSheetModifiedActionType.takenPill.name,
      estimatedEventCausingDate: estimatedEventCausingDate,
      createdAt: DateTime(2020, 9, 10, 10),
      value: const PillSheetModifiedHistoryValue(takenPill: TakenPillValue()),
      beforePillSheetGroup: _pillSheetGroup(lastTakenDate: DateTime(2020, 9, 9)),
      afterPillSheetGroup: _pillSheetGroup(lastTakenDate: DateTime(2020, 9, 10)),
    );

Widget _buildPage(Stream<List<PillSheetModifiedHistory>> histories) {
  return ProviderScope(
    overrides: [
      databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
      userProvider.overrideWith((ref) => Stream.value(const User(isPremium: true))),
      pillSheetModifiedHistoriesWithLimitProvider(limit: 20).overrideWith((ref) => histories),
    ],
    child: const MaterialApp(home: PillSheetModifiedHistoriesPage()),
  );
}

void main() {
  group('#PillSheetModifiedHistoriesPage', () {
    testWidgets('件数が変わらない内容だけの更新でも一覧が最新の内容で表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      final controller = StreamController<List<PillSheetModifiedHistory>>();
      addTearDown(controller.close);

      await tester.pumpWidget(_buildPage(controller.stream));

      controller.add([_takenHistory(estimatedEventCausingDate: DateTime(2020, 9, 10, 10, 0))]);
      await tester.pump();

      expect(find.text('10:00'), findsOneWidget);

      // 時刻編集の結果。件数は1件のままで estimatedEventCausingDate だけが変わる
      controller.add([_takenHistory(estimatedEventCausingDate: DateTime(2020, 9, 8, 22, 30))]);
      await tester.pump();

      expect(find.text('22:30'), findsOneWidget);
      expect(find.text('10:00'), findsNothing);
      // 日付も編集後の 9/8 になる
      expect(find.text('8'), findsOneWidget);
      expect(find.text('10'), findsNothing);
    });

    testWidgets('読み込み中で値が取れない間は直前に表示していた一覧を維持する', (tester) async {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-29'));

      final controller = StreamController<List<PillSheetModifiedHistory>>();
      addTearDown(controller.close);

      await tester.pumpWidget(_buildPage(controller.stream));

      controller.add([_takenHistory(estimatedEventCausingDate: DateTime(2020, 9, 10, 10, 0))]);
      await tester.pump();

      expect(find.text('10:00'), findsOneWidget);

      // limit 変更直後の読み込み中に相当する空の状態でも、一覧が空にならない
      controller.add([]);
      await tester.pump();

      expect(find.text('10:00'), findsOneWidget);
    });
  });
}
