import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../../helper/mock.mocks.dart';

PillSheetGroup buildPillSheetGroup() {
  return PillSheetGroup(
    id: 'group_id',
    pillSheetIDs: ['pill_sheet_id'],
    pillSheets: [
      PillSheet.v1(
        id: 'pill_sheet_id',
        groupIndex: 0,
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginDate: DateTime.parse('2020-09-01'),
        lastTakenDate: DateTime.parse('2020-09-18'),
        createdAt: DateTime.parse('2020-09-01'),
      ),
    ],
    createdAt: DateTime.parse('2020-09-01'),
    pillSheetAppearanceMode: PillSheetAppearanceMode.number,
  );
}

Widget buildDialog({required DateTime? initialEndDate, required void Function(DateTime? endDate) onDone}) {
  final pillSheetGroup = buildPillSheetGroup();
  return ProviderScope(
    child: MaterialApp(
      home: RecordPageRestDurationDialog(
        title: RecordPageRestDurationDialogTitle(
          appearanceMode: PillSheetAppearanceMode.number,
          pillSheetGroup: pillSheetGroup,
        ),
        appearanceMode: PillSheetAppearanceMode.number,
        pillSheetGroup: pillSheetGroup,
        initialEndDate: initialEndDate,
        onDone: onDone,
      ),
    ),
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    final mockTodayRepository = MockTodayService();
    todayRepository = mockTodayRepository;
    when(mockTodayRepository.now()).thenReturn(DateTime.parse('2020-09-19'));
  });

  group('RecordPageRestDurationDialog', () {
    group('服用再開予定日の解除ボタン', () {
      testWidgets('服用再開予定日が未選択の場合は表示されない', (WidgetTester tester) async {
        // このグループは表示分岐の確認が目的なので、スクロールせずにダイアログの全体が見える画面サイズにする。小さい画面は「画面が小さい場合」で確認する
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(buildDialog(initialEndDate: null, onDone: (_) {}));
        await tester.pump();

        expect(find.byType(IconButton), findsNothing);
        expect(find.byIcon(Icons.close), findsNothing);
      });

      testWidgets('服用再開予定日が選択済みの場合は表示される', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(buildDialog(initialEndDate: DateTime.parse('2020-09-26'), onDone: (_) {}));
        await tester.pump();

        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.close), findsOneWidget);
      });

      testWidgets('服用再開予定日が選択済みの状態で解除ボタンを押すと、解除ボタンが消える', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(buildDialog(initialEndDate: DateTime.parse('2020-09-26'), onDone: (_) {}));
        await tester.pump();
        await tester.tap(find.byType(IconButton));
        await tester.pump();

        expect(find.byType(IconButton), findsNothing);
      });
    });

    group('開始ボタンに渡す服用再開予定日', () {
      testWidgets('未選択の場合はnullを渡す', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final onDoneEndDates = <DateTime?>[];
        await tester.pumpWidget(buildDialog(initialEndDate: null, onDone: onDoneEndDates.add));
        await tester.pump();
        await tester.tap(find.byType(AppOutlinedButton));
        await tester.pump();

        expect(onDoneEndDates, [null]);
      });

      testWidgets('選択済みの場合はその日付を渡す', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final onDoneEndDates = <DateTime?>[];
        await tester.pumpWidget(buildDialog(initialEndDate: DateTime.parse('2020-09-26'), onDone: onDoneEndDates.add));
        await tester.pump();
        await tester.tap(find.byType(AppOutlinedButton));
        await tester.pump();

        expect(onDoneEndDates, [DateTime.parse('2020-09-26')]);
      });

      testWidgets('選択済みから解除した場合はnullを渡す', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final onDoneEndDates = <DateTime?>[];
        await tester.pumpWidget(buildDialog(initialEndDate: DateTime.parse('2020-09-26'), onDone: onDoneEndDates.add));
        await tester.pump();
        await tester.tap(find.byType(IconButton));
        await tester.pump();
        await tester.tap(find.byType(AppOutlinedButton));
        await tester.pump();

        expect(onDoneEndDates, [null]);
      });
    });

    group('画面が小さい場合', () {
      testWidgets('内容がはみ出さず、服用再開予定日の行までスクロールして開始ボタンを押せる', (WidgetTester tester) async {
        // 高さの小さい端末や文字サイズを拡大した環境を想定した画面サイズ
        tester.view.physicalSize = const Size(320, 480);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        final onDoneEndDates = <DateTime?>[];
        await tester.pumpWidget(buildDialog(initialEndDate: DateTime.parse('2020-09-26'), onDone: onDoneEndDates.add));
        await tester.pump();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
        // はみ出し(RenderFlex overflowed)が起きるとここに例外が残る
        expect(tester.takeException(), isNull);

        await tester.scrollUntilVisible(find.byType(IconButton), 100, scrollable: find.byType(Scrollable));
        expect(find.byType(IconButton).hitTestable(), findsOneWidget);

        await tester.tap(find.byType(AppOutlinedButton));
        await tester.pump();
        expect(onDoneEndDates, [DateTime.parse('2020-09-26')]);
      });
    });
  });
}
