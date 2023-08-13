import 'package:pilll/provider/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'typed_shared_preferences.g.dart';

@riverpod
class BoolSharedPreferences extends _$BoolSharedPreferences {
  final String key;

  BoolSharedPreferences(this.key);

  @override
  bool? build() => ref.read(sharedPreferencesProvider).getBool(key);

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(key, value);
    ref.invalidateSelf();
  }
}

@riverpod
class IntSharedPreferences extends _$IntSharedPreferences {
  final String key;

  IntSharedPreferences(this.key);

  @override
  bool? build() => ref.read(sharedPreferencesProvider).getInt(key);

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setInt(key, value);
    ref.invalidateSelf();
  }
}

@riverpod
class StringSharedPreferences extends _$StringSharedPreferences {
  final String key;

  StringSharedPreferences(this.key);

  @override
  bool? build() => ref.read(sharedPreferencesProvider).getString(key);

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setString(key, value);
    ref.invalidateSelf();
  }
}
