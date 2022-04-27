import 'package:pilll/domain/settings/menstruation/setting_menstruation_state.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/database/setting.dart';
import 'package:riverpod/riverpod.dart';

final settingMenstruationStoreProvider = StateNotifierProvider.autoDispose<
    SettingMenstruationStateStore, SettingMenstruationState>(
  (ref) => SettingMenstruationStateStore(
    ref.watch(settingDatastoreProvider),
  ),
);

class SettingMenstruationStateStore
    extends StateNotifier<SettingMenstruationState> {
  final SettingDatastore _settingDatastore;
  SettingMenstruationStateStore(
    this._settingDatastore,
  ) : super(const SettingMenstruationState());

  Future<void> modifyFromMenstruation({
    required Setting setting,
    required int pageIndex,
    required int fromMenstruation,
  }) {
    final offset = summarizedPillCountWithPillSheetTypesToEndIndex(
        pillSheetTypes: setting.pillSheetEnumTypes, endIndex: pageIndex);
    return _settingDatastore.update(setting.copyWith(
        pillNumberForFromMenstruation: fromMenstruation + offset));
  }

  Future<void> modifyFromMenstruationFromPicker({
    required Setting setting,
    required int serializedPillNumberIntoGroup,
  }) {
    return _settingDatastore.update(setting.copyWith(
        pillNumberForFromMenstruation: serializedPillNumberIntoGroup));
  }

  Future<void> modifyDurationMenstruation({
    required Setting setting,
    required int durationMenstruation,
  }) {
    return _settingDatastore
        .update(setting.copyWith(durationMenstruation: durationMenstruation));
  }

  int? retrieveMenstruationSelectedPillNumber(
    Setting setting,
    int pageIndex,
  ) {
    final _passedTotalCount = summarizedPillCountWithPillSheetTypesToEndIndex(
        pillSheetTypes: setting.pillSheetEnumTypes, endIndex: pageIndex);
    if (_passedTotalCount >= setting.pillNumberForFromMenstruation) {
      return setting.pillNumberForFromMenstruation;
    }
    final diff = setting.pillNumberForFromMenstruation - _passedTotalCount;
    if (diff > setting.pillSheetEnumTypes[pageIndex].totalCount) {
      return null;
    }
    return diff;
  }
}
