abstract class TodayRepositoryInterface {
  DateTime today();
}

class TodayRepository implements TodayRepositoryInterface {
  DateTime today() => DateTime.now();
}

TodayRepositoryInterface todayRepository = TodayRepository();
