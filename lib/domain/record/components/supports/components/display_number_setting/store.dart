import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';

import 'state.codegen.dart';
import 'package:riverpod/riverpod.dart';

final displayNumberSettingStateStoreProvider =
    StateNotifierProvider.autoDispose<DisplayNumberSettingStateStore,
        DisplayNumberSettingState>((ref) {
  return DisplayNumberSettingStateStore(
    ref.watch(batchFactoryProvider),
    ref.watch(pillSheetGroupDatastoreProvider),
    ref.watch(pillSheetModifiedHistoryDatastoreProvider),
    pillSheetGroup: ref.watch(recordPageStoreProvider).value!.pillSheetGroup!,
  );
});

class DisplayNumberSettingStateStore
    extends StateNotifier<DisplayNumberSettingState> {
  final BatchFactory _batchFactory;
  final PillSheetGroupDatastore _pillSheetGroupDatastore;
  final PillSheetModifiedHistoryDatastore _pillSheetModifiedHistoryDatastore;

  DisplayNumberSettingStateStore(
    this._batchFactory,
    this._pillSheetGroupDatastore,
    this._pillSheetModifiedHistoryDatastore, {
    required PillSheetGroup pillSheetGroup,
  }) : super(DisplayNumberSettingState(
          pillSheetGroup: pillSheetGroup.copyWith(),
          originalPillSheetGroup: pillSheetGroup.copyWith(),
        )) {
    setup();
  }

  void setup() async {
    final beforePillSheetGroup =
        await _pillSheetGroupDatastore.fetchBeforePillSheetGroup();
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

  Future<void> modify() async {
    final displayNumberSetting = state.pillSheetGroup.displayNumberSetting;
    if (displayNumberSetting == null) {
      return;
    }

    final batch = _batchFactory.batch();
    if (displayNumberSetting.beginPillNumber !=
        state.originalPillSheetGroup.displayNumberSetting?.beginPillNumber) {
      _pillSheetModifiedHistoryDatastore.add(
        batch,
        PillSheetModifiedHistoryServiceActionFactory
            .createChangedBeginDisplayNumberAction(
          pillSheetGroupID: state.pillSheetGroup.id,
          beforeDisplayNumberSetting:
              state.originalPillSheetGroup.displayNumberSetting,
          afterDisplayNumberSetting: displayNumberSetting,
        ),
      );
    }

    if (displayNumberSetting.endPillNumber !=
        state.originalPillSheetGroup.displayNumberSetting?.endPillNumber) {
      _pillSheetModifiedHistoryDatastore.add(
        batch,
        PillSheetModifiedHistoryServiceActionFactory
            .createChangedEndDisplayNumberAction(
          pillSheetGroupID: state.pillSheetGroup.id,
          beforeDisplayNumberSetting:
              state.originalPillSheetGroup.displayNumberSetting,
          afterDisplayNumberSetting: displayNumberSetting,
        ),
      );
    }

    _pillSheetGroupDatastore.updateWithBatch(batch, state.pillSheetGroup);

    await batch.commit();
  }
}
