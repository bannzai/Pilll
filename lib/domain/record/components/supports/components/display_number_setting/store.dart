import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/service/pill_sheet_group.dart';

import 'state.codegen.dart';
import 'package:riverpod/riverpod.dart';

final displayNumberSettingStateStoreProvider =
    StateNotifierProvider.autoDispose<DisplayNumberSettingStateStore,
        DisplayNumberSettingState>((ref) {
  return DisplayNumberSettingStateStore(
    ref.watch(pillSheetGroupServiceProvider),
    pillSheetGroup: ref.watch(recordPageStoreProvider).pillSheetGroup!,
  );
});

class DisplayNumberSettingStateStore
    extends StateNotifier<DisplayNumberSettingState> {
  final PillSheetGroupService _pillSheetGroupService;
  DisplayNumberSettingStateStore(
    this._pillSheetGroupService, {
    required PillSheetGroup pillSheetGroup,
  }) : super(DisplayNumberSettingState(
            pillSheetGroup: pillSheetGroup.copyWith())) {
    setup();
  }

  void setup() async {
    final beforePillSheetGroup =
        await _pillSheetGroupService.fetchBeforePillSheetGroup();
    state = state.copyWith(beforePillSheetGroup: beforePillSheetGroup);
  }

  void setBeginDisplayPillNumber(
    int beginDisplayPillNumber,
  ) {
    final displayNumberSetting = state.pillSheetGroup.displayNumberSetting;
    if (displayNumberSetting == null) {
      state = state.copyWith(
        pillSheetGroup: state.pillSheetGroup.copyWith(
          displayNumberSetting: DisplayNumberSetting(
            beginPillNumber: beginDisplayPillNumber,
          ),
        ),
      );
    } else {
      state = state.copyWith(
        pillSheetGroup: state.pillSheetGroup.copyWith(
          displayNumberSetting: displayNumberSetting.copyWith(
            beginPillNumber: beginDisplayPillNumber,
          ),
        ),
      );
    }
  }

  void setEndDisplayPillNumber(
    int endDisplayPillNumber,
  ) {
    final displayNumberSetting = state.pillSheetGroup.displayNumberSetting;
    if (displayNumberSetting == null) {
      state = state.copyWith(
        pillSheetGroup: state.pillSheetGroup.copyWith(
          displayNumberSetting: DisplayNumberSetting(
            endPillNumber: endDisplayPillNumber,
          ),
        ),
      );
    } else {
      state = state.copyWith(
        pillSheetGroup: state.pillSheetGroup.copyWith(
          displayNumberSetting: displayNumberSetting.copyWith(
            endPillNumber: endDisplayPillNumber,
          ),
        ),
      );
    }
  }
}
