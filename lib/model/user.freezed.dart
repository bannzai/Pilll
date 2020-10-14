// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

// ignore: unused_element
  _User call({@required String anonymousUserID}) {
    return _User(
      anonymousUserID: anonymousUserID,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get anonymousUserID;

  $UserCopyWith<User> get copyWith;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call({String anonymousUserID});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object anonymousUserID = freezed,
  }) {
    return _then(_value.copyWith(
      anonymousUserID: anonymousUserID == freezed
          ? _value.anonymousUserID
          : anonymousUserID as String,
    ));
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call({String anonymousUserID});
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
    Object anonymousUserID = freezed,
  }) {
    return _then(_User(
      anonymousUserID: anonymousUserID == freezed
          ? _value.anonymousUserID
          : anonymousUserID as String,
    ));
  }
}

/// @nodoc
class _$_User implements _User {
  _$_User({@required this.anonymousUserID}) : assert(anonymousUserID != null);

  @override
  final String anonymousUserID;

  @override
  String toString() {
    return 'User(anonymousUserID: $anonymousUserID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.anonymousUserID, anonymousUserID) ||
                const DeepCollectionEquality()
                    .equals(other.anonymousUserID, anonymousUserID)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(anonymousUserID);

  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);
}

abstract class _User implements User {
  factory _User({@required String anonymousUserID}) = _$_User;

  @override
  String get anonymousUserID;
  @override
  _$UserCopyWith<_User> get copyWith;
}
