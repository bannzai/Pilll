import 'package:Pilll/domain/record/record_page.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/service/today.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../helper/mock.dart';

void main() {
  setUp(() {
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    WidgetsBinding.instance.renderView.configuration =
        new TestViewConfiguration(size: const Size(375.0, 667.0));
  });
  group('appearance taken button type', () {
    testWidgets('today pill not taken', (WidgetTester tester) async {
      var originalTodayRepository = todayRepository;
      var mockTodayRepository = MockTodayRepository();
      todayRepository = mockTodayRepository;

      var today = DateTime(2020, 09, 01);
      when(todayRepository.today()).thenReturn(today);

      final pillSheet = PillSheetModel.create(PillSheetType.pillsheet_21);
      expect(pillSheet.todayPillNumber, equals(1),
          reason: "created pill sheet model should today pill number is 1");
      expect(pillSheet.lastTakenPillNumber, equals(0),
          reason: "it is not yet taken pill");

      final pillSheetService = MockPillSheetService();
      final pillSheetStore = PillSheetStateStore(pillSheetService);

      when(pillSheetService.fetchLast())
          .thenAnswer((_) => Future.value(pillSheet));
      when(pillSheetService.subscribeForLatestPillSheet())
          .thenAnswer((realInvocation) => Stream.value(pillSheet));

      final settingService = MockSettingService();
      final setting = Setting(
        fromMenstruation: 1,
        durationMenstruation: 2,
        isOnReminder: false,
        pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
        reminderTimes: [],
      );
      when(settingService.fetch())
          .thenAnswer((realInvocation) => Future.value(setting));
      when(settingService.subscribe())
          .thenAnswer((realInvocation) => Stream.value(setting));
      final settingStore = SettingStateStore(settingService);

      addTearDown(() {
        todayRepository = originalTodayRepository;
        tester.binding.window.clearAllTestValues();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pillSheetStoreProvider
                .overrideWithProvider(Provider((ref) => pillSheetStore)),
            settingStoreProvider.overrideWithProvider(
              Provider(
                (ref) => settingStore,
              ),
            )
          ],
          child: MaterialApp(
            home: RecordPage(),
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.text("飲んだ"), findsOneWidget);
    });
  });
  testWidgets('today pill is already taken', (WidgetTester tester) async {
    var originalTodayRepository = todayRepository;
    var mockTodayRepository = MockTodayRepository();
    todayRepository = mockTodayRepository;

    var today = DateTime(2020, 09, 01);
    when(todayRepository.today()).thenReturn(today);

    var pillSheet = PillSheetModel.create(PillSheetType.pillsheet_21);
    pillSheet = pillSheet.copyWith(lastTakenDate: todayRepository.today());
    expect(pillSheet.todayPillNumber, equals(1),
        reason: "created pill sheet model should today pill number is 1");
    expect(pillSheet.lastTakenPillNumber, equals(1),
        reason: "it is already taken pill");

    final pillSheetService = MockPillSheetService();
    final pillSheetStore = PillSheetStateStore(pillSheetService);

    when(pillSheetService.fetchLast())
        .thenAnswer((_) => Future.value(pillSheet));
    when(pillSheetService.subscribeForLatestPillSheet())
        .thenAnswer((realInvocation) => Stream.value(pillSheet));

    final settingService = MockSettingService();
    final setting = Setting(
      fromMenstruation: 1,
      durationMenstruation: 2,
      isOnReminder: false,
      pillSheetTypeRawPath: PillSheetType.pillsheet_21.rawPath,
      reminderTimes: [],
    );
    when(settingService.fetch())
        .thenAnswer((realInvocation) => Future.value(setting));
    when(settingService.subscribe())
        .thenAnswer((realInvocation) => Stream.value(setting));
    final settingStore = SettingStateStore(settingService);

    addTearDown(() {
      todayRepository = originalTodayRepository;
      tester.binding.window.clearAllTestValues();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pillSheetStoreProvider
              .overrideWithProvider(Provider((ref) => pillSheetStore)),
          settingStoreProvider.overrideWithProvider(
            Provider(
              (ref) => settingStore,
            ),
          )
        ],
        child: MaterialApp(
          home: RecordPage(),
        ),
      ),
    );
    await tester.pumpAndSettle(Duration(milliseconds: 500));

    expect(find.text("飲んでない"), findsOneWidget);
  });
}
