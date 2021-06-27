import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';

part 'premium_trial_modal_state.freezed.dart';

@freezed
abstract class PremiumTrialModalState implements _$PremiumTrialModalState {
  PremiumTrialModalState._();
  factory PremiumTrialModalState({
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? beginTrialDate,
    @Default(false)
        bool isLoading,
    @Default(false)
        bool isTrial,
    Object? exception,
  }) = _PremiumTrialModalState;
}
