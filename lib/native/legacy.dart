import 'dart:io' show Platform;
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvagedOldStartTakenDate(dynamic arguments) async {
  if (arguments == null) {
    return Future.value();
  }
  final dic = arguments as Map<dynamic, dynamic>?;
  if (dic == null) {
    return Future.value();
  }

  Map<String, String> typedDic;
  try {
    typedDic = dic.cast<String, String>();
  } catch (error) {
    return Future.value();
  }

  final salvagedOldStartTakenDateRawValue =
      typedDic["salvagedOldStartTakenDate"];
  if (salvagedOldStartTakenDateRawValue == null) {
    return Future.value();
  }
  if (!salvagedOldStartTakenDateRawValue.contains("/")) {
    return Future.value();
  }
  final salvagedOldLastTakenDateRawValue = typedDic["salvagedOldLastTakenDate"];
  if (salvagedOldLastTakenDateRawValue == null) {
    return Future.value();
  }
  if (!salvagedOldLastTakenDateRawValue.contains("/")) {
    return Future.value();
  }
  final formattedStartTakenDate =
      salvagedOldStartTakenDateRawValue.replaceAll("/", "-");
  final formattedSalvagedOldLastTakenDate =
      salvagedOldLastTakenDateRawValue.replaceAll("/", "-");
  return SharedPreferences.getInstance().then((storage) {
    storage.setString("salvagedOldStartTakenDate", formattedStartTakenDate);
    storage.setString(
        "salvagedOldLastTakenDate", formattedSalvagedOldLastTakenDate);
  });
}

Future<bool> shouldShowMigrateInfo() async {
  if (!Platform.isIOS) {
    return false;
  }

  final sharedPreferences = await SharedPreferences.getInstance();

  if (sharedPreferences.getBool(BoolKey.migrateFrom132IsShown) ?? false) {
    return false;
  }
  if (!sharedPreferences.containsKey(StringKey.salvagedOldStartTakenDate)) {
    return false;
  }
  if (!sharedPreferences.containsKey(StringKey.salvagedOldLastTakenDate)) {
    return false;
  }

  return true;
}
