import 'dart:async';

import 'state.codegen.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'async_action.dart';
import 'state.codegen.dart';

final diarySettingStateNotifierProvider = StateNotifierProvider.autoDispose<DiarySettingStateNotifier, AsyncValue<DiarySettingState>>(
  (ref) => DiarySettingStateNotifier(
    asyncAction: ref.watch(diarySettingAsyncActionProvider),
    initialState: ref.watch(diarySettingAsyncStateProvider),
  ),
);

class DiarySettingStateNotifier extends StateNotifier<AsyncValue<DiarySettingState>> {
  final DiarySettingAsyncAction asyncAction;
  DiarySettingStateNotifier({
    required this.asyncAction,
    required AsyncValue<DiarySettingState> initialState,
  }) : super(initialState);
}
