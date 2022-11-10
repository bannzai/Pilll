import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferenceProvider = FutureProvider((ref) => SharedPreferences.getInstance());

final shouldShowMigrationInformationProvider = FutureProvider((ref) async {
  final sharedPreferences = await ref.watch(sharedPreferenceProvider.future);
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
});
