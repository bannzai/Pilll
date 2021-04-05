import 'package:pilll/analytics.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/day.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/state/diaries.dart';
import 'package:pilll/store/diaries.dart';

class MockPillSheetRepository extends Mock
    implements PillSheetServiceInterface {}

class MockTodayRepository extends Mock implements TodayServiceInterface {}

class MockSettingService extends Mock implements SettingService {}

class MockPillSheetService extends Mock implements PillSheetService {}

class MockAnalytics extends Mock implements AbstractAnalytics {}

class MockDiariesStateStore extends Mock implements DiariesStateStore {
  final DiariesState _state;

  MockDiariesStateStore(this._state);
  DiariesState get state => _state;
}
