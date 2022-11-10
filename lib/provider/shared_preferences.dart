import 'dart:async';
import 'package:pilll/provider/shared_preference.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final boolSharedPreferencesProvider = AsyncNotifierProvider.family<BoolSharedPreferences, bool, String>(() => BoolSharedPreferences());

class BoolSharedPreferences extends FamilyAsyncNotifier<bool, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  bool get value => state.asData?.value ?? false;
  set value(bool value) {
    sharedPreferences.setBool(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<bool> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceProvider.future);
    return sharedPreferences.getBool(key) ?? false;
  }
}

final intSharedPreferencesProvider = AsyncNotifierProvider.family<BoolSharedPreferences, int, String>(() => IntSharedPreferences());

class IntSharedPreferences extends FamilyAsyncNotifier<int, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  int get value => state.asData?.value ?? 0;
  set value(int value) {
    sharedPreferences.setInt(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<int> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceProvider.future);
    return sharedPreferences.getInt(key) ?? 0;
  }
}
