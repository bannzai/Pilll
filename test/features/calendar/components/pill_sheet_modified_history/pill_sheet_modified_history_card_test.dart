import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../../../helper/fake.dart';
import '../../../../helper/mock.mocks.dart';

void main() {
  final mockToday = DateTime(2026, 9, 10);

  setUp(() {
    analytics = FakeAnalytics();
    final mockTodayRepository = MockTodayService();
    when(mockTodayRepository.now()).thenReturn(mockToday);
    todayRepository = mockTodayRepository;
  });

  PillSheetModifiedHistory createdPillSheetHistory(int index) {
    return PillSheetModifiedHistory(
      id: 'history_$index',
      actionType: PillSheetModifiedActionType.createdPillSheet.name,
      estimatedEventCausingDate: mockToday.subtract(Duration(days: index)),
      createdAt: mockToday.subtract(Duration(days: index)),
      value: const PillSheetModifiedHistoryValue(),
      beforePillSheetGroup: null,
      afterPillSheetGroup: null,
    );
  }

  Widget subject(
      {required User user, required List<PillSheetModifiedHistory> histories}) {
    return ProviderScope(
      child: MaterialApp(
        home: Material(
          child: SingleChildScrollView(
            child: CalendarPillSheetModifiedHistoryCard(
                histories: histories, user: user),
          ),
        ),
      ),
    );
  }

  group('#CalendarPillSheetModifiedHistoryCard', () {
    // iPhone 相当の画面幅。カードの横幅でロックオーバーレイの必要な高さが決まるため実機に寄せる
    setUp(() {
      final view = TestWidgetsFlutterBinding.ensureInitialized()
          .platformDispatcher
          .views
          .first;
      view.physicalSize = const Size(1170, 2532);
      view.devicePixelRatio = 3.0;
      addTearDown(view.reset);
    });

    testWidgets('無料ユーザーで服薬変更履歴が1件だけでも、ロックオーバーレイがオーバーフローせず「くわしくみる」が表示される',
        (tester) async {
      await tester.pumpWidget(subject(
          user: const User(isPremium: false),
          histories: [createdPillSheetHistory(0)]));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(L.viewMoreDetails), findsOneWidget);
    });

    testWidgets('無料ユーザーでロックオーバーレイが履歴リストより高い場合、「くわしくみる」がカードの内側に収まる',
        (tester) async {
      await tester.pumpWidget(subject(
          user: const User(isPremium: false),
          histories: [createdPillSheetHistory(0)]));
      await tester.pumpAndSettle();

      expect(
        tester.getRect(find.byType(AppOutlinedButton)).bottom,
        lessThanOrEqualTo(tester
            .getRect(find.byType(CalendarPillSheetModifiedHistoryCard))
            .bottom),
      );
    });

    testWidgets('無料ユーザーで服薬変更履歴が十分にある場合も、オーバーフローせず「くわしくみる」が表示される',
        (tester) async {
      await tester.pumpWidget(
        subject(
            user: const User(isPremium: false),
            histories: List.generate(10, createdPillSheetHistory)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(L.viewMoreDetails), findsOneWidget);
    });

    testWidgets('プレミアム会員の場合、ロックオーバーレイを表示しない', (tester) async {
      await tester.pumpWidget(subject(
          user: const User(isPremium: true),
          histories: [createdPillSheetHistory(0)]));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(L.viewMoreDetails), findsNothing);
    });
  });
}
