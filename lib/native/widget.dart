import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/native/channel.dart';

Future<void> updateValueForWidget(PillSheet pillSheet) async {
  final map = {
"pillSheetBeginDate": pillSheet.beginingDate,
"pillSheetLastTakenDate": pillSheet.lastTakenDate,
  }
  final result = await methodChannel.invokeMethod("updateValueForWidget", pillSheet);
  return result["isHealthDataAvailable"] == true;
}
