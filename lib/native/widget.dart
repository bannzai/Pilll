import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/channel.dart';

Future<void> updateValuesForWidget({
  required PillSheet? activePillSheet,
  required PillSheetAppearanceMode? appearanceMode,
  required bool? userIsPremiumOrTrial,
}) async {
  final map = {
    "todayPillNumber": activePillSheet?.todayPillNumber,
    "lastTakenPillNumber": activePillSheet?.lastTakenPillNumber,
    "pilllNumberDisplayMode": appearanceMode.name,
    "userIsPremiumOrTrial": userIsPremiumOrTrial,
  };
  if (appearanceMode != null) {
    map["pilllNumberDisplayMode"] = appearanceMode.name;
  }
  await methodChannel.invokeMethod("updateValueForWidget", map);
}
