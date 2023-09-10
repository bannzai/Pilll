import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/package_info.dart';
import 'package:pilll/utils/version/version.dart';

final pilllAdsProvider = StreamProvider((ref) => ref.watch(databaseProvider).pilllAds().snapshots().map((event) => event.data()));
final showsPillAdsProvider = StreamProvider((ref) {
  final packageVersion = ref.watch(packageVersionProvider).asData?.value;
  final pillAds = ref.watch(pilllAdsProvider).asData?.value;
  if (packageVersion == null || pillAds == null) {
    return const Stream.empty();
  }
  final pillAdsVersion = Version.parse(pillAds.version);
  if (pillAdsVersion.isLessThan(packageVersion)) {
    return Stream.value(false);
  }

  return Stream.value(true);
});
