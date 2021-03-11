import 'package:pilll/service/today.dart';

DateTime today() {
  return todayRepository.today();
}

DateTime now() {
  return todayRepository.now();
}

extension Date on DateTime {
  DateTime date() {
    return DateTime(year, month, day);
  }
}
