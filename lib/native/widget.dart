import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/native/channel.dart';

Future<void> updateValuesForWidget({
  required PillSheet? activePillSheet,
  required bool userIsPremiumOrTrial,
}) async {
  final map = {
    "pillSheetBeginDate": activePillSheet?.beginingDate.millisecondsSinceEpoch,
    "pillSheetLastTakenDate": activePillSheet?.lastTakenDate?.millisecondsSinceEpoch,
    "userIsPremiumOrTrial": userIsPremiumOrTrial,
  };
  await methodChannel.invokeMethod("updateValuesForWidget", map);
}
