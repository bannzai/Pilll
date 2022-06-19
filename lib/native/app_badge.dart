import 'package:pilll/native/channel.dart';

Future<void> removeAppBadge() async {
  await methodChannel.invokeMethod("removeAppBadge");
}
