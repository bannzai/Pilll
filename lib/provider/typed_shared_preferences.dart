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
