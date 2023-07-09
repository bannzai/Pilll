import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  group("#generateAndFillTo", () {
    test("it is not taken yet", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      final actual = Pill.generateAndFillTo(pillSheetType: PillSheetType.pillsheet_21, fromDate: now(), lastTakenDate: null, pillTakenCount: 1);
      final expected = [
        for (var i = 0; i < PillSheetType.pillsheet_21.totalCount; i++)
          Pill(index: i, createdDateTime: now(), updatedDateTime: now(), pillTakens: []),
      ];
      expect(actual, expected);
    });
  });
}
