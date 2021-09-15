import 'package:pilll/components/organisms/pill_mark/pill_marks.dart';
import 'package:pilll/components/organisms/pill_sheet/setting_pill_sheet_view.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/supported_device.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  group("for check appearance pill mark types", () {
    testWidgets('pill sheet types has rest duration',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final pillSheetType = PillSheetType.pillsheet_21;
      final widget = SettingPillSheetView(
        pageIndex: 0,
        pillSheetTypes: [pillSheetType],
        selectedPillNumberPageIndex: 0,
        selectedPillNumberIntoPillSheet: null,
        markSelected: (p, i) => {},
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: widget,
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.byWidgetPredicate((widget) => widget is NormalPillMark),
          findsNWidgets(21));
      expect(find.byWidgetPredicate((widget) => widget is RestPillMark),
          findsNWidgets(7));
    });

    testWidgets('pill sheet types has fake duration',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final pillSheetType = PillSheetType.pillsheet_28_4;
      final widget = SettingPillSheetView(
        pageIndex: 0,
        pillSheetTypes: [pillSheetType],
        selectedPillNumberPageIndex: 0,
        selectedPillNumberIntoPillSheet: null,
        markSelected: (p, i) => {},
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: widget,
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.byWidgetPredicate((widget) => widget is NormalPillMark),
          findsNWidgets(24));
      expect(find.byWidgetPredicate((widget) => widget is FakePillMark),
          findsNWidgets(4));
    });

    testWidgets('pill sheet types only normal type',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final pillSheetType = PillSheetType.pillsheet_28_0;
      final widget = SettingPillSheetView(
        pageIndex: 0,
        pillSheetTypes: [pillSheetType],
        selectedPillNumberPageIndex: 0,
        selectedPillNumberIntoPillSheet: 10,
        markSelected: (p, i) => {},
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: widget,
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.byWidgetPredicate((widget) => widget is NormalPillMark),
          findsNWidgets(27));
      expect(find.byWidgetPredicate((widget) => widget is SelectedPillMark),
          findsNWidgets(1));
    });

    testWidgets('exists selected pill number', (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final pillSheetType = PillSheetType.pillsheet_28_0;
      final widget = SettingPillSheetView(
        pageIndex: 0,
        pillSheetTypes: [pillSheetType],
        selectedPillNumberPageIndex: 0,
        selectedPillNumberIntoPillSheet: null,
        markSelected: (p, i) => {},
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: widget,
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.byWidgetPredicate((widget) => widget is NormalPillMark),
          findsNWidgets(28));
    });
  });
}
