import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/calendar/calendar_page_async_action.dart';
import 'package:pilll/domain/menstruation/menstruation_page_async_action.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_async_action.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/domain/settings/setting_page_async_action.dart';
import 'package:pilll/domain/settings/setting_page_state_notifier.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/database/user.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  PillSheetDatastore,
  TodayService,
  SettingDatastore,
  Analytics,
  DiaryDatastore,
  MenstruationDatastore,
  AuthService,
  UserDatastore,
  PremiumIntroductionStore,
  PillSheetModifiedHistoryDatastore,
  PillSheetGroupDatastore,
  BatchFactory,
  WriteBatch,
  SettingPageAsyncAction,
  MenstruationPageAsyncAction,
  MenstruationEditPageAsyncAction,
  CalendarPageAsyncAction,
  PremiumAndTrial,
  Setting,
  SettingStateNotifier,
  BatchSetPillSheetGroup,
  BatchSetPillSheets,
  BatchSetPillSheetModifiedHistory,
  BatchSetSetting,
  SetSetting,
  SetPillSheetGroup,
  DatabaseConnection,
])
abstract class KeepGeneratedMocks {}
