import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';

final affiliateProvider = StreamProvider((ref) => ref.watch(databaseProvider).affiliate().snapshots().map((event) => event.data()));
