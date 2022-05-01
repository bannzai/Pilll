import 'package:pilll/domain/settings/setting_page_async_action.dart';
import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:riverpod/riverpod.dart';

final settingStoreProvider =
    StateNotifierProvider<SettingStateNotifier, AsyncValue<SettingState>>(
  (ref) => SettingStateNotifier(
    asyncAction: ref.watch(settingPageAsyncActionProvider),
    initialState: ref.watch(settingStateProvider),
  ),
);

class SettingStateNotifier extends StateNotifier<AsyncValue<SettingState>> {
  final SettingPageAsyncAction asyncAction;
  SettingStateNotifier({
    required this.asyncAction,
    required AsyncValue<SettingState> initialState,
  }) : super(initialState);
}
