// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'local_notification_schedule_id.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LocalNotificationScheduleID _$LocalNotificationScheduleIDFromJson(
    Map<String, dynamic> json) {
  return _LocalNotificationScheduleID.fromJson(json);
}

/// @nodoc
class _$LocalNotificationScheduleIDTearOff {
  const _$LocalNotificationScheduleIDTearOff();

  _LocalNotificationScheduleID call(
      {required int key, required int localNotificaationID}) {
    return _LocalNotificationScheduleID(
      key: key,
      localNotificaationID: localNotificaationID,
    );
  }

  LocalNotificationScheduleID fromJson(Map<String, Object?> json) {
    return LocalNotificationScheduleID.fromJson(json);
  }
}

/// @nodoc
const $LocalNotificationScheduleID = _$LocalNotificationScheduleIDTearOff();

/// @nodoc
mixin _$LocalNotificationScheduleID {
  int get key => throw _privateConstructorUsedError;
  int get localNotificaationID => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationScheduleIDCopyWith<LocalNotificationScheduleID>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationScheduleIDCopyWith<$Res> {
  factory $LocalNotificationScheduleIDCopyWith(
          LocalNotificationScheduleID value,
          $Res Function(LocalNotificationScheduleID) then) =
      _$LocalNotificationScheduleIDCopyWithImpl<$Res>;
  $Res call({int key, int localNotificaationID});
}

/// @nodoc
class _$LocalNotificationScheduleIDCopyWithImpl<$Res>
    implements $LocalNotificationScheduleIDCopyWith<$Res> {
  _$LocalNotificationScheduleIDCopyWithImpl(this._value, this._then);

  final LocalNotificationScheduleID _value;
  // ignore: unused_field
  final $Res Function(LocalNotificationScheduleID) _then;

  @override
  $Res call({
    Object? key = freezed,
    Object? localNotificaationID = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as int,
      localNotificaationID: localNotificaationID == freezed
          ? _value.localNotificaationID
          : localNotificaationID // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$LocalNotificationScheduleIDCopyWith<$Res>
    implements $LocalNotificationScheduleIDCopyWith<$Res> {
  factory _$LocalNotificationScheduleIDCopyWith(
          _LocalNotificationScheduleID value,
          $Res Function(_LocalNotificationScheduleID) then) =
      __$LocalNotificationScheduleIDCopyWithImpl<$Res>;
  @override
  $Res call({int key, int localNotificaationID});
}

/// @nodoc
class __$LocalNotificationScheduleIDCopyWithImpl<$Res>
    extends _$LocalNotificationScheduleIDCopyWithImpl<$Res>
    implements _$LocalNotificationScheduleIDCopyWith<$Res> {
  __$LocalNotificationScheduleIDCopyWithImpl(
      _LocalNotificationScheduleID _value,
      $Res Function(_LocalNotificationScheduleID) _then)
      : super(_value, (v) => _then(v as _LocalNotificationScheduleID));

  @override
  _LocalNotificationScheduleID get _value =>
      super._value as _LocalNotificationScheduleID;

  @override
  $Res call({
    Object? key = freezed,
    Object? localNotificaationID = freezed,
  }) {
    return _then(_LocalNotificationScheduleID(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as int,
      localNotificaationID: localNotificaationID == freezed
          ? _value.localNotificaationID
          : localNotificaationID // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationScheduleID extends _LocalNotificationScheduleID {
  _$_LocalNotificationScheduleID(
      {required this.key, required this.localNotificaationID})
      : super._();

  factory _$_LocalNotificationScheduleID.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleIDFromJson(json);

  @override
  final int key;
  @override
  final int localNotificaationID;

  @override
  String toString() {
    return 'LocalNotificationScheduleID(key: $key, localNotificaationID: $localNotificaationID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationScheduleID &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality()
                .equals(other.localNotificaationID, localNotificaationID));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(localNotificaationID));

  @JsonKey(ignore: true)
  @override
  _$LocalNotificationScheduleIDCopyWith<_LocalNotificationScheduleID>
      get copyWith => __$LocalNotificationScheduleIDCopyWithImpl<
          _LocalNotificationScheduleID>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocalNotificationScheduleIDToJson(this);
  }
}

abstract class _LocalNotificationScheduleID
    extends LocalNotificationScheduleID {
  factory _LocalNotificationScheduleID(
      {required int key,
      required int localNotificaationID}) = _$_LocalNotificationScheduleID;
  _LocalNotificationScheduleID._() : super._();

  factory _LocalNotificationScheduleID.fromJson(Map<String, dynamic> json) =
      _$_LocalNotificationScheduleID.fromJson;

  @override
  int get key;
  @override
  int get localNotificaationID;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleIDCopyWith<_LocalNotificationScheduleID>
      get copyWith => throw _privateConstructorUsedError;
}
