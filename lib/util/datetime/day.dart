import 'package:Pilll/service/today.dart';

DateTime today() {
  return todayRepository.today();
}

extension Date on DateTime {
  DateTime date() {
    return DateTime(year, month, day);
  }
}
