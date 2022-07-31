import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/diary_setting.dart';
import 'package:pilll/domain/diary_post/diary_post_state_provider_family.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

part 'state.codegen.freezed.dart';

@freezed
final diaryPostAsyncStateProvider = Provider.autoDispose.family<AsyncValue<DiaryPostState>, DiaryPostStateProviderFamily>((ref, family) {
  final diarySetting = ref.watch(diarySettingStreamProvider).asData?.value;
  final diary = family.diary ?? Diary.fromDate(family.date);

  try {
    return AsyncValue.data(DiaryPostState(
      diary: diary,
      diarySetting: diarySetting,
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
