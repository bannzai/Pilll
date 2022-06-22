import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.codegen.g.dart';
part 'user.codegen.freezed.dart';

class UserNotFound with Exception {
  toString() {
    return "user not found";
  }
}

class UserAlreadyExists with Exception {
  toString() {
    return "user already exists";
  }
}

extension UserPrivateFirestoreFieldKeys on String {
  static final fcmToken = 'fcmToken';
  static final appleEmail = 'appleEmail';
  static final isLinkedApple = 'isLinkedApple';
  static final googleEmail = 'googleEmail';
  static final isLinkedGoogle = 'isLinkedGoogle';
  static final latestPremiumPlanIdentifier = "latestPremiumPlanIdentifier";
  static final originalPurchaseDate = "originalPurchaseDate";
  static final activeSubscriptions = "activeSubscriptions";
  static final entitlementIdentifier = "entitlementIdentifier";
  static final premiumFunctionSurvey = "premiumFunctionSurvey";
}

@freezed
class UserPrivate with _$UserPrivate {
  const UserPrivate._();
  const factory UserPrivate({String? fcmToken}) = _UserPrivate;
  factory UserPrivate.create({required String fcmToken}) =>
      UserPrivate(fcmToken: fcmToken);

  factory UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$UserPrivateFromJson(json);
}

extension UserFirestoreFieldKeys on String {
  static final userDocumentIDSets = "userDocumentIDSets";
  static final anonymousUserIDSets = "anonymousUserIDSets";
  static final firebaseCurrentUserIDSets = "firebaseCurrentUserIDSets";
  static final userIDWhenCreateUser = "userIDWhenCreateUser";
  static final anonymousUserID = "anonymousUserID";
  static final settings = "settings";
  static final migratedFlutter = "migratedFlutter";
  static final packageInfo = "packageInfo";
  static final isAnonymous = "isAnonymous";
  static final isPremium = "isPremium";
  static final purchaseAppID = "purchaseAppID";
  static final isTrial = "isTrial";
  static final beginTrialDate = "beginTrialDate";
  static final trialDeadlineDate = "trialDeadlineDate";
  static final hasDiscountEntitlement = "hasDiscountEntitlement";
  static final discountEntitlementDeadlineDate =
      "discountEntitlementDeadlineDate";
}

@freezed
class User with _$User {
  const User._();
  @JsonSerializable(explicitToJson: true)
  const factory User({
    String? id,
    @JsonKey(name: "settings")
        Setting? setting,
    @Default(false)
        bool migratedFlutter,
    String? userIDWhenCreateUser,
    String? anonymousUserID,
    @Default([])
        List<String> userDocumentIDSets,
    @Default([])
        List<String> anonymousUserIDSets,
    @Default([])
        List<String> firebaseCurrentUserIDSets,
    @Default(false)
        bool isPremium,
    @Default(false)
        bool isTrial,
    @Default(false)
        bool hasDiscountEntitlement,
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
    bool useTimeZoneOffset,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
