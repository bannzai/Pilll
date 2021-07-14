// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserPrivate _$_$_UserPrivateFromJson(Map<String, dynamic> json) {
  return _$_UserPrivate(
    fcmToken: json['fcmToken'] as String?,
  );
}

Map<String, dynamic> _$_$_UserPrivateToJson(_$_UserPrivate instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
    };

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    setting: json['settings'] == null
        ? null
        : Setting.fromJson(json['settings'] as Map<String, dynamic>),
    migratedFlutter: json['migratedFlutter'] as bool? ?? false,
    userIDWhenCreateUser: json['userIDWhenCreateUser'] as String?,
    anonymousUserID: json['anonymousUserID'] as String?,
    userDocumentIDSets: (json['userDocumentIDSets'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    anonymousUserIDSets: (json['anonymousUserIDSets'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [],
    firebaseCurrentUserIDSets:
        (json['firebaseCurrentUserIDSets'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
    isPremium: json['isPremium'] as bool? ?? false,
    isTrial: json['isTrial'] as bool? ?? false,
    hasDiscountEntitlement: json['hasDiscountEntitlement'] as bool? ?? true,
    beginTrialDate: TimestampConverter.timestampToDateTime(
        json['beginTrialDate'] as Timestamp?),
    trialDeadlineDate: TimestampConverter.timestampToDateTime(
        json['trialDeadlineDate'] as Timestamp?),
    discountEntitlementDeadlineDate: TimestampConverter.timestampToDateTime(
        json['discountEntitlementDeadlineDate'] as Timestamp?),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'settings': instance.setting?.toJson(),
      'migratedFlutter': instance.migratedFlutter,
      'userIDWhenCreateUser': instance.userIDWhenCreateUser,
      'anonymousUserID': instance.anonymousUserID,
      'userDocumentIDSets': instance.userDocumentIDSets,
      'anonymousUserIDSets': instance.anonymousUserIDSets,
      'firebaseCurrentUserIDSets': instance.firebaseCurrentUserIDSets,
      'isPremium': instance.isPremium,
      'isTrial': instance.isTrial,
      'hasDiscountEntitlement': instance.hasDiscountEntitlement,
      'beginTrialDate':
          TimestampConverter.dateTimeToTimestamp(instance.beginTrialDate),
      'trialDeadlineDate':
          TimestampConverter.dateTimeToTimestamp(instance.trialDeadlineDate),
      'discountEntitlementDeadlineDate': TimestampConverter.dateTimeToTimestamp(
          instance.discountEntitlementDeadlineDate),
    };
