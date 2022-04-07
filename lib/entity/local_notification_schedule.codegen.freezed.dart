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
      {required String key,
      required int localNotification,
      required DateTime scheduleDateTime}) {
    return _LocalNotificationSchedule(
      key: key,
      localNotification: localNotification,
      scheduleDateTime: scheduleDateTime,
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
  String get key => throw _privateConstructorUsedError;
  int get localNotification => throw _privateConstructorUsedError;
  DateTime get scheduleDateTime => throw _privateConstructorUsedError;

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
  $Res call({String key, int localNotification, DateTime scheduleDateTime});
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
    Object? key = freezed,
    Object? localNotification = freezed,
    Object? scheduleDateTime = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      localNotification: localNotification == freezed
          ? _value.localNotification
          : localNotification // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
  $Res call({String key, int localNotification, DateTime scheduleDateTime});
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
    Object? key = freezed,
    Object? localNotification = freezed,
    Object? scheduleDateTime = freezed,
  }) {
    return _then(_LocalNotificationSchedule(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      localNotification: localNotification == freezed
          ? _value.localNotification
          : localNotification // ignore: cast_nullable_to_non_nullable
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
class _$_LocalNotificationSchedule extends _LocalNotificationSchedule {
  _$_LocalNotificationSchedule(
      {required this.key,
      required this.localNotification,
      required this.scheduleDateTime})
      : super._();

  factory _$_LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleFromJson(json);

  @override
  final String key;
  @override
  final int localNotification;
  @override
  final DateTime scheduleDateTime;

  @override
  String toString() {
    return 'LocalNotificationSchedule(key: $key, localNotification: $localNotification, scheduleDateTime: $scheduleDateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationSchedule &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality()
                .equals(other.localNotification, localNotification) &&
            const DeepCollectionEquality()
                .equals(other.scheduleDateTime, scheduleDateTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(localNotification),
      const DeepCollectionEquality().hash(scheduleDateTime));

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
      {required String key,
      required int localNotification,
      required DateTime scheduleDateTime}) = _$_LocalNotificationSchedule;
  _LocalNotificationSchedule._() : super._();

  factory _LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =
      _$_LocalNotificationSchedule.fromJson;

  @override
  String get key;
  @override
  int get localNotification;
  @override
  DateTime get scheduleDateTime;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleCopyWith<_LocalNotificationSchedule>
      get copyWith => throw _privateConstructorUsedError;
}
