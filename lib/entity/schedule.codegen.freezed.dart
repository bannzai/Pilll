// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
mixin _$Schedule {
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date => throw _privateConstructorUsedError;
  LocalNotification? get localNotification =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleCopyWith<Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleCopyWith<$Res> {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) then) =
      _$ScheduleCopyWithImpl<$Res, Schedule>;
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull) String? id,
      String title,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime date,
      LocalNotification? localNotification,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdDateTime});

  $LocalNotificationCopyWith<$Res>? get localNotification;
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res, $Val extends Schedule>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? date = null,
    Object? localNotification = freezed,
    Object? createdDateTime = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      localNotification: freezed == localNotification
          ? _value.localNotification
          : localNotification // ignore: cast_nullable_to_non_nullable
              as LocalNotification?,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocalNotificationCopyWith<$Res>? get localNotification {
    if (_value.localNotification == null) {
      return null;
    }

    return $LocalNotificationCopyWith<$Res>(_value.localNotification!, (value) {
      return _then(_value.copyWith(localNotification: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$$_ScheduleCopyWith(
          _$_Schedule value, $Res Function(_$_Schedule) then) =
      __$$_ScheduleCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeIfNull: false, toJson: toNull) String? id,
      String title,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime date,
      LocalNotification? localNotification,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdDateTime});

  @override
  $LocalNotificationCopyWith<$Res>? get localNotification;
}

/// @nodoc
class __$$_ScheduleCopyWithImpl<$Res>
    extends _$ScheduleCopyWithImpl<$Res, _$_Schedule>
    implements _$$_ScheduleCopyWith<$Res> {
  __$$_ScheduleCopyWithImpl(
      _$_Schedule _value, $Res Function(_$_Schedule) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = null,
    Object? date = null,
    Object? localNotification = freezed,
    Object? createdDateTime = null,
  }) {
    return _then(_$_Schedule(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      localNotification: freezed == localNotification
          ? _value.localNotification
          : localNotification // ignore: cast_nullable_to_non_nullable
              as LocalNotification?,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Schedule extends _Schedule {
  const _$_Schedule(
      {@JsonKey(includeIfNull: false, toJson: toNull) this.id,
      required this.title,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.date,
      this.localNotification,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdDateTime})
      : super._();

  factory _$_Schedule.fromJson(Map<String, dynamic> json) =>
      _$$_ScheduleFromJson(json);

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  final String? id;
  @override
  final String title;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime date;
  @override
  final LocalNotification? localNotification;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;

  @override
  String toString() {
    return 'Schedule(id: $id, title: $title, date: $date, localNotification: $localNotification, createdDateTime: $createdDateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Schedule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.localNotification, localNotification) ||
                other.localNotification == localNotification) &&
            (identical(other.createdDateTime, createdDateTime) ||
                other.createdDateTime == createdDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, date, localNotification, createdDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ScheduleCopyWith<_$_Schedule> get copyWith =>
      __$$_ScheduleCopyWithImpl<_$_Schedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScheduleToJson(
      this,
    );
  }
}

abstract class _Schedule extends Schedule {
  const factory _Schedule(
      {@JsonKey(includeIfNull: false, toJson: toNull) final String? id,
      required final String title,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime date,
      final LocalNotification? localNotification,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime createdDateTime}) = _$_Schedule;
  const _Schedule._() : super._();

  factory _Schedule.fromJson(Map<String, dynamic> json) = _$_Schedule.fromJson;

  @override
  @JsonKey(includeIfNull: false, toJson: toNull)
  String? get id;
  @override
  String get title;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  @override
  LocalNotification? get localNotification;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override
  @JsonKey(ignore: true)
  _$$_ScheduleCopyWith<_$_Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}

LocalNotification _$LocalNotificationFromJson(Map<String, dynamic> json) {
  return _LocalNotification.fromJson(json);
}

/// @nodoc
mixin _$LocalNotification {
  int get localNotificationID => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get remindDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationCopyWith<LocalNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationCopyWith<$Res> {
  factory $LocalNotificationCopyWith(
          LocalNotification value, $Res Function(LocalNotification) then) =
      _$LocalNotificationCopyWithImpl<$Res, LocalNotification>;
  @useResult
  $Res call(
      {int localNotificationID,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime remindDateTime});
}

/// @nodoc
class _$LocalNotificationCopyWithImpl<$Res, $Val extends LocalNotification>
    implements $LocalNotificationCopyWith<$Res> {
  _$LocalNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationID = null,
    Object? remindDateTime = null,
  }) {
    return _then(_value.copyWith(
      localNotificationID: null == localNotificationID
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
      remindDateTime: null == remindDateTime
          ? _value.remindDateTime
          : remindDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LocalNotificationCopyWith<$Res>
    implements $LocalNotificationCopyWith<$Res> {
  factory _$$_LocalNotificationCopyWith(_$_LocalNotification value,
          $Res Function(_$_LocalNotification) then) =
      __$$_LocalNotificationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int localNotificationID,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime remindDateTime});
}

/// @nodoc
class __$$_LocalNotificationCopyWithImpl<$Res>
    extends _$LocalNotificationCopyWithImpl<$Res, _$_LocalNotification>
    implements _$$_LocalNotificationCopyWith<$Res> {
  __$$_LocalNotificationCopyWithImpl(
      _$_LocalNotification _value, $Res Function(_$_LocalNotification) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationID = null,
    Object? remindDateTime = null,
  }) {
    return _then(_$_LocalNotification(
      localNotificationID: null == localNotificationID
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
      remindDateTime: null == remindDateTime
          ? _value.remindDateTime
          : remindDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotification extends _LocalNotification {
  const _$_LocalNotification(
      {required this.localNotificationID,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.remindDateTime})
      : super._();

  factory _$_LocalNotification.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationFromJson(json);

  @override
  final int localNotificationID;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime remindDateTime;

  @override
  String toString() {
    return 'LocalNotification(localNotificationID: $localNotificationID, remindDateTime: $remindDateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocalNotification &&
            (identical(other.localNotificationID, localNotificationID) ||
                other.localNotificationID == localNotificationID) &&
            (identical(other.remindDateTime, remindDateTime) ||
                other.remindDateTime == remindDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, localNotificationID, remindDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocalNotificationCopyWith<_$_LocalNotification> get copyWith =>
      __$$_LocalNotificationCopyWithImpl<_$_LocalNotification>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocalNotificationToJson(
      this,
    );
  }
}

abstract class _LocalNotification extends LocalNotification {
  const factory _LocalNotification(
      {required final int localNotificationID,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime remindDateTime}) = _$_LocalNotification;
  const _LocalNotification._() : super._();

  factory _LocalNotification.fromJson(Map<String, dynamic> json) =
      _$_LocalNotification.fromJson;

  @override
  int get localNotificationID;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get remindDateTime;
  @override
  @JsonKey(ignore: true)
  _$$_LocalNotificationCopyWith<_$_LocalNotification> get copyWith =>
      throw _privateConstructorUsedError;
}
