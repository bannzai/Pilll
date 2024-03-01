import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/features/record/components/button/cancel_button.dart';
import 'package:pilll/features/record/components/button/record_page_button.dart';
import 'package:pilll/features/record/components/button/taken_button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = MockAnalytics();
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration.fromView(
      view: WidgetsBinding.instance.platformDispatcher.views.single,
      size: const Size(375.0, 667.0),
    );
  });
  group('appearance taken button type', () {
    testWidgets('today pill not taken', (WidgetTester tester) async {
      final yesterday = today().subtract(const Duration(days: 1));
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        typeInfo: PillSheetType.pillsheet_21.typeInfo,
        beginingDate: yesterday,
        lastTakenDate: yesterday,
        createdAt: now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
          ],
          child: MaterialApp(
            home: RecordPageButton(
              pillSheetGroup: PillSheetGroup(pillSheets: [pillSheet], createdAt: now(), pillSheetIDs: ["id"]),
              currentPillSheet: pillSheet,
              userIsPremiumOtTrial: false,
              user: FakeUser(),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byWidgetPredicate((widget) => widget is TakenButton), findsOneWidget);
    });
  });
  testWidgets('today pill is already taken', (WidgetTester tester) async {
    final pillSheet = PillSheet(
      id: firestoreIDGenerator(),
      typeInfo: PillSheetType.pillsheet_21.typeInfo,
      beginingDate: today(),
      lastTakenDate: today(),
      createdAt: now(),
    );

    expect(true, pillSheet.todayPillIsAlreadyTaken);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWith((ref) => MockDatabaseConnection()),
        ],
        child: MaterialApp(
          home: RecordPageButton(
            pillSheetGroup: PillSheetGroup(pillSheets: [pillSheet], createdAt: now(), pillSheetIDs: ["id"]),
            currentPillSheet: pillSheet,
            userIsPremiumOtTrial: false,
            user: FakeUser(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byWidgetPredicate((widget) => widget is CancelButton), findsOneWidget);
  });
}
