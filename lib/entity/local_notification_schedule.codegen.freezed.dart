// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'local_notification_schedule.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LocalNotificationSchedule _$LocalNotificationScheduleFromJson(
    Map<String, dynamic> json) {
  return _LocalNotificationSchedule.fromJson(json);
}

/// @nodoc
class _$LocalNotificationScheduleTearOff {
  const _$LocalNotificationScheduleTearOff();

  _LocalNotificationSchedule call(
      {required LocalNotificationScheduleKind kind,
      required DateTime scheduleDateTime,
      required int localNotificationID}) {
    return _LocalNotificationSchedule(
      kind: kind,
      scheduleDateTime: scheduleDateTime,
      localNotificationID: localNotificationID,
    );
  }

  LocalNotificationSchedule fromJson(Map<String, Object?> json) {
    return LocalNotificationSchedule.fromJson(json);
  }
}

/// @nodoc
const $LocalNotificationSchedule = _$LocalNotificationScheduleTearOff();

/// @nodoc
mixin _$LocalNotificationSchedule {
  LocalNotificationScheduleKind get kind => throw _privateConstructorUsedError;
  DateTime get scheduleDateTime =>
      throw _privateConstructorUsedError; // NOTE: localNotificationID set  to count of all local notification schedules
  int get localNotificationID => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationScheduleCopyWith<LocalNotificationSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationScheduleCopyWith<$Res> {
  factory $LocalNotificationScheduleCopyWith(LocalNotificationSchedule value,
          $Res Function(LocalNotificationSchedule) then) =
      _$LocalNotificationScheduleCopyWithImpl<$Res>;
  $Res call(
      {LocalNotificationScheduleKind kind,
      DateTime scheduleDateTime,
      int localNotificationID});
}

/// @nodoc
class _$LocalNotificationScheduleCopyWithImpl<$Res>
    implements $LocalNotificationScheduleCopyWith<$Res> {
  _$LocalNotificationScheduleCopyWithImpl(this._value, this._then);

  final LocalNotificationSchedule _value;
  // ignore: unused_field
  final $Res Function(LocalNotificationSchedule) _then;

  @override
  $Res call({
    Object? kind = freezed,
    Object? scheduleDateTime = freezed,
    Object? localNotificationID = freezed,
  }) {
    return _then(_value.copyWith(
      kind: kind == freezed
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      localNotificationID: localNotificationID == freezed
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$LocalNotificationScheduleCopyWith<$Res>
    implements $LocalNotificationScheduleCopyWith<$Res> {
  factory _$LocalNotificationScheduleCopyWith(_LocalNotificationSchedule value,
          $Res Function(_LocalNotificationSchedule) then) =
      __$LocalNotificationScheduleCopyWithImpl<$Res>;
  @override
  $Res call(
      {LocalNotificationScheduleKind kind,
      DateTime scheduleDateTime,
      int localNotificationID});
}

/// @nodoc
class __$LocalNotificationScheduleCopyWithImpl<$Res>
    extends _$LocalNotificationScheduleCopyWithImpl<$Res>
    implements _$LocalNotificationScheduleCopyWith<$Res> {
  __$LocalNotificationScheduleCopyWithImpl(_LocalNotificationSchedule _value,
      $Res Function(_LocalNotificationSchedule) _then)
      : super(_value, (v) => _then(v as _LocalNotificationSchedule));

  @override
  _LocalNotificationSchedule get _value =>
      super._value as _LocalNotificationSchedule;

  @override
  $Res call({
    Object? kind = freezed,
    Object? scheduleDateTime = freezed,
    Object? localNotificationID = freezed,
  }) {
    return _then(_LocalNotificationSchedule(
      kind: kind == freezed
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      localNotificationID: localNotificationID == freezed
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationSchedule extends _LocalNotificationSchedule {
  _$_LocalNotificationSchedule(
      {required this.kind,
      required this.scheduleDateTime,
      required this.localNotificationID})
      : super._();

  factory _$_LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleFromJson(json);

  @override
  final LocalNotificationScheduleKind kind;
  @override
  final DateTime scheduleDateTime;
  @override // NOTE: localNotificationID set  to count of all local notification schedules
  final int localNotificationID;

  @override
  String toString() {
    return 'LocalNotificationSchedule(kind: $kind, scheduleDateTime: $scheduleDateTime, localNotificationID: $localNotificationID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationSchedule &&
            const DeepCollectionEquality().equals(other.kind, kind) &&
            const DeepCollectionEquality()
                .equals(other.scheduleDateTime, scheduleDateTime) &&
            const DeepCollectionEquality()
                .equals(other.localNotificationID, localNotificationID));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(kind),
      const DeepCollectionEquality().hash(scheduleDateTime),
      const DeepCollectionEquality().hash(localNotificationID));

  @JsonKey(ignore: true)
  @override
  _$LocalNotificationScheduleCopyWith<_LocalNotificationSchedule>
      get copyWith =>
          __$LocalNotificationScheduleCopyWithImpl<_LocalNotificationSchedule>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocalNotificationScheduleToJson(this);
  }
}

abstract class _LocalNotificationSchedule extends LocalNotificationSchedule {
  factory _LocalNotificationSchedule(
      {required LocalNotificationScheduleKind kind,
      required DateTime scheduleDateTime,
      required int localNotificationID}) = _$_LocalNotificationSchedule;
  _LocalNotificationSchedule._() : super._();

  factory _LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =
      _$_LocalNotificationSchedule.fromJson;

  @override
  LocalNotificationScheduleKind get kind;
  @override
  DateTime get scheduleDateTime;
  @override // NOTE: localNotificationID set  to count of all local notification schedules
  int get localNotificationID;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleCopyWith<_LocalNotificationSchedule>
      get copyWith => throw _privateConstructorUsedError;
}
