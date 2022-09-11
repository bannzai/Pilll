import 'package:pilll/database/database.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/util/datetime/day.dart';

final schedulesProvider = Provider.family((ref, DateTime date) async {
  final range = date.dateRange();
  return await ref
      .watch(databaseProvider)
      .schedulesReference()
      .where(
        ScheduleFirestoreKey.date,
        isGreaterThanOrEqualTo: range.begin,
        isLessThanOrEqualTo: range.end,
      )
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());
});
