import 'package:pilll/domain/record/components/add_pill_sheet_group/add_pill_sheet_group_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:riverpod/riverpod.dart';

final addPillSheetGroupStateStoreProvider = StateNotifierProvider.autoDispose<
    AddPillSheetGroupStateStore, AddPillSheetGroupState>(
  (ref) {
    return AddPillSheetGroupStateStore(
      ref.watch(recordPageStoreProvider).pillSheetGroup,
      ref.watch(recordPageStoreProvider).appearanceMode,
      ref.watch(pillSheetGroupServiceProvider),
    );
  },
);

class AddPillSheetGroupStateStore
    extends StateNotifier<AddPillSheetGroupState> {
  final PillSheetGroupService _pillSheetGroupService;
  AddPillSheetGroupStateStore(
    PillSheetGroup? pillSheetGroup,
    PillSheetAppearanceMode pillSheetAppearanceMode,
    this._pillSheetGroupService,
  ) : super(AddPillSheetGroupState(
          pillSheetGroup: pillSheetGroup,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        ));
}
