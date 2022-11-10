import 'dart:async';
import 'package:pilll/provider/shared_preference.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final boolSharedPreferencesProvider = AsyncNotifierProvider.family<BoolSharedPreferences, bool?, String>(() => BoolSharedPreferences());

class BoolSharedPreferences extends FamilyAsyncNotifier<bool?, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  void set(bool value) {
    sharedPreferences.setBool(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<bool?> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceProvider.future);
    return sharedPreferences.getBool(key);
  }
}

final intSharedPreferencesProvider = AsyncNotifierProvider.family<IntSharedPreferences, int, String>(() => IntSharedPreferences());

class IntSharedPreferences extends FamilyAsyncNotifier<int?, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  void set(int value) {
    sharedPreferences.setInt(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<int?> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceProvider.future);
    return sharedPreferences.getInt(key);
  }
}

final stringSharedPreferencesProvider = AsyncNotifierProvider.family<StringSharedPreferences, String?, String>(() => StringSharedPreferences());

class StringSharedPreferences extends FamilyAsyncNotifier<String?, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  void set(String value) {
    sharedPreferences.setString(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<String?> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceProvider.future);
    return sharedPreferences.getString(key);
  }
}
