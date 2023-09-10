import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/version/version.dart';

final packageVersionProvider = FutureProvider((ref) {
  return Version.fromPackage();
});
