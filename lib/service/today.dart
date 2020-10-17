abstract class TodayServiceInterface {
  DateTime today();
}

class TodayService implements TodayServiceInterface {
  DateTime today() => DateTime.now();
}

TodayServiceInterface todayRepository = TodayService();
