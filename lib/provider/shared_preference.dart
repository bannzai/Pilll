import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError("sharedPreferencesProvider is not implemented"));

final shouldShowMigrationInformationProvider = FutureProvider((ref) async {
  final sharedPreferences = await ref.watch(sharedPreferenceFutureProvider.future);
  final migrateFrom132IsShown = ref.watch(boolSharedPreferencesProvider(BoolKey.migrateFrom132IsShown));
  if (migrateFrom132IsShown.valueOrNull ?? false) {
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
