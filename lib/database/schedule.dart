import 'package:pilll/database/database.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/util/datetime/day.dart';

final schedulesProvider = FutureProvider.family((ref, DateTime dateForMonth) async {
  final range = MonthDateTimeRange.monthRange(dateForMonth: dateForMonth);
  return await ref
      .watch(databaseProvider)
      .schedulesReference()
      .where(
        ScheduleFirestoreKey.date,
        isGreaterThanOrEqualTo: range.start,
        isLessThanOrEqualTo: range.end,
      )
      .get()
      .then((value) => value.docs.map((e) => e.data()).toList());
});

final schedulesAround90Days = StreamProvider.family((ref, DateTime base) {
  return ref
      .watch(databaseProvider)
      .schedulesReference()
      .where(ScheduleFirestoreKey.date,
          isLessThanOrEqualTo: DateTime(base.year, base.month, 90), isGreaterThanOrEqualTo: DateTime(base.year, base.month, -90))
      .orderBy(ScheduleFirestoreKey.date)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());
});
