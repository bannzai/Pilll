import 'package:pilll/domain/settings/menstruation/setting_menstruation_state.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

final settingMenstruationStoreProvider = StateNotifierProvider.autoDispose(
  (ref) => SettingMenstruationStateStore(
    ref.watch(settingServiceProvider),
  ),
);

class SettingMenstruationStateStore
    extends StateNotifier<SettingMenstruationState> {
  final SettingService _settingService;
  SettingMenstruationStateStore(
    this._settingService,
  ) : super(SettingMenstruationState());

  Future<void> modifyFromMenstruation({
    required Setting setting,
    required int pageIndex,
    required int fromMenstruation,
  }) {
    final offset = passedTotalCount(
        pillSheetTypes: setting.pillSheetTypes, pageIndex: pageIndex);
    return _settingService.update(setting.copyWith(
        pillNumberForFromMenstruation: fromMenstruation + offset));
  }

  Future<void> modifyFromMenstruationFromPicker({
    required Setting setting,
    required int serializedPillNumberIntoGroup,
  }) {
    return _settingService.update(setting.copyWith(
        pillNumberForFromMenstruation: serializedPillNumberIntoGroup));
  }

  Future<void> modifyDurationMenstruation({
    required Setting setting,
    required int durationMenstruation,
  }) {
    return _settingService
        .update(setting.copyWith(durationMenstruation: durationMenstruation));
  }

  int? retrieveMenstruationSelectedPillNumber(
    Setting setting,
    int pageIndex,
  ) {
    final _passedTotalCount = passedTotalCount(
        pillSheetTypes: setting.pillSheetTypes, pageIndex: pageIndex);
    if (_passedTotalCount >= setting.pillNumberForFromMenstruation) {
      return setting.pillNumberForFromMenstruation;
    }
    final diff = setting.pillNumberForFromMenstruation - _passedTotalCount;
    if (diff > setting.pillSheetTypes[pageIndex].totalCount) {
      return null;
    }
    return diff;
  }
}
