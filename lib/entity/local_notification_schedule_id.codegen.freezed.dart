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
      {required String key,
      required int localNotificationID,
      required DateTime scheduleDateTime}) {
    return _LocalNotificationScheduleID(
      key: key,
      localNotificationID: localNotificationID,
      scheduleDateTime: scheduleDateTime,
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
  String get key => throw _privateConstructorUsedError;
  int get localNotificationID => throw _privateConstructorUsedError;
  DateTime get scheduleDateTime => throw _privateConstructorUsedError;

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
  $Res call({String key, int localNotificationID, DateTime scheduleDateTime});
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
    Object? localNotificationID = freezed,
    Object? scheduleDateTime = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      localNotificationID: localNotificationID == freezed
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
  $Res call({String key, int localNotificationID, DateTime scheduleDateTime});
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
    Object? localNotificationID = freezed,
    Object? scheduleDateTime = freezed,
  }) {
    return _then(_LocalNotificationScheduleID(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      localNotificationID: localNotificationID == freezed
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationScheduleID extends _LocalNotificationScheduleID {
  _$_LocalNotificationScheduleID(
      {required this.key,
      required this.localNotificationID,
      required this.scheduleDateTime})
      : super._();

  factory _$_LocalNotificationScheduleID.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleIDFromJson(json);

  @override
  final String key;
  @override
  final int localNotificationID;
  @override
  final DateTime scheduleDateTime;

  @override
  String toString() {
    return 'LocalNotificationScheduleID(key: $key, localNotificationID: $localNotificationID, scheduleDateTime: $scheduleDateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationScheduleID &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality()
                .equals(other.localNotificationID, localNotificationID) &&
            const DeepCollectionEquality()
                .equals(other.scheduleDateTime, scheduleDateTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(localNotificationID),
      const DeepCollectionEquality().hash(scheduleDateTime));

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
      {required String key,
      required int localNotificationID,
      required DateTime scheduleDateTime}) = _$_LocalNotificationScheduleID;
  _LocalNotificationScheduleID._() : super._();

  factory _LocalNotificationScheduleID.fromJson(Map<String, dynamic> json) =
      _$_LocalNotificationScheduleID.fromJson;

  @override
  String get key;
  @override
  int get localNotificationID;
  @override
  DateTime get scheduleDateTime;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleIDCopyWith<_LocalNotificationScheduleID>
      get copyWith => throw _privateConstructorUsedError;
}

LocalNotificationScheduleIDs _$LocalNotificationScheduleIDsFromJson(
    Map<String, dynamic> json) {
  return _LocalNotificationScheduleIDs.fromJson(json);
}

/// @nodoc
class _$LocalNotificationScheduleIDsTearOff {
  const _$LocalNotificationScheduleIDsTearOff();

  _LocalNotificationScheduleIDs call(
      {required List<LocalNotificationScheduleID> ids}) {
    return _LocalNotificationScheduleIDs(
      ids: ids,
    );
  }

  LocalNotificationScheduleIDs fromJson(Map<String, Object?> json) {
    return LocalNotificationScheduleIDs.fromJson(json);
  }
}

/// @nodoc
const $LocalNotificationScheduleIDs = _$LocalNotificationScheduleIDsTearOff();

/// @nodoc
mixin _$LocalNotificationScheduleIDs {
  List<LocalNotificationScheduleID> get ids =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationScheduleIDsCopyWith<LocalNotificationScheduleIDs>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationScheduleIDsCopyWith<$Res> {
  factory $LocalNotificationScheduleIDsCopyWith(
          LocalNotificationScheduleIDs value,
          $Res Function(LocalNotificationScheduleIDs) then) =
      _$LocalNotificationScheduleIDsCopyWithImpl<$Res>;
  $Res call({List<LocalNotificationScheduleID> ids});
}

/// @nodoc
class _$LocalNotificationScheduleIDsCopyWithImpl<$Res>
    implements $LocalNotificationScheduleIDsCopyWith<$Res> {
  _$LocalNotificationScheduleIDsCopyWithImpl(this._value, this._then);

  final LocalNotificationScheduleIDs _value;
  // ignore: unused_field
  final $Res Function(LocalNotificationScheduleIDs) _then;

  @override
  $Res call({
    Object? ids = freezed,
  }) {
    return _then(_value.copyWith(
      ids: ids == freezed
          ? _value.ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<LocalNotificationScheduleID>,
    ));
  }
}

/// @nodoc
abstract class _$LocalNotificationScheduleIDsCopyWith<$Res>
    implements $LocalNotificationScheduleIDsCopyWith<$Res> {
  factory _$LocalNotificationScheduleIDsCopyWith(
          _LocalNotificationScheduleIDs value,
          $Res Function(_LocalNotificationScheduleIDs) then) =
      __$LocalNotificationScheduleIDsCopyWithImpl<$Res>;
  @override
  $Res call({List<LocalNotificationScheduleID> ids});
}

/// @nodoc
class __$LocalNotificationScheduleIDsCopyWithImpl<$Res>
    extends _$LocalNotificationScheduleIDsCopyWithImpl<$Res>
    implements _$LocalNotificationScheduleIDsCopyWith<$Res> {
  __$LocalNotificationScheduleIDsCopyWithImpl(
      _LocalNotificationScheduleIDs _value,
      $Res Function(_LocalNotificationScheduleIDs) _then)
      : super(_value, (v) => _then(v as _LocalNotificationScheduleIDs));

  @override
  _LocalNotificationScheduleIDs get _value =>
      super._value as _LocalNotificationScheduleIDs;

  @override
  $Res call({
    Object? ids = freezed,
  }) {
    return _then(_LocalNotificationScheduleIDs(
      ids: ids == freezed
          ? _value.ids
          : ids // ignore: cast_nullable_to_non_nullable
              as List<LocalNotificationScheduleID>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationScheduleIDs extends _LocalNotificationScheduleIDs {
  _$_LocalNotificationScheduleIDs({required this.ids}) : super._();

  factory _$_LocalNotificationScheduleIDs.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleIDsFromJson(json);

  @override
  final List<LocalNotificationScheduleID> ids;

  @override
  String toString() {
    return 'LocalNotificationScheduleIDs(ids: $ids)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationScheduleIDs &&
            const DeepCollectionEquality().equals(other.ids, ids));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(ids));

  @JsonKey(ignore: true)
  @override
  _$LocalNotificationScheduleIDsCopyWith<_LocalNotificationScheduleIDs>
      get copyWith => __$LocalNotificationScheduleIDsCopyWithImpl<
          _LocalNotificationScheduleIDs>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocalNotificationScheduleIDsToJson(this);
  }
}

abstract class _LocalNotificationScheduleIDs
    extends LocalNotificationScheduleIDs {
  factory _LocalNotificationScheduleIDs(
          {required List<LocalNotificationScheduleID> ids}) =
      _$_LocalNotificationScheduleIDs;
  _LocalNotificationScheduleIDs._() : super._();

  factory _LocalNotificationScheduleIDs.fromJson(Map<String, dynamic> json) =
      _$_LocalNotificationScheduleIDs.fromJson;

  @override
  List<LocalNotificationScheduleID> get ids;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleIDsCopyWith<_LocalNotificationScheduleIDs>
      get copyWith => throw _privateConstructorUsedError;
}
