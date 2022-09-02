import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/channel.dart';

Future<void> syncActivePillSheetValue({
  required PillSheetGroup? pillSheetGroup,
}) async {
  final map = {
    "pillSheetBeginDate": pillSheetGroup?.activedPillSheet?.beginingDate.millisecondsSinceEpoch,
    "pillSheetTodayPillNumber": pillSheetGroup?.activedPillSheet?.todayPillNumber,
    "pillSheetEndDisplayPillNumber": pillSheetGroup?.displayNumberSetting?.endPillNumber,
    "pillSheetValueLastUpdateDateTime": DateTime.now().millisecondsSinceEpoch,
  };
  await methodChannel.invokeMethod("syncActivePillSheetValue", map);
}

Future<void> syncSetting({
  required Setting? setting,
}) async {
  final map = {
    "settingPillSheetAppearanceMode": setting?.pillSheetAppearanceMode,
  };
  await methodChannel.invokeMethod("syncSetting", map);
}
