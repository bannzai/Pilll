import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_trial_modal_state.freezed.dart';

@freezed
abstract class PremiumTrialModalState implements _$PremiumTrialModalState {
  PremiumTrialModalState._();
  factory PremiumTrialModalState({
    @Default(false) bool isLoading,
    @Default(false) bool isTrial,
    Object? exception,
  }) = _PremiumTrialModalState;
}
