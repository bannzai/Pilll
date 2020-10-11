import 'package:Pilll/main/record/record_page.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/repository/pill_sheet.dart';
import 'package:Pilll/util/today.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helper/supported_device.dart';

class MockPillSheetRepository extends Mock
    implements PillSheetRepositoryInterface {}

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

    var mock = MockPillSheetRepository();
    var original = pillSheetRepository;
    pillSheetRepository = mock;

    var fakeUser = FakeUser();
    AppState.shared.user = fakeUser;

    when(mock.fetchLast(fakeUser.documentID)).thenAnswer((_) =>
        Future.value(PillSheetModel.create(PillSheetType.pillsheet_28_4)));

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
    expect(verify(mock.fetchLast(captureAny)).captured.single, "1");

    addTearDown(() {
      pillSheetRepository = original;
      AppState.shared.user = null;
      AppState.shared.currentPillSheet = null;
      tester.binding.window.clearAllTestValues();
    });
  });
}
