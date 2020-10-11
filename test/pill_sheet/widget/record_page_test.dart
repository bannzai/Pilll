import 'package:Pilll/main/record/record_page.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/repository/pill_sheet.dart';
import 'package:Pilll/repository/today.dart';
import 'package:Pilll/style/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helper/supported_device.dart';

class MockPillSheetRepository extends Mock
    implements PillSheetRepositoryInterface {}

class MockTodayRepository extends Mock implements TodayRepositoryInterface {}

class FakeUser extends Fake implements User {
  @override
  String get documentID => "1";
}

void main() {
  setUp(() {
    initializeDateFormatting('ja_JP');
  });
  testWidgets('Record Page taken button pressed', (WidgetTester tester) async {
    SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

    var mockPillSheetRepository = MockPillSheetRepository();
    var originalPillSheetRepository = pillSheetRepository;
    pillSheetRepository = mockPillSheetRepository;

    var fakeUser = FakeUser();
    AppState.shared.user = fakeUser;

    var originalTodayRepository = todayRepository;
    var mockTodayRepository = MockTodayRepository();
    todayRepository = mockTodayRepository;

    var today = DateTime(2020, 09, 01);
    when(todayRepository.today()).thenReturn(today);

    var currentPillSheet = PillSheetModel.create(PillSheetType.pillsheet_28_4);
    expect(currentPillSheet.todayPillNumber, equals(1),
        reason: "created pill sheet model should today pill number is 1");
    expect(currentPillSheet.lastTakenPillNumber, equals(0),
        reason: "it is not yet taken pill");

    when(mockPillSheetRepository.fetchLast(fakeUser.documentID))
        .thenAnswer((_) => Future.value(currentPillSheet));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          lazy: false,
        )
      ],
      child: MaterialApp(
        home: RecordPage(),
      ),
    ));
    await tester.pump(Duration(milliseconds: 100));
    expect(find.text("飲んだ"), findsOneWidget);
    expect(AppState.shared.currentPillSheet.allTaken, isFalse);
    verify(mockPillSheetRepository.fetchLast("1"));

    when(mockPillSheetRepository.take("1", currentPillSheet, today)).thenAnswer(
        (_) => Future.value(currentPillSheet..lastTakenDate = today));

    await tester.tap(find.byType(PrimaryButton));
    verify(mockTodayRepository.today());
    verify(mockPillSheetRepository.take("1", currentPillSheet, today));

    await tester.pump(Duration(milliseconds: 100));
    expect(find.text("飲んだ"), findsNothing);
    expect(AppState.shared.currentPillSheet.allTaken, isTrue);

    addTearDown(() {
      pillSheetRepository = originalPillSheetRepository;
      todayRepository = originalTodayRepository;
      AppState.shared.user = null;
      AppState.shared.currentPillSheet = null;
      tester.binding.window.clearAllTestValues();
    });
  });
}
