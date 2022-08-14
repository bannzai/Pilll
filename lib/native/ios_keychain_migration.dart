import 'package:pilll/native/channel.dart';

Future<bool> iOSKeychainMigrateToSharedKeychain() async {
  final result = await methodChannel.invokeMethod("iOSKeychainMigrateToSharedKeychain");
  return result["iOSKeychainMigrateToSharedKeychain"] == true;
}
