import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/initial_setting/initial_setting_state_notifier.dart';
import 'package:pilll/provider/force_update.dart';
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/menstruation.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:mockito/annotations.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/local_notification.dart';

@GenerateMocks([
  TodayService,
  Analytics,
  BatchFactory,
  WriteBatch,
  User,
  Setting,
  BatchSetPillSheetGroup,
  BatchSetPillSheetModifiedHistory,
  BatchSetSetting,
  SetSetting,
  SetPillSheetGroup,
  DeleteMenstruation,
  SetMenstruation,
  BeginMenstruation,
  DatabaseConnection,
  EndInitialSetting,
  PurchaseService,
  RevertTakePill,
  TakePill,
  CheckForceUpdate,
  SetUserID,
  FetchOrCreateUser,
  SaveUserLaunchInfo,
  ErrorLogger,
  FirestoreIDGenerator,
  LocalNotificationService,
  RegisterReminderLocalNotificationRunner,
])
abstract class KeepGeneratedMocks {}
