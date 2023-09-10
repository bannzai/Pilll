import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/package_info.dart';
import 'package:pilll/utils/version/version.dart';

final pilllAdsProvider = StreamProvider((ref) => ref.watch(databaseProvider).pilllAds().snapshots().map((event) => event.data()));
