import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/service/today.dart';
import 'package:Pilll/state/pill_sheet.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/util/datetime/date_compare.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helper/mock.dart';

void main() {
  group("#calcBeginingDateFromNextTodayPillNumber", () {
    var mockTodayRepository = MockTodayRepository();
    todayRepository = mockTodayRepository;
    when(todayRepository.today()).thenReturn(DateTime.parse("2020-11-22"));

    final service = MockPillSheetService();
    final store = PillSheetStateStore(service);
    final pillSheetEntity =
        PillSheetModel.create(PillSheetType.pillsheet_21).copyWith(
      beginingDate: DateTime.parse("2020-11-22"),
      createdAt: DateTime.parse("2020-11-22"),
    );
    final state = PillSheetState(entity: pillSheetEntity);
    // ignore: invalid_use_of_protected_member
    store.state = state;
    expect(state.entity.todayPillNumber, equals(1));

    final expected = DateTime.parse("2020-11-13");
    final actual = store.calcBeginingDateFromNextTodayPillNumber(10);
    expect(isSameDay(expected, actual), isTrue);
  });
}
