import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/record_page_store.dart';
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
  PillSheetService,
  TodayService,
  SettingService,
  Analytics,
  DiaryService,
  MenstruationService,
  AuthService,
  UserService,
  RecordPageStore,
  NotificationBarStateStore,
  PremiumIntroductionStore,
  PillSheetModifiedHistoryService,
  PillSheetGroupService,
  BatchFactory,
  WriteBatch,
])
abstract class KeepGeneratedMocks {}
