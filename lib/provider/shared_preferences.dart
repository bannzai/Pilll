import 'dart:async';
import 'package:pilll/provider/shared_preference.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final boolSharedPreferencesProvider = AsyncNotifierProvider.family<BoolSharedPreferences, bool?, String>(() => BoolSharedPreferences());

class BoolSharedPreferences extends FamilyAsyncNotifier<bool?, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  Future<void> set(bool value) async {
    await sharedPreferences.setBool(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<bool?> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceFutureProvider.future);
    return sharedPreferences.getBool(key);
  }
}

final intSharedPreferencesProvider = AsyncNotifierProvider.family<IntSharedPreferences, int?, String>(() => IntSharedPreferences());

class IntSharedPreferences extends FamilyAsyncNotifier<int?, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  Future<void> set(int value) async {
    await sharedPreferences.setInt(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  @override
  FutureOr<int?> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceFutureProvider.future);
    return sharedPreferences.getInt(key);
  }
}

final stringSharedPreferencesProvider = AsyncNotifierProvider.family<StringSharedPreferences, String?, String>(() => StringSharedPreferences());

class StringSharedPreferences extends FamilyAsyncNotifier<String?, String> {
  late String key;
  late SharedPreferences sharedPreferences;

  Future<void> set(String value) async {
    await sharedPreferences.setString(key, value);
    // NOTE: Allow recreate AsyncNotifier everytime. Not call update((_) => value), Keep SSoT with fetching data via shared_preferences
    ref.invalidateSelf();
  }

  bool containsKey() => sharedPreferences.containsKey(key);

  @override
  FutureOr<String?> build(String arg) async {
    key = arg;
    sharedPreferences = await ref.watch(sharedPreferenceFutureProvider.future);
    return sharedPreferences.getString(key);
  }
}
