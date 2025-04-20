import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_parameter.codegen.freezed.dart';
part 'remote_config_parameter.codegen.g.dart';

abstract class RemoteConfigKeys {
  static const isPaywallFirst = 'isPaywallFirst';
  static const skipInitialSetting = 'skipInitialSetting';
  static const trialDeadlineDateOffsetDay = 'trialDeadlineDateOffsetDay';
  static const discountEntitlementOffsetDay = 'discountEntitlementOffsetDay';
  static const discountCountdownBoundaryHour = 'discountCountdownBoundaryHour';
  static const releasedVersion = 'releasedVersion';
  static const premiumIntroductionPattern = 'premiumIntroductionPattern';
  static const premiumIntroductionShowsAppStoreReviewCard = 'premiumIntroductionShowsAppStoreReviewCard';
}

abstract class RemoteConfigParameterDefaultValues {
  static const isPaywallFirst = false;
  static const skipInitialSetting = false;
  static const trialDeadlineDateOffsetDay = 45;
  static const discountEntitlementOffsetDay = 2;
  static const discountCountdownBoundaryHour = 48;
  static const releasedVersion = '202407.29.133308';
  // default(A) or B or C ...
  static const premiumIntroductionPattern = 'default';
  static const premiumIntroductionShowsAppStoreReviewCard = false;
}

// [RemoteConfigDefaultValues] でgrepした場所に全て設定する
@freezed
class RemoteConfigParameter with _$RemoteConfigParameter {
  factory RemoteConfigParameter({
    @Default(RemoteConfigParameterDefaultValues.isPaywallFirst) bool isPaywallFirst,
    @Default(RemoteConfigParameterDefaultValues.skipInitialSetting) bool skipInitialSetting,
    @Default(RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay) int trialDeadlineDateOffsetDay,
    @Default(RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay) int discountEntitlementOffsetDay,
    @Default(RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour) int discountCountdownBoundaryHour,
    @Default(RemoteConfigParameterDefaultValues.premiumIntroductionPattern) String premiumIntroductionPattern,
    @Default(RemoteConfigParameterDefaultValues.premiumIntroductionShowsAppStoreReviewCard) bool premiumIntroductionShowsAppStoreReviewCard,
  }) = _RemoteConfigParameter;
  RemoteConfigParameter._();
  factory RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);
}
