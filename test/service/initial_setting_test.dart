import 'package:pilll/domain/initial_setting/initial_setting_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/initial_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group("#register", () {
    test("when today pill number is not null", () async {
      final initialSetting = InitialSettingState(
        todayPillNumber: 1,
        pillSheetType: PillSheetType.pillsheet_21,
      );
      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batch.commit()).thenAnswer((realInvocation) => Future.value());
      when(batchFactory.batch()).thenReturn(batch);

      final settingService = MockSettingService();
      final settingEntity = initialSetting.buildSetting();
      when(settingService.update(settingEntity))
          .thenAnswer((realInvocation) => Future.value(settingEntity));

      final pillSheetEntity = initialSetting.buildPillSheet();
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.register(any, pillSheetEntity!)).thenAnswer(
          (realInvocation) => PillSheet(
              typeInfo: PillSheetType.pillsheet_21.typeInfo,
              beginingDate: DateTime.now()));
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifedHistoryService.add(batch, any))
          .thenAnswer((_) => Future.value());
      final pillSheetGroupService = MockPillSheetGroupService();

      final service = InitialSettingService(
        batchFactory,
        settingService,
        pillSheetService,
        pillSheetModifedHistoryService,
        pillSheetGroupService,
      );
      await service.register(
          initialSetting.buildSetting(), initialSetting.buildPillSheet());

      verify(settingService.update(settingEntity));
      verify(pillSheetService.register(any, pillSheetEntity));
    });
  });
}
