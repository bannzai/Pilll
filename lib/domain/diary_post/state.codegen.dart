import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/diary_setting.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/domain/diary_post/diary_post_state_provider_family.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

part 'state.codegen.freezed.dart';

final diaryPostAsyncStateProvider = Provider.autoDispose.family<AsyncValue<DiaryPostState>, DiaryPostStateProviderFamily>((ref, family) {
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);
  final diarySetting = ref.watch(diarySettingStreamProvider).asData?.value;
  final diary = family.diary ?? Diary.fromDate(family.date);
  if (premiumAndTrial is AsyncLoading) {
    return const AsyncLoading();
  }

  try {
    return AsyncValue.data(DiaryPostState(
      premiumAndTrial: premiumAndTrial.value!,
      diary: diary,
      diarySetting: diarySetting,
    ));
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace: stackTrace);
  }
});

@freezed
class DiaryPostState with _$DiaryPostState {
  factory DiaryPostState({
    required PremiumAndTrial premiumAndTrial,
    required Diary diary,
    required DiarySetting? diarySetting,
  }) = _DiaryPostState;
  DiaryPostState._();
}
