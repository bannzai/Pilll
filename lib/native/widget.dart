import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/channel.dart';

Future<void> updateValuesForWidget({
  required PillSheet pillSheet,
  required PillSheetAppearanceMode appearanceMode,
  required bool userIsPremiumOrTrial,
}) async {
  final map = {
    "todayPillNumber": pillSheet.todayPillNumber,
    "lastTakenPillNumber": pillSheet.lastTakenPillNumber,
    "pilllNumberDisplayMode": appearanceMode.name,
    "userIsPremiumOrTrial": userIsPremiumOrTrial,
  };
  await methodChannel.invokeMethod("updateValueForWidget", map);
}
