import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("#PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet", () {
    test(
      "Left boundary pattern",
      () {
        expect(
          PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(0, 0),
          1,
        );
      },
    );
    test(
      "Any value. No boundary pattern",
      () {
        expect(
          PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(2, 2),
          17,
        );
      },
    );
    test(
      "Right boundary pattern",
      () {
        expect(
          PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(6, 3),
          28,
        );
      },
    );
  });
}
