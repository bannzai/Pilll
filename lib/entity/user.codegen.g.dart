// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPrivateImpl _$$UserPrivateImplFromJson(Map<String, dynamic> json) =>
    _$UserPrivateImpl(
      fcmToken: json['fcmToken'] as String?,
    );

Map<String, dynamic> _$$UserPrivateImplToJson(_$UserPrivateImpl instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String?,
      setting: json['settings'] == null
          ? null
          : Setting.fromJson(json['settings'] as Map<String, dynamic>),
      userIDWhenCreateUser: json['userIDWhenCreateUser'] as String?,
      anonymousUserID: json['anonymousUserID'] as String?,
      userDocumentIDSets: (json['userDocumentIDSets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      anonymousUserIDSets: (json['anonymousUserIDSets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      firebaseCurrentUserIDSets:
          (json['firebaseCurrentUserIDSets'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      isPremium: json['isPremium'] as bool? ?? false,
      shouldAskCancelReason: json['shouldAskCancelReason'] as bool? ?? false,
      useLocalNotificationForReminder:
          json['useLocalNotificationForReminder'] as bool? ?? true,
      analyticsDebugIsEnabled:
          json['analyticsDebugIsEnabled'] as bool? ?? false,
      beginTrialDate: TimestampConverter.timestampToDateTime(
          json['beginTrialDate'] as Timestamp?),
      trialDeadlineDate: TimestampConverter.timestampToDateTime(
          json['trialDeadlineDate'] as Timestamp?),
      discountEntitlementDeadlineDate: TimestampConverter.timestampToDateTime(
          json['discountEntitlementDeadlineDate'] as Timestamp?),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'settings': instance.setting?.toJson(),
      'userIDWhenCreateUser': instance.userIDWhenCreateUser,
      'anonymousUserID': instance.anonymousUserID,
      'userDocumentIDSets': instance.userDocumentIDSets,
      'anonymousUserIDSets': instance.anonymousUserIDSets,
      'firebaseCurrentUserIDSets': instance.firebaseCurrentUserIDSets,
      'isPremium': instance.isPremium,
      'shouldAskCancelReason': instance.shouldAskCancelReason,
      'useLocalNotificationForReminder':
          instance.useLocalNotificationForReminder,
      'analyticsDebugIsEnabled': instance.analyticsDebugIsEnabled,
      'beginTrialDate':
          TimestampConverter.dateTimeToTimestamp(instance.beginTrialDate),
      'trialDeadlineDate':
          TimestampConverter.dateTimeToTimestamp(instance.trialDeadlineDate),
      'discountEntitlementDeadlineDate': TimestampConverter.dateTimeToTimestamp(
          instance.discountEntitlementDeadlineDate),
    };
