import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences.g.dart';

// overrideする前提なので.autoDisposeはつけない=(keeyAlive: trueにする)。またこれに依存したProviderもkeepAlive: trueにする必要がある
@Riverpod(keepAlive: true, dependencies: [])
SharedPreferences sharedPreferences(SharedPreferencesRef ref) {
  throw UnimplementedError('sharedPreferencesProvider is not implemented');
}
