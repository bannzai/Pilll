import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

part 'state.codegen.freezed.dart';

@freezed
final diaryPostAsyncStateProvider = Provider.autoDispose<AsyncValue<DiaryPostState>>((ref) {
  final diarySetting = ref.watch(diarystate);

  if (diarySetting is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(DiarySettingPhysicalConditionDetailState(
      diarySetting: diarySetting.value,
    ));
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace: stackTrace);
  }
});

class DiaryPostState with _$DiaryPostState {
  factory DiaryPostState({
    required Diary diary,
    required DiarySetting? diarySetting,
  }) = _DiaryPostState;
  DiaryPostState._();
}
