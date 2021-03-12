import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/initial_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group("#register", () {
    test("when today pill number is not null", () async {
      final initialSetting = InitialSettingModel.initial(
        todayPillNumber: 1,
        pillSheetType: PillSheetType.pillsheet_21,
      );
      final settingService = MockSettingService();
      final settingEntity = initialSetting.buildSetting();
      when(settingService.update(settingEntity))
          .thenAnswer((realInvocation) => Future.value(settingEntity));

      final pillSheetEntity = initialSetting.buildPillSheet();
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.register(any))
          .thenAnswer((realInvocation) => Future.value(pillSheetEntity));

      final service = InitialSettingService(settingService, pillSheetService);
      await service.register(initialSetting);

      verify(settingService.update(settingEntity));
      verify(pillSheetService.register(any));
    });
    test("when today pill number is null", () async {
      final initialSetting = InitialSettingModel.initial(
        todayPillNumber: null,
        pillSheetType: PillSheetType.pillsheet_21,
      );
      final settingService = MockSettingService();
      final settingEntity = initialSetting.buildSetting();
      when(settingService.update(settingEntity))
          .thenAnswer((realInvocation) => Future.value(settingEntity));

      final pillSheetEntity = initialSetting.buildPillSheet();
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.register(any))
          .thenAnswer((realInvocation) => Future.value(pillSheetEntity));

      final service = InitialSettingService(settingService, pillSheetService);
      await service.register(initialSetting);

      verify(settingService.update(settingEntity));
      verifyNever(pillSheetService.register(any));
    });
  });
}
