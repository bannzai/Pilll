import 'package:pilll/analytics.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/day.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/service/user.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  PillSheetService,
  TodayService,
  SettingService,
  Analytics,
  DiaryService,
  MenstruationService,
  AuthService,
  UserService
])
class FakeUserForNotPremium extends Fake implements User {
  @override
  bool get isPremium => false;
}
