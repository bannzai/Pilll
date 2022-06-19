import 'package:pilll/error_log.dart';
import 'package:pilll/native/channel.dart';

Future<void> removeAppBadge() async {
  try {
    await methodChannel.invokeMethod("removeAppBadge");
  } catch (exception, stack) {
    errorLogger.recordError(exception, stack);
  }
}
