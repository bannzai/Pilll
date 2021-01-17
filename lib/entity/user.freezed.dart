// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
UserPrivate _$UserPrivateFromJson(Map<String, dynamic> json) {
  return _UserPrivate.fromJson(json);
}

/// @nodoc
class _$UserPrivateTearOff {
  const _$UserPrivateTearOff();

// ignore: unused_element
  _UserPrivate call({String fcmToken}) {
    return _UserPrivate(
      fcmToken: fcmToken,
    );
  }

// ignore: unused_element
  UserPrivate fromJson(Map<String, Object> json) {
    return UserPrivate.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $UserPrivate = _$UserPrivateTearOff();

/// @nodoc
mixin _$UserPrivate {
  String get fcmToken;

  Map<String, dynamic> toJson();
  $UserPrivateCopyWith<UserPrivate> get copyWith;
}

/// @nodoc
abstract class $UserPrivateCopyWith<$Res> {
  factory $UserPrivateCopyWith(
          UserPrivate value, $Res Function(UserPrivate) then) =
      _$UserPrivateCopyWithImpl<$Res>;
  $Res call({String fcmToken});
}

/// @nodoc
class _$UserPrivateCopyWithImpl<$Res> implements $UserPrivateCopyWith<$Res> {
  _$UserPrivateCopyWithImpl(this._value, this._then);

  final UserPrivate _value;
  // ignore: unused_field
  final $Res Function(UserPrivate) _then;

  @override
  $Res call({
    Object fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      fcmToken: fcmToken == freezed ? _value.fcmToken : fcmToken as String,
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
  $Res call({String fcmToken});
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
    Object fcmToken = freezed,
  }) {
    return _then(_UserPrivate(
      fcmToken: fcmToken == freezed ? _value.fcmToken : fcmToken as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_UserPrivate extends _UserPrivate {
  _$_UserPrivate({this.fcmToken}) : super._();

  factory _$_UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$_$_UserPrivateFromJson(json);

  @override
  final String fcmToken;

  @override
  String toString() {
    return 'UserPrivate(fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserPrivate &&
            (identical(other.fcmToken, fcmToken) ||
                const DeepCollectionEquality()
                    .equals(other.fcmToken, fcmToken)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(fcmToken);

  @override
  _$UserPrivateCopyWith<_UserPrivate> get copyWith =>
      __$UserPrivateCopyWithImpl<_UserPrivate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserPrivateToJson(this);
  }
}

abstract class _UserPrivate extends UserPrivate {
  _UserPrivate._() : super._();
  factory _UserPrivate({String fcmToken}) = _$_UserPrivate;

  factory _UserPrivate.fromJson(Map<String, dynamic> json) =
      _$_UserPrivate.fromJson;

  @override
  String get fcmToken;
  @override
  _$UserPrivateCopyWith<_UserPrivate> get copyWith;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

// ignore: unused_element
  _User call(
      {@required String anonymouseUserID,
      @JsonKey(name: "settings") Setting setting,
      PillSheetModel latestPillSheet,
      bool migratedFlutter = false,
      bool isSubscribed = false,
      dynamic j}) {
    return _User(
      anonymouseUserID: anonymouseUserID,
      setting: setting,
      latestPillSheet: latestPillSheet,
      migratedFlutter: migratedFlutter,
      isSubscribed: isSubscribed,
      j: j,
    );
  }

// ignore: unused_element
  User fromJson(Map<String, Object> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get anonymouseUserID;
  @JsonKey(name: "settings")
  Setting get setting;
  PillSheetModel get latestPillSheet;
  bool get migratedFlutter;
  bool get isSubscribed;
  dynamic get j;

  Map<String, dynamic> toJson();
  $UserCopyWith<User> get copyWith;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String anonymouseUserID,
      @JsonKey(name: "settings") Setting setting,
      PillSheetModel latestPillSheet,
      bool migratedFlutter,
      bool isSubscribed,
      dynamic j});

  $SettingCopyWith<$Res> get setting;
  $PillSheetModelCopyWith<$Res> get latestPillSheet;
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object anonymouseUserID = freezed,
    Object setting = freezed,
    Object latestPillSheet = freezed,
    Object migratedFlutter = freezed,
    Object isSubscribed = freezed,
    Object j = freezed,
  }) {
    return _then(_value.copyWith(
      anonymouseUserID: anonymouseUserID == freezed
          ? _value.anonymouseUserID
          : anonymouseUserID as String,
      setting: setting == freezed ? _value.setting : setting as Setting,
      latestPillSheet: latestPillSheet == freezed
          ? _value.latestPillSheet
          : latestPillSheet as PillSheetModel,
      migratedFlutter: migratedFlutter == freezed
          ? _value.migratedFlutter
          : migratedFlutter as bool,
      isSubscribed:
          isSubscribed == freezed ? _value.isSubscribed : isSubscribed as bool,
      j: j == freezed ? _value.j : j as dynamic,
    ));
  }

  @override
  $SettingCopyWith<$Res> get setting {
    if (_value.setting == null) {
      return null;
    }
    return $SettingCopyWith<$Res>(_value.setting, (value) {
      return _then(_value.copyWith(setting: value));
    });
  }

  @override
  $PillSheetModelCopyWith<$Res> get latestPillSheet {
    if (_value.latestPillSheet == null) {
      return null;
    }
    return $PillSheetModelCopyWith<$Res>(_value.latestPillSheet, (value) {
      return _then(_value.copyWith(latestPillSheet: value));
    });
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String anonymouseUserID,
      @JsonKey(name: "settings") Setting setting,
      PillSheetModel latestPillSheet,
      bool migratedFlutter,
      bool isSubscribed,
      dynamic j});

  @override
  $SettingCopyWith<$Res> get setting;
  @override
  $PillSheetModelCopyWith<$Res> get latestPillSheet;
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
    Object anonymouseUserID = freezed,
    Object setting = freezed,
    Object latestPillSheet = freezed,
    Object migratedFlutter = freezed,
    Object isSubscribed = freezed,
    Object j = freezed,
  }) {
    return _then(_User(
      anonymouseUserID: anonymouseUserID == freezed
          ? _value.anonymouseUserID
          : anonymouseUserID as String,
      setting: setting == freezed ? _value.setting : setting as Setting,
      latestPillSheet: latestPillSheet == freezed
          ? _value.latestPillSheet
          : latestPillSheet as PillSheetModel,
      migratedFlutter: migratedFlutter == freezed
          ? _value.migratedFlutter
          : migratedFlutter as bool,
      isSubscribed:
          isSubscribed == freezed ? _value.isSubscribed : isSubscribed as bool,
      j: j == freezed ? _value.j : j,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_User extends _User {
  _$_User(
      {@required this.anonymouseUserID,
      @JsonKey(name: "settings") this.setting,
      this.latestPillSheet,
      this.migratedFlutter = false,
      this.isSubscribed = false,
      this.j})
      : assert(anonymouseUserID != null),
        assert(migratedFlutter != null),
        assert(isSubscribed != null),
        super._();

  factory _$_User.fromJson(Map<String, dynamic> json) =>
      _$_$_UserFromJson(json);

  @override
  final String anonymouseUserID;
  @override
  @JsonKey(name: "settings")
  final Setting setting;
  @override
  final PillSheetModel latestPillSheet;
  @JsonKey(defaultValue: false)
  @override
  final bool migratedFlutter;
  @JsonKey(defaultValue: false)
  @override
  final bool isSubscribed;
  @override
  final dynamic j;

  @override
  String toString() {
    return 'User(anonymouseUserID: $anonymouseUserID, setting: $setting, latestPillSheet: $latestPillSheet, migratedFlutter: $migratedFlutter, isSubscribed: $isSubscribed, j: $j)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.anonymouseUserID, anonymouseUserID) ||
                const DeepCollectionEquality()
                    .equals(other.anonymouseUserID, anonymouseUserID)) &&
            (identical(other.setting, setting) ||
                const DeepCollectionEquality()
                    .equals(other.setting, setting)) &&
            (identical(other.latestPillSheet, latestPillSheet) ||
                const DeepCollectionEquality()
                    .equals(other.latestPillSheet, latestPillSheet)) &&
            (identical(other.migratedFlutter, migratedFlutter) ||
                const DeepCollectionEquality()
                    .equals(other.migratedFlutter, migratedFlutter)) &&
            (identical(other.isSubscribed, isSubscribed) ||
                const DeepCollectionEquality()
                    .equals(other.isSubscribed, isSubscribed)) &&
            (identical(other.j, j) ||
                const DeepCollectionEquality().equals(other.j, j)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(anonymouseUserID) ^
      const DeepCollectionEquality().hash(setting) ^
      const DeepCollectionEquality().hash(latestPillSheet) ^
      const DeepCollectionEquality().hash(migratedFlutter) ^
      const DeepCollectionEquality().hash(isSubscribed) ^
      const DeepCollectionEquality().hash(j);

  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserToJson(this);
  }
}

abstract class _User extends User {
  _User._() : super._();
  factory _User(
      {@required String anonymouseUserID,
      @JsonKey(name: "settings") Setting setting,
      PillSheetModel latestPillSheet,
      bool migratedFlutter,
      bool isSubscribed,
      dynamic j}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get anonymouseUserID;
  @override
  @JsonKey(name: "settings")
  Setting get setting;
  @override
  PillSheetModel get latestPillSheet;
  @override
  bool get migratedFlutter;
  @override
  bool get isSubscribed;
  @override
  dynamic get j;
  @override
  _$UserCopyWith<_User> get copyWith;
}
