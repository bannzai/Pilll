import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.codegen.g.dart';
part 'user.codegen.freezed.dart';

class UserNotFound implements Exception {
  @override
  String toString() {
    return "user not found";
  }
}

class UserAlreadyExists implements Exception {
  @override
  String toString() {
    return "user already exists";
  }
}

extension UserPrivateFirestoreFieldKeys on String {
  static const fcmToken = 'fcmToken';
  static const appleEmail = 'appleEmail';
  static const isLinkedApple = 'isLinkedApple';
  static const googleEmail = 'googleEmail';
  static const isLinkedGoogle = 'isLinkedGoogle';
  static const latestPremiumPlanIdentifier = "latestPremiumPlanIdentifier";
  static const originalPurchaseDate = "originalPurchaseDate";
  static const activeSubscriptions = "activeSubscriptions";
  static const entitlementIdentifier = "entitlementIdentifier";
  static const premiumFunctionSurvey = "premiumFunctionSurvey";
}

@freezed
class UserPrivate with _$UserPrivate {
  const UserPrivate._();
  const factory UserPrivate({String? fcmToken}) = _UserPrivate;
  factory UserPrivate.create({required String fcmToken}) => UserPrivate(fcmToken: fcmToken);

  factory UserPrivate.fromJson(Map<String, dynamic> json) => _$UserPrivateFromJson(json);
}

extension UserFirestoreFieldKeys on String {
  static const userDocumentIDSets = "userDocumentIDSets";
  static const anonymousUserIDSets = "anonymousUserIDSets";
  static const firebaseCurrentUserIDSets = "firebaseCurrentUserIDSets";
  static const userIDWhenCreateUser = "userIDWhenCreateUser";
  static const anonymousUserID = "anonymousUserID";
  static const settings = "settings";
  static const migratedFlutter = "migratedFlutter";
  static const packageInfo = "packageInfo";
  static const isAnonymous = "isAnonymous";
  static const isPremium = "isPremium";
  static const purchaseAppID = "purchaseAppID";
  static const isTrial = "isTrial";
  static const beginTrialDate = "beginTrialDate";
  static const trialDeadlineDate = "trialDeadlineDate";
  static const hasDiscountEntitlement = "hasDiscountEntitlement";
  static const discountEntitlementDeadlineDate = "discountEntitlementDeadlineDate";
  static const shouldAskCancelReason = "shouldAskCancelReason";
}

@freezed
class User with _$User {
  const User._();
  @JsonSerializable(explicitToJson: true)
  const factory User({
    String? id,
    @JsonKey(name: "settings") Setting? setting,
    @Default(false) bool migratedFlutter,
    String? userIDWhenCreateUser,
    String? anonymousUserID,
    @Default([]) List<String> userDocumentIDSets,
    @Default([]) List<String> anonymousUserIDSets,
    @Default([]) List<String> firebaseCurrentUserIDSets,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    @Default(false) bool hasDiscountEntitlement,
    @Default(false) bool shouldAskCancelReason,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? beginTrialDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? trialDeadlineDate,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? discountEntitlementDeadlineDate,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
