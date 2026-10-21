import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/utils/local_notification.dart';

void main() {
  group("#iOSQuickRecordPillCategory", () {
    test("PILL_REMINDER カテゴリに RECORD_PILL アクションが 1 つだけある", () {
      final category = iOSQuickRecordPillCategory();

      expect(category.identifier, iOSQuickRecordPillCategoryIdentifier);
      expect(category.actions.map((action) => action.identifier), [actionIdentifier]);
    });

    test("RECORD_PILL アクションはロック中の端末でロック解除を求める", () {
      expect(
        iOSQuickRecordPillCategory().actions.single.options,
        contains(DarwinNotificationActionOption.authenticationRequired),
      );
    });
  });
}
