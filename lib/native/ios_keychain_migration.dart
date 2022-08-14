import 'package:pilll/native/channel.dart';

Future<bool> isMigratedSharedKeychain() async {
  final result = await methodChannel.invokeMethod("isMigratedSharedKeychain");
  return result["isMigratedSharedKeychain"] == true;
}

Future<bool> iOSKeychainMigrateToSharedKeychain() async {
  final result = await methodChannel.invokeMethod("iOSKeychainMigrateToSharedKeychain");
  return result["iOSKeychainMigrateToSharedKeychain"] == true;
}
