import 'package:pilll/util/datetime/day.dart';

abstract class TodayServiceInterface {
  DateTime today();
  DateTime now();
}

class TodayService implements TodayServiceInterface {
  DateTime today() => DateTime.now().date();
  DateTime now() => DateTime.now();
}

TodayServiceInterface todayRepository = TodayService();
