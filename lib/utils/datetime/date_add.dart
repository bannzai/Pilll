import 'package:timezone/timezone.dart';

// dateTime.addDays(n) だと n * 24 * 60 * 59 * 1000 が足されるので、サマータイムの国ではずれる
extension DateTimeAdd on DateTime {
  DateTime addDays(int offset) {
    return DateTime(
      year,
      month,
      day + offset,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}

extension TZDateTimeAdd on TZDateTime {
  TZDateTime addDays(int offset) {
    return TZDateTime(
      location,
      year,
      month,
      day + offset,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
