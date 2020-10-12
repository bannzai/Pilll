import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/service/setting.dart';
import 'package:Pilll/service/today.dart';
import 'package:Pilll/service/user.dart';
import 'package:riverpod/all.dart';

Provider<UserServiceInterface> userServiceProvider =
    Provider((ref) => UserService(ref.read));

Provider<PillSheetServiceInterface> pillSheetService =
    Provider((ref) => PIllSheetService(ref.read));

Provider<SettingServiceInterface> settingService =
    Provider((ref) => SettingService(ref.read));

Provider<TodayServiceInterface> todayService =
    Provider((ref) => TodayService());
