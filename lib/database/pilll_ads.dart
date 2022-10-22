import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/util/stream.dart';

final pilllAdsProvider = StreamProvider((ref) => ref.watch(databaseProvider).pilllAds().snapshots().map((event) => event.data()).whereNotNull());
