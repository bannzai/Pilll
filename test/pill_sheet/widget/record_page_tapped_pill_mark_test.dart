import 'package:Pilll/main/components/pill/pill_mark.dart';
import 'package:Pilll/main/record/record_page.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/repository/pill_sheet.dart';
import 'package:Pilll/repository/today.dart';
import 'package:Pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helper/supported_device.dart';

class _MockPillSheetRepository extends Mock
    implements PillSheetServiceInterface {}

class _MockTodayRepository extends Mock implements TodayServiceInterface {}

class _FakeUser extends Fake implements User {
  @override
  String get documentID => "1";
}

void main() {
  setUp(() {
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  Finder Function(bool Function(PillMark)) animatedPillMarkFinder =
      (condition) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is PillMark && condition(widget) && widget.hasRippleAnimation,
    );
  };
  Finder Function(bool Function(PillMark)) pillMarkFinder = (condition) {
    return find
        .byWidgetPredicate((widget) => widget is PillMark && condition(widget));
  };

  testWidgets('For not yet taken pill number 2 and 3. when tapped 2 pill mark ',
      (WidgetTester tester) async {
    SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

    var mockPillSheetRepository = _MockPillSheetRepository();
    var originalPillSheetRepository = pillSheetRepository;
    pillSheetRepository = mockPillSheetRepository;

    var fakeUser = _FakeUser();
    AppState.shared.user = fakeUser;

    var originalTodayRepository = todayRepository;
    var mockTodayRepository = _MockTodayRepository();
    todayRepository = mockTodayRepository;

    var today = DateTime(2020, 09, 01);
    when(todayRepository.today()).thenReturn(today);

    var currentPillSheet = PillSheetModel(
      beginingDate: today.subtract(Duration(days: 2)),
      lastTakenDate: today.subtract(Duration(days: 2)),
      typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
    );

    when(mockPillSheetRepository.fetchLast(fakeUser.documentID))
        .thenAnswer((_) => Future.value(currentPillSheet));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: AppState.shared)
      ],
      child: MaterialApp(
        home: RecordPage(),
      ),
    ));
    await tester.pump(Duration(milliseconds: 100));

    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_2")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_3")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder(
        (widget) =>
            widget.key != Key("PillMarkWidget_2") &&
            widget.key != Key("PillMarkWidget_3"),
      ),
      findsNothing,
    );

    verify(mockPillSheetRepository.fetchLast("1"));

    var targetDay = today.subtract(Duration(days: 1));
    when(mockPillSheetRepository.take("1", currentPillSheet, targetDay))
        .thenAnswer(
            (_) => Future.value(currentPillSheet..lastTakenDate = targetDay));

    await tester.tap(animatedPillMarkFinder(
        (widget) => widget.key == Key("PillMarkWidget_2")));
    verify(mockTodayRepository.today());
    verify(mockPillSheetRepository.take("1", currentPillSheet, targetDay));

    await tester.pumpAndSettle();
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_2")),
      findsNothing,
    );
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_3")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder(
        (widget) =>
            widget.key != Key("PillMarkWidget_2") &&
            widget.key != Key("PillMarkWidget_3"),
      ),
      findsNothing,
    );

    addTearDown(() {
      pillSheetRepository = originalPillSheetRepository;
      todayRepository = originalTodayRepository;
      AppState.shared.user = null;
      AppState.shared.currentPillSheet = null;
      tester.binding.window.clearAllTestValues();
    });
  });
  testWidgets(
      'For not yet taken pill number 2 and 3. when tapped 4 pill mark means in the future pill mark number',
      (WidgetTester tester) async {
    SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

    var mockPillSheetRepository = _MockPillSheetRepository();
    var originalPillSheetRepository = pillSheetRepository;
    pillSheetRepository = mockPillSheetRepository;

    var fakeUser = _FakeUser();
    AppState.shared.user = fakeUser;

    var originalTodayRepository = todayRepository;
    var mockTodayRepository = _MockTodayRepository();
    todayRepository = mockTodayRepository;

    var today = DateTime(2020, 09, 01);
    when(todayRepository.today()).thenReturn(today);

    var currentPillSheet = PillSheetModel(
      beginingDate: today.subtract(Duration(days: 2)),
      lastTakenDate: today.subtract(Duration(days: 2)),
      typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
    );

    when(mockPillSheetRepository.fetchLast(fakeUser.documentID))
        .thenAnswer((_) => Future.value(currentPillSheet));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: AppState.shared)
      ],
      child: MaterialApp(
        home: RecordPage(),
      ),
    ));
    await tester.pump(Duration(milliseconds: 100));
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_2")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_3")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder(
        (widget) =>
            widget.key != Key("PillMarkWidget_2") &&
            widget.key != Key("PillMarkWidget_3"),
      ),
      findsNothing,
    );

    verify(mockPillSheetRepository.fetchLast("1"));

    // For verifyZeroInteractions
    mockPillSheetRepository = _MockPillSheetRepository();
    await tester
        .tap(pillMarkFinder((widget) => widget.key == Key("PillMarkWidget_4")));

    await tester.pumpAndSettle();
    verifyZeroInteractions(mockPillSheetRepository);
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_2")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_3")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder(
        (widget) =>
            widget.key != Key("PillMarkWidget_2") &&
            widget.key != Key("PillMarkWidget_3"),
      ),
      findsNothing,
    );

    addTearDown(() {
      pillSheetRepository = originalPillSheetRepository;
      todayRepository = originalTodayRepository;
      AppState.shared.user = null;
      AppState.shared.currentPillSheet = null;
      tester.binding.window.clearAllTestValues();
    });
  });
  testWidgets(
      'For not yet taken pill number 2 and 3. when tapped 1 pill mark means that already taken pill number',
      (WidgetTester tester) async {
    SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

    var mockPillSheetRepository = _MockPillSheetRepository();
    var originalPillSheetRepository = pillSheetRepository;
    pillSheetRepository = mockPillSheetRepository;

    var fakeUser = _FakeUser();
    AppState.shared.user = fakeUser;

    var originalTodayRepository = todayRepository;
    var mockTodayRepository = _MockTodayRepository();
    todayRepository = mockTodayRepository;

    var today = DateTime(2020, 09, 01);
    when(todayRepository.today()).thenReturn(today);

    var currentPillSheet = PillSheetModel(
      beginingDate: today.subtract(Duration(days: 2)),
      lastTakenDate: today.subtract(Duration(days: 2)),
      typeInfo: PillSheetType.pillsheet_28_4.typeInfo,
    );

    when(mockPillSheetRepository.fetchLast(fakeUser.documentID))
        .thenAnswer((_) => Future.value(currentPillSheet));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>.value(value: AppState.shared)
      ],
      child: MaterialApp(
        home: RecordPage(),
      ),
    ));
    await tester.pump(Duration(milliseconds: 100));
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_2")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_3")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder(
        (widget) =>
            widget.key != Key("PillMarkWidget_2") &&
            widget.key != Key("PillMarkWidget_3"),
      ),
      findsNothing,
    );

    verify(mockPillSheetRepository.fetchLast("1"));

    // For verifyZeroInteractions
    mockPillSheetRepository = _MockPillSheetRepository();
    await tester
        .tap(pillMarkFinder((widget) => widget.key == Key("PillMarkWidget_1")));

    await tester.pumpAndSettle();
    verifyZeroInteractions(mockPillSheetRepository);
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_2")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder((widget) => widget.key == Key("PillMarkWidget_3")),
      findsWidgets,
    );
    expect(
      animatedPillMarkFinder(
        (widget) =>
            widget.key != Key("PillMarkWidget_2") &&
            widget.key != Key("PillMarkWidget_3"),
      ),
      findsNothing,
    );

    addTearDown(() {
      pillSheetRepository = originalPillSheetRepository;
      todayRepository = originalTodayRepository;
      AppState.shared.user = null;
      AppState.shared.currentPillSheet = null;
      tester.binding.window.clearAllTestValues();
    });
  });
}
