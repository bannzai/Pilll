import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/store/menstruation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/delay.dart';
import '../../helper/mock.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("#cardState", () {
    test(
      "if latestMenstruation is into today, when return card state of begining about menstruation ",
      () async {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        final today = DateTime(2021, 04, 29);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final menstruationService = MockMnestruationService();
        when(menstruationService.fetchAll()).thenAnswer(
          (realInvocation) => Future.value([
            Menstruation(
              beginDate: DateTime(2021, 04, 28),
              endDate: DateTime(2021, 04, 30),
              createdAt: DateTime(2021, 04, 28),
            ),
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        when(menstruationService.subscribeAll()).thenAnswer(
          (realInvocation) => Stream.value([
            Menstruation(
              beginDate: DateTime(2021, 04, 28),
              endDate: DateTime(2021, 04, 30),
              createdAt: DateTime(2021, 04, 28),
            ),
            Menstruation(
              beginDate: DateTime(2021, 03, 28),
              endDate: DateTime(2021, 03, 30),
              createdAt: DateTime(2021, 03, 28),
            ),
          ]),
        );
        final pillSheetService = MockPillSheetService();
        when(pillSheetService.fetchLast())
            .thenAnswer((realInvocation) => Future.value(null));
        when(pillSheetService.subscribeForLatestPillSheet())
            .thenAnswer((realInvocation) => Stream.empty());
        final diaryService = MockDiaryService();
        when(diaryService.fetchListAround90Days(today))
            .thenAnswer((realInvocation) => Future.value([]));
        when(diaryService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());
        final settingService = MockSettingService();
        when(settingService.fetch())
            .thenAnswer((realInvocation) => Future.value(null));
        when(settingService.subscribe())
            .thenAnswer((realInvocation) => Stream.empty());

        final store = MenstruationStore(
          menstruationService: menstruationService,
          diaryService: diaryService,
          settingService: settingService,
          pillSheetService: pillSheetService,
        );
        await waitForResetStoreState();
        final actual = store.cardState();

        expect(
            actual,
            MenstruationCardState(
                title: "生理開始日",
                scheduleDate: DateTime(2021, 04, 28),
                countdownString: "2日目"));
      },
    );
  });
}
