// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserPrivate _$UserPrivateFromJson(Map<String, dynamic> json) {
  return _UserPrivate.fromJson(json);
}

/// @nodoc
class _$UserPrivateTearOff {
  const _$UserPrivateTearOff();

  _UserPrivate call({String? fcmToken}) {
    return _UserPrivate(
      fcmToken: fcmToken,
    );
  }

  UserPrivate fromJson(Map<String, Object?> json) {
    return UserPrivate.fromJson(json);
  }
}

/// @nodoc
const $UserPrivate = _$UserPrivateTearOff();

/// @nodoc
mixin _$UserPrivate {
  String? get fcmToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPrivateCopyWith<UserPrivate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPrivateCopyWith<$Res> {
  factory $UserPrivateCopyWith(
          UserPrivate value, $Res Function(UserPrivate) then) =
      _$UserPrivateCopyWithImpl<$Res>;
  $Res call({String? fcmToken});
}

/// @nodoc
class _$UserPrivateCopyWithImpl<$Res> implements $UserPrivateCopyWith<$Res> {
  _$UserPrivateCopyWithImpl(this._value, this._then);

  final UserPrivate _value;
  // ignore: unused_field
  final $Res Function(UserPrivate) _then;

  @override
  $Res call({
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$UserPrivateCopyWith<$Res>
    implements $UserPrivateCopyWith<$Res> {
  factory _$UserPrivateCopyWith(
          _UserPrivate value, $Res Function(_UserPrivate) then) =
      __$UserPrivateCopyWithImpl<$Res>;
  @override
  $Res call({String? fcmToken});
}

/// @nodoc
class __$UserPrivateCopyWithImpl<$Res> extends _$UserPrivateCopyWithImpl<$Res>
    implements _$UserPrivateCopyWith<$Res> {
  __$UserPrivateCopyWithImpl(
      _UserPrivate _value, $Res Function(_UserPrivate) _then)
      : super(_value, (v) => _then(v as _UserPrivate));

  @override
  _UserPrivate get _value => super._value as _UserPrivate;

  @override
  $Res call({
    Object? fcmToken = freezed,
  }) {
    return _then(_UserPrivate(
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserPrivate extends _UserPrivate {
  const _$_UserPrivate({this.fcmToken}) : super._();

  factory _$_UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$$_UserPrivateFromJson(json);

  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'UserPrivate(fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserPrivate &&
            const DeepCollectionEquality().equals(other.fcmToken, fcmToken));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(fcmToken));

  @JsonKey(ignore: true)
  @override
  _$UserPrivateCopyWith<_UserPrivate> get copyWith =>
      __$UserPrivateCopyWithImpl<_UserPrivate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserPrivateToJson(this);
  }
}

abstract class _UserPrivate extends UserPrivate {
  const factory _UserPrivate({String? fcmToken}) = _$_UserPrivate;
  const _UserPrivate._() : super._();

  factory _UserPrivate.fromJson(Map<String, dynamic> json) =
      _$_UserPrivate.fromJson;

  @override
  String? get fcmToken;
  @override
  @JsonKey(ignore: true)
  _$UserPrivateCopyWith<_UserPrivate> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {String? id,
      @JsonKey(name: "settings")
          Setting? setting,
      bool migratedFlutter = false,
      String? userIDWhenCreateUser,
      String? anonymousUserID,
      List<String> userDocumentIDSets = const [],
      List<String> anonymousUserIDSets = const [],
      List<String> firebaseCurrentUserIDSets = const [],
      bool isPremium = false,
      bool isTrial = false,
      bool hasDiscountEntitlement = false,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? discountEntitlementDeadlineDate}) {
    return _User(
      id: id,
      setting: setting,
      migratedFlutter: migratedFlutter,
      userIDWhenCreateUser: userIDWhenCreateUser,
      anonymousUserID: anonymousUserID,
      userDocumentIDSets: userDocumentIDSets,
      anonymousUserIDSets: anonymousUserIDSets,
      firebaseCurrentUserIDSets: firebaseCurrentUserIDSets,
      isPremium: isPremium,
      isTrial: isTrial,
      hasDiscountEntitlement: hasDiscountEntitlement,
      beginTrialDate: beginTrialDate,
      trialDeadlineDate: trialDeadlineDate,
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
    );
  }

  User fromJson(Map<String, Object?> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "settings")
  Setting? get setting => throw _privateConstructorUsedError;
  bool get migratedFlutter => throw _privateConstructorUsedError;
  String? get userIDWhenCreateUser => throw _privateConstructorUsedError;
  String? get anonymousUserID => throw _privateConstructorUsedError;
  List<String> get userDocumentIDSets => throw _privateConstructorUsedError;
  List<String> get anonymousUserIDSets => throw _privateConstructorUsedError;
  List<String> get firebaseCurrentUserIDSets =>
      throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  bool get isTrial => throw _privateConstructorUsedError;
  bool get hasDiscountEntitlement => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get discountEntitlementDeadlineDate =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      @JsonKey(name: "settings")
          Setting? setting,
      bool migratedFlutter,
      String? userIDWhenCreateUser,
      String? anonymousUserID,
      List<String> userDocumentIDSets,
      List<String> anonymousUserIDSets,
      List<String> firebaseCurrentUserIDSets,
      bool isPremium,
      bool isTrial,
      bool hasDiscountEntitlement,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? discountEntitlementDeadlineDate});

  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? setting = freezed,
    Object? migratedFlutter = freezed,
    Object? userIDWhenCreateUser = freezed,
    Object? anonymousUserID = freezed,
    Object? userDocumentIDSets = freezed,
    Object? anonymousUserIDSets = freezed,
    Object? firebaseCurrentUserIDSets = freezed,
    Object? isPremium = freezed,
    Object? isTrial = freezed,
    Object? hasDiscountEntitlement = freezed,
    Object? beginTrialDate = freezed,
    Object? trialDeadlineDate = freezed,
    Object? discountEntitlementDeadlineDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      migratedFlutter: migratedFlutter == freezed
          ? _value.migratedFlutter
          : migratedFlutter // ignore: cast_nullable_to_non_nullable
              as bool,
      userIDWhenCreateUser: userIDWhenCreateUser == freezed
          ? _value.userIDWhenCreateUser
          : userIDWhenCreateUser // ignore: cast_nullable_to_non_nullable
              as String?,
      anonymousUserID: anonymousUserID == freezed
          ? _value.anonymousUserID
          : anonymousUserID // ignore: cast_nullable_to_non_nullable
              as String?,
      userDocumentIDSets: userDocumentIDSets == freezed
          ? _value.userDocumentIDSets
          : userDocumentIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      anonymousUserIDSets: anonymousUserIDSets == freezed
          ? _value.anonymousUserIDSets
          : anonymousUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      firebaseCurrentUserIDSets: firebaseCurrentUserIDSets == freezed
          ? _value.firebaseCurrentUserIDSets
          : firebaseCurrentUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDiscountEntitlement: hasDiscountEntitlement == freezed
          ? _value.hasDiscountEntitlement
          : hasDiscountEntitlement // ignore: cast_nullable_to_non_nullable
              as bool,
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trialDeadlineDate: trialDeadlineDate == freezed
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate ==
              freezed
          ? _value.discountEntitlementDeadlineDate
          : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  @override
  $SettingCopyWith<$Res>? get setting {
    if (_value.setting == null) {
      return null;
    }

    return $SettingCopyWith<$Res>(_value.setting!, (value) {
      return _then(_value.copyWith(setting: value));
    });
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      @JsonKey(name: "settings")
          Setting? setting,
      bool migratedFlutter,
      String? userIDWhenCreateUser,
      String? anonymousUserID,
      List<String> userDocumentIDSets,
      List<String> anonymousUserIDSets,
      List<String> firebaseCurrentUserIDSets,
      bool isPremium,
      bool isTrial,
      bool hasDiscountEntitlement,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? discountEntitlementDeadlineDate});

  @override
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? id = freezed,
    Object? setting = freezed,
    Object? migratedFlutter = freezed,
    Object? userIDWhenCreateUser = freezed,
    Object? anonymousUserID = freezed,
    Object? userDocumentIDSets = freezed,
    Object? anonymousUserIDSets = freezed,
    Object? firebaseCurrentUserIDSets = freezed,
    Object? isPremium = freezed,
    Object? isTrial = freezed,
    Object? hasDiscountEntitlement = freezed,
    Object? beginTrialDate = freezed,
    Object? trialDeadlineDate = freezed,
    Object? discountEntitlementDeadlineDate = freezed,
  }) {
    return _then(_User(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      setting: setting == freezed
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      migratedFlutter: migratedFlutter == freezed
          ? _value.migratedFlutter
          : migratedFlutter // ignore: cast_nullable_to_non_nullable
              as bool,
      userIDWhenCreateUser: userIDWhenCreateUser == freezed
          ? _value.userIDWhenCreateUser
          : userIDWhenCreateUser // ignore: cast_nullable_to_non_nullable
              as String?,
      anonymousUserID: anonymousUserID == freezed
          ? _value.anonymousUserID
          : anonymousUserID // ignore: cast_nullable_to_non_nullable
              as String?,
      userDocumentIDSets: userDocumentIDSets == freezed
          ? _value.userDocumentIDSets
          : userDocumentIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      anonymousUserIDSets: anonymousUserIDSets == freezed
          ? _value.anonymousUserIDSets
          : anonymousUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      firebaseCurrentUserIDSets: firebaseCurrentUserIDSets == freezed
          ? _value.firebaseCurrentUserIDSets
          : firebaseCurrentUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPremium: isPremium == freezed
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      isTrial: isTrial == freezed
          ? _value.isTrial
          : isTrial // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDiscountEntitlement: hasDiscountEntitlement == freezed
          ? _value.hasDiscountEntitlement
          : hasDiscountEntitlement // ignore: cast_nullable_to_non_nullable
              as bool,
      beginTrialDate: beginTrialDate == freezed
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trialDeadlineDate: trialDeadlineDate == freezed
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEntitlementDeadlineDate: discountEntitlementDeadlineDate ==
              freezed
          ? _value.discountEntitlementDeadlineDate
          : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_User extends _User {
  const _$_User(
      {this.id,
      @JsonKey(name: "settings")
          this.setting,
      this.migratedFlutter = false,
      this.userIDWhenCreateUser,
      this.anonymousUserID,
      this.userDocumentIDSets = const [],
      this.anonymousUserIDSets = const [],
      this.firebaseCurrentUserIDSets = const [],
      this.isPremium = false,
      this.isTrial = false,
      this.hasDiscountEntitlement = false,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.discountEntitlementDeadlineDate})
      : super._();

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: "settings")
  final Setting? setting;
  @JsonKey()
  @override
  final bool migratedFlutter;
  @override
  final String? userIDWhenCreateUser;
  @override
  final String? anonymousUserID;
  @JsonKey()
  @override
  final List<String> userDocumentIDSets;
  @JsonKey()
  @override
  final List<String> anonymousUserIDSets;
  @JsonKey()
  @override
  final List<String> firebaseCurrentUserIDSets;
  @JsonKey()
  @override
  final bool isPremium;
  @JsonKey()
  @override
  final bool isTrial;
  @JsonKey()
  @override
  final bool hasDiscountEntitlement;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? beginTrialDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? trialDeadlineDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? discountEntitlementDeadlineDate;

  @override
  String toString() {
    return 'User(id: $id, setting: $setting, migratedFlutter: $migratedFlutter, userIDWhenCreateUser: $userIDWhenCreateUser, anonymousUserID: $anonymousUserID, userDocumentIDSets: $userDocumentIDSets, anonymousUserIDSets: $anonymousUserIDSets, firebaseCurrentUserIDSets: $firebaseCurrentUserIDSets, isPremium: $isPremium, isTrial: $isTrial, hasDiscountEntitlement: $hasDiscountEntitlement, beginTrialDate: $beginTrialDate, trialDeadlineDate: $trialDeadlineDate, discountEntitlementDeadlineDate: $discountEntitlementDeadlineDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _User &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.setting, setting) &&
            const DeepCollectionEquality()
                .equals(other.migratedFlutter, migratedFlutter) &&
            const DeepCollectionEquality()
                .equals(other.userIDWhenCreateUser, userIDWhenCreateUser) &&
            const DeepCollectionEquality()
                .equals(other.anonymousUserID, anonymousUserID) &&
            const DeepCollectionEquality()
                .equals(other.userDocumentIDSets, userDocumentIDSets) &&
            const DeepCollectionEquality()
                .equals(other.anonymousUserIDSets, anonymousUserIDSets) &&
            const DeepCollectionEquality().equals(
                other.firebaseCurrentUserIDSets, firebaseCurrentUserIDSets) &&
            const DeepCollectionEquality().equals(other.isPremium, isPremium) &&
            const DeepCollectionEquality().equals(other.isTrial, isTrial) &&
            const DeepCollectionEquality()
                .equals(other.hasDiscountEntitlement, hasDiscountEntitlement) &&
            const DeepCollectionEquality()
                .equals(other.beginTrialDate, beginTrialDate) &&
            const DeepCollectionEquality()
                .equals(other.trialDeadlineDate, trialDeadlineDate) &&
            const DeepCollectionEquality().equals(
                other.discountEntitlementDeadlineDate,
                discountEntitlementDeadlineDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(setting),
      const DeepCollectionEquality().hash(migratedFlutter),
      const DeepCollectionEquality().hash(userIDWhenCreateUser),
      const DeepCollectionEquality().hash(anonymousUserID),
      const DeepCollectionEquality().hash(userDocumentIDSets),
      const DeepCollectionEquality().hash(anonymousUserIDSets),
      const DeepCollectionEquality().hash(firebaseCurrentUserIDSets),
      const DeepCollectionEquality().hash(isPremium),
      const DeepCollectionEquality().hash(isTrial),
      const DeepCollectionEquality().hash(hasDiscountEntitlement),
      const DeepCollectionEquality().hash(beginTrialDate),
      const DeepCollectionEquality().hash(trialDeadlineDate),
      const DeepCollectionEquality().hash(discountEntitlementDeadlineDate));

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(this);
  }
}

abstract class _User extends User {
  const factory _User(
      {String? id,
      @JsonKey(name: "settings")
          Setting? setting,
      bool migratedFlutter,
      String? userIDWhenCreateUser,
      String? anonymousUserID,
      List<String> userDocumentIDSets,
      List<String> anonymousUserIDSets,
      List<String> firebaseCurrentUserIDSets,
      bool isPremium,
      bool isTrial,
      bool hasDiscountEntitlement,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime? discountEntitlementDeadlineDate}) = _$_User;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: "settings")
  Setting? get setting;
  @override
  bool get migratedFlutter;
  @override
  String? get userIDWhenCreateUser;
  @override
  String? get anonymousUserID;
  @override
  List<String> get userDocumentIDSets;
  @override
  List<String> get anonymousUserIDSets;
  @override
  List<String> get firebaseCurrentUserIDSets;
  @override
  bool get isPremium;
  @override
  bool get isTrial;
  @override
  bool get hasDiscountEntitlement;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get beginTrialDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get trialDeadlineDate;
  @override
  @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get discountEntitlementDeadlineDate;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}
