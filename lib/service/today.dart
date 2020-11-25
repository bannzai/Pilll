import 'package:Pilll/util/datetime/day.dart';

abstract class TodayServiceInterface {
  DateTime today();
}

class TodayService implements TodayServiceInterface {
  DateTime today() => DateTime.now().date();
}

TodayServiceInterface todayRepository = TodayService();
