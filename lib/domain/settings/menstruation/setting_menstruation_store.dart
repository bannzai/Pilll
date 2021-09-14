import 'package:pilll/domain/settings/menstruation/setting_menstruation_state.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

final settingMenstruationStoreProvider = StateNotifierProvider(
  (ref) => SettingMenstruationStateStore(
    ref.watch(settingStateProvider),
    ref.watch(settingServiceProvider),
  ),
);

class SettingMenstruationStateStore
    extends StateNotifier<SettingMenstruationState> {
  final SettingState settingState;
  final SettingService _settingService;
  SettingMenstruationStateStore(
    this.settingState,
    this._settingService,
  ) : super(SettingMenstruationState());

  Future<void> modifyFromMenstruation({
    required int pageIndex,
    required int fromMenstruation,
  }) {
    final setting = settingState.entity;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    return _settingService.update(
        setting.copyWith(pillNumberForFromMenstruation: fromMenstruation));
  }

  Future<void> modifyDurationMenstruation({
    required int pageIndex,
    required int durationMenstruation,
  }) {
    final setting = settingState.entity;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    return _settingService
        .update(setting.copyWith(durationMenstruation: durationMenstruation));
  }

  setCurrentPageIndex(int pageIndex) {
    state = state.copyWith(currentPageIndex: pageIndex);
  }
}
