import 'package:flutter/foundation.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'typed_shared_preferences.g.dart';

@immutable
class SharedPreferencesState<T> {
  final String key;
  final T? value;

  const SharedPreferencesState(this.key, this.value);
}

@Riverpod(keepAlive: true, dependencies: [sharedPreferences])
class BoolSharedPreferences extends _$BoolSharedPreferences {
  @override
  SharedPreferencesState<bool?> build(String key) => SharedPreferencesState(key, ref.read(sharedPreferencesProvider).getBool(key));

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(state.key, value);
    state = SharedPreferencesState(key, value);
  }
}

@Riverpod(keepAlive: true, dependencies: [sharedPreferences])
class IntSharedPreferences extends _$IntSharedPreferences {
  @override
  SharedPreferencesState<int?> build(String key) => SharedPreferencesState(key, ref.read(sharedPreferencesProvider).getInt(key));

  Future<void> set(int value) async {
    await ref.read(sharedPreferencesProvider).setInt(state.key, value);
    state = SharedPreferencesState(key, value);
  }
}

@Riverpod(keepAlive: true, dependencies: [sharedPreferences])
class StringSharedPreferences extends _$StringSharedPreferences {
  @override
  SharedPreferencesState<String?> build(String key) => SharedPreferencesState(key, ref.read(sharedPreferencesProvider).getString(key));

  Future<void> set(String value) async {
    await ref.read(sharedPreferencesProvider).setString(state.key, value);
    state = SharedPreferencesState(key, value);
  }
}
