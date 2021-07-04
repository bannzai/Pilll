import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/day.dart';
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
  UserService,
  RecordPageStore,
])
abstract class KeepGeneratedMocks {}
