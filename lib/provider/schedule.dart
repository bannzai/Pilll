import 'package:pilll/database/database.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/util/datetime/day.dart';

final schedulesForDateProvider = StreamProvider.family((ref, DateTime date) {
  final range = date.dateTimeRange();
  return ref
      .watch(databaseProvider)
      .schedulesReference()
      .where(
        ScheduleFirestoreKey.date,
        isGreaterThanOrEqualTo: range.start,
        isLessThanOrEqualTo: range.end,
      )
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());
});

final schedulesForMonthProvider = StreamProvider.family((ref, DateTime dateForMonth) {
  final range = MonthDateTimeRange.monthRange(dateForMonth: dateForMonth);
  return ref
      .watch(databaseProvider)
      .schedulesReference()
      .where(
        ScheduleFirestoreKey.date,
        isGreaterThanOrEqualTo: range.start,
        isLessThanOrEqualTo: range.end,
      )
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());
});

final schedules90Days = StreamProvider.family((ref, DateTime base) {
  return ref
      .watch(databaseProvider)
      .schedulesReference()
      .where(ScheduleFirestoreKey.date,
          isLessThanOrEqualTo: DateTime(base.year, base.month, 90), isGreaterThanOrEqualTo: DateTime(base.year, base.month, -90))
      .orderBy(ScheduleFirestoreKey.date)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList());
});
