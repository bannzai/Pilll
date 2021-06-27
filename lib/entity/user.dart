import 'package:pilll/entity/setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.g.dart';
part 'user.freezed.dart';

class UserNotFound implements Exception {
  toString() {
    return "user not found";
  }
}

class UserAlreadyExists implements Exception {
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
  static final demographic = "demographic";
  static final latestPremiumPlanIdentifier = "latestPremiumPlanIdentifier";
  static final originalPurchaseDate = "originalPurchaseDate";
  static final activeSubscriptions = "activeSubscriptions";
  static final entitlementIdentifier = "entitlementIdentifier";
}

@freezed
abstract class UserPrivate implements _$UserPrivate {
  UserPrivate._();
  factory UserPrivate({String? fcmToken}) = _UserPrivate;
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
}

@freezed
abstract class User implements _$User {
  User._();
  @JsonSerializable(explicitToJson: true)
  factory User({
    @JsonKey(name: "settings") Setting? setting,
    @Default(false) bool migratedFlutter,
    String? userIDWhenCreateUser,
    String? anonymousUserID,
    @Default([]) List<String> userDocumentIDSets,
    @Default([]) List<String> anonymousUserIDSets,
    @Default([]) List<String> firebaseCurrentUserIDSets,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? beginTrialDate,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
