import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/setting.dart';

part 'premium_trial_modal_state.freezed.dart';

@freezed
class PremiumTrialModalState implements _$PremiumTrialModalState {
  PremiumTrialModalState._();
  factory PremiumTrialModalState({
    DateTime? beginTrialDate,
    @Default(false) bool isLoading,
    @Default(false) bool isTrial,
    Setting? setting,
    Object? exception,
  }) = _PremiumTrialModalState;
}
