// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_parameter.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RemoteConfigParameterImpl _$$RemoteConfigParameterImplFromJson(Map<String, dynamic> json) => _$RemoteConfigParameterImpl(
      isPaywallFirst: json['isPaywallFirst'] as bool? ?? RemoteConfigParameterDefaultValues.isPaywallFirst,
      skipInitialSetting: json['skipInitialSetting'] as bool? ?? RemoteConfigParameterDefaultValues.skipInitialSetting,
      trialDeadlineDateOffsetDay:
          (json['trialDeadlineDateOffsetDay'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
      discountEntitlementOffsetDay:
          (json['discountEntitlementOffsetDay'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
      discountCountdownBoundaryHour:
          (json['discountCountdownBoundaryHour'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
      premiumIntroductionPattern: json['premiumIntroductionPattern'] as String? ?? RemoteConfigParameterDefaultValues.premiumIntroductionPattern,
      premiumIntroductionShowsAppStoreReviewCard: json['premiumIntroductionShowsAppStoreReviewCard'] as bool? ??
          RemoteConfigParameterDefaultValues.premiumIntroductionShowsAppStoreReviewCard,
      specialOfferingUserCreationDateTimeOffset: (json['specialOfferingUserCreationDateTimeOffset'] as num?)?.toInt() ??
          RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffset,
      specialOfferingUserCreationDateTimeOffsetSince: (json['specialOfferingUserCreationDateTimeOffsetSince'] as num?)?.toInt() ??
          RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetSince,
      specialOfferingUserCreationDateTimeOffsetUntil: (json['specialOfferingUserCreationDateTimeOffsetUntil'] as num?)?.toInt() ??
          RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetUntil,
      specialOffering2UseAlternativeText:
          json['specialOffering2UseAlternativeText'] as bool? ?? RemoteConfigParameterDefaultValues.specialOffering2UseAlternativeText,
      lifetimeOfferEnabled: json['lifetimeOfferEnabled'] as bool? ?? RemoteConfigParameterDefaultValues.lifetimeOfferEnabled,
      lifetimeOfferUserCreationDaysSince:
          (json['lifetimeOfferUserCreationDaysSince'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.lifetimeOfferUserCreationDaysSince,
      lifetimeOfferUserCreationDaysUntil:
          (json['lifetimeOfferUserCreationDaysUntil'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.lifetimeOfferUserCreationDaysUntil,
      lifetimeOfferDurationHours:
          (json['lifetimeOfferDurationHours'] as num?)?.toInt() ?? RemoteConfigParameterDefaultValues.lifetimeOfferDurationHours,
      lifetimeOfferCopyVariant: json['lifetimeOfferCopyVariant'] as String? ?? RemoteConfigParameterDefaultValues.lifetimeOfferCopyVariant,
    );

Map<String, dynamic> _$$RemoteConfigParameterImplToJson(_$RemoteConfigParameterImpl instance) => <String, dynamic>{
      'isPaywallFirst': instance.isPaywallFirst,
      'skipInitialSetting': instance.skipInitialSetting,
      'trialDeadlineDateOffsetDay': instance.trialDeadlineDateOffsetDay,
      'discountEntitlementOffsetDay': instance.discountEntitlementOffsetDay,
      'discountCountdownBoundaryHour': instance.discountCountdownBoundaryHour,
      'premiumIntroductionPattern': instance.premiumIntroductionPattern,
      'premiumIntroductionShowsAppStoreReviewCard': instance.premiumIntroductionShowsAppStoreReviewCard,
      'specialOfferingUserCreationDateTimeOffset': instance.specialOfferingUserCreationDateTimeOffset,
      'specialOfferingUserCreationDateTimeOffsetSince': instance.specialOfferingUserCreationDateTimeOffsetSince,
      'specialOfferingUserCreationDateTimeOffsetUntil': instance.specialOfferingUserCreationDateTimeOffsetUntil,
      'specialOffering2UseAlternativeText': instance.specialOffering2UseAlternativeText,
      'lifetimeOfferEnabled': instance.lifetimeOfferEnabled,
      'lifetimeOfferUserCreationDaysSince': instance.lifetimeOfferUserCreationDaysSince,
      'lifetimeOfferUserCreationDaysUntil': instance.lifetimeOfferUserCreationDaysUntil,
      'lifetimeOfferDurationHours': instance.lifetimeOfferDurationHours,
      'lifetimeOfferCopyVariant': instance.lifetimeOfferCopyVariant,
    };
