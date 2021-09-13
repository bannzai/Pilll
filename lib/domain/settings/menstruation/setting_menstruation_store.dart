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
    final entity = settingState.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    final menstruations = entity.menstruations;
    menstruations[pageIndex] = menstruations[pageIndex].copyWith(
      pillNumberForFromMenstruation: fromMenstruation,
    );
    final updated = entity.copyWith(
      pillNumberForFromMenstruation: fromMenstruation,
      menstruations: menstruations,
    );
    return _settingService.update(updated);
  }

  Future<void> modifyDurationMenstruation({
    required int pageIndex,
    required int durationMenstruation,
  }) {
    final entity = settingState.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    final menstruations = entity.menstruations;
    menstruations[pageIndex] = menstruations[pageIndex].copyWith(
      durationMenstruation: durationMenstruation,
    );
    final updated = entity.copyWith(
      durationMenstruation: durationMenstruation,
      menstruations: menstruations,
    );
    return _settingService.update(updated);
  }

  setCurrentPageIndex(int pageIndex) {
    state = state.copyWith(currentPageIndex: pageIndex);
  }
}
