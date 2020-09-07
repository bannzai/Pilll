import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String string(DateTime datetime) {
    var formatter = NumberFormat("00");
    return formatter.format(datetime.hour) +
        ":" +
        formatter.format(datetime.minute);
  }
}
