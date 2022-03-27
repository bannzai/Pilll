import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'premium_trial_modal_state.freezed.dart';

@freezed
class PremiumTrialModalState with _$PremiumTrialModalState {
  const PremiumTrialModalState._();
  const factory PremiumTrialModalState({
    DateTime? beginTrialDate,
    @Default(false) bool isLoading,
    @Default(false) bool isTrial,
    Setting? setting,
    Object? exception,
  }) = _PremiumTrialModalState;
}
