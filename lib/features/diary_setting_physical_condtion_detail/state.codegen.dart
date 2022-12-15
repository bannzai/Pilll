import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/diary_setting.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

part 'features/diary_setting_physical_condtion_detail/state.codegen.freezed.dart';

final diarySettingPhysicalConditionDetailAsyncStateProvider = Provider.autoDispose<AsyncValue<DiarySettingPhysicalConditionDetailState>>((ref) {
  final diarySetting = ref.watch(diarySettingProvider);

  if (diarySetting is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(DiarySettingPhysicalConditionDetailState(
      diarySetting: diarySetting.value,
    ));
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
});

@freezed
class DiarySettingPhysicalConditionDetailState with _$DiarySettingPhysicalConditionDetailState {
  factory DiarySettingPhysicalConditionDetailState({
    required DiarySetting? diarySetting,
  }) = _DiarySettingPhysicalConditionDetailState;
  DiarySettingPhysicalConditionDetailState._();
}
