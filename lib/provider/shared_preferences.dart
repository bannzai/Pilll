import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

// overrideする前提なので.autoDisposeはつけない=(keeyAlive: trueにする)。またこれに依存したProviderもkeepAlive: trueにする必要がある
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError("sharedPreferencesProvider is not implemented");
}

final shouldShowMigrationInformationProvider = FutureProvider.autoDispose((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  final migrateFrom132IsShown = ref.watch(boolSharedPreferencesProvider(BoolKey.migrateFrom132IsShown));
  if (migrateFrom132IsShown.value ?? false) {
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
