import 'package:pilll/util/datetime/day.dart';

class TodayService {
  DateTime today() => DateTime.now().date();
  DateTime now() => DateTime.now();
}

TodayService todayRepository = TodayService();
