import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/service/setting.dart';
import 'package:Pilll/service/today.dart';
import 'package:mockito/mockito.dart';

class MockPillSheetRepository extends Mock
    implements PillSheetServiceInterface {}

class MockTodayRepository extends Mock implements TodayServiceInterface {}

class MockSettingService extends Mock implements SettingService {}

class MockPillSheetService extends Mock implements PillSheetService {}
