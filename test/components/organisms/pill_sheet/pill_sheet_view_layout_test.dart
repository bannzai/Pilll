import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_weekday_line.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/supported_device.dart';

class _TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
  });
  group("check count of pill mark line widget", () {
    testWidgets('when selected 3 line pill sheet type',
        (WidgetTester tester) async {
      SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

      final weekdayLines =
          PillSheetViewWeekdayLine(firstWeekday: Weekday.Sunday);
      final pillSheetType = PillSheetType.pillsheet_21_0;
      final widget = PillSheetViewLayout(
        weekdayLines: weekdayLines,
        pillMarkLines: List.generate(
          pillSheetType.numberOfLineInPillSheet,
          (index) => _TestWidget(),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            child: widget,
            height: PillSheetViewLayout.calcHeight(
                pillSheetType.numberOfLineInPillSheet, false),
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 500));

      expect(find.byWidgetPredicate((widget) => widget is _TestWidget),
          findsNWidgets(3));
    });
  });
  testWidgets('when selected 4 line pill sheet type',
      (WidgetTester tester) async {
    SupportedDeviceType.iPhone5SE2nd.binding(tester.binding.window);

    final weekdayLines = PillSheetViewWeekdayLine(firstWeekday: Weekday.Sunday);
    final pillSheetType = PillSheetType.pillsheet_28_0;
    final widget = PillSheetViewLayout(
      weekdayLines: weekdayLines,
      pillMarkLines: List.generate(
        pillSheetType.numberOfLineInPillSheet,
        (index) => _TestWidget(),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Container(
          child: widget,
          height: PillSheetViewLayout.calcHeight(
              pillSheetType.numberOfLineInPillSheet, false),
        ),
      ),
    );
    await tester.pumpAndSettle(Duration(milliseconds: 500));

    expect(find.byWidgetPredicate((widget) => widget is _TestWidget),
        findsNWidgets(4));
  });
}
