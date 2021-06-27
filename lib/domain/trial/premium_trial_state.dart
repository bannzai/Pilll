import 'package:freezed_annotation/freezed_annotation.dart';

part 'premium_trial_state.freezed.dart';

@freezed
abstract class PremiumTrialState implements _$PremiumTrialState {
  PremiumTrialState._();
  factory PremiumTrialState({
    @Default(false) bool isLoading,
    @Default(false) bool isFirstLoadEnded,
    Object? exception,
  }) = _PremiumTrialState;
}
