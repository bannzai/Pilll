import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';

final pilllAdsProvider = StreamProvider((ref) => ref.watch(databaseProvider).pilllAds().snapshots().map((event) => event.data()));
// TODO:
// final affiliateProvier 
