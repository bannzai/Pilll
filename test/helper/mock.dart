import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/service/day.dart';
import 'package:mockito/annotations.dart';
import 'package:pilll/service/purchase.dart';

@GenerateMocks([
  TodayService,
  Analytics,
  BatchFactory,
  WriteBatch,
  PremiumAndTrial,
  Setting,
  BatchSetPillSheetGroup,
  BatchSetPillSheets,
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
])
abstract class KeepGeneratedMocks {}
