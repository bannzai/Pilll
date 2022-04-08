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
      required String title,
      required String message,
      required int localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime scheduleDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDate}) {
    return _LocalNotificationSchedule(
      kind: kind,
      title: title,
      message: message,
      localNotificationID: localNotificationID,
      scheduleDateTime: scheduleDateTime,
      createdDate: createdDate,
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
  String get title => throw _privateConstructorUsedError;
  String get message =>
      throw _privateConstructorUsedError; // NOTE: localNotificationID set  to count of all local notification schedules
  int get localNotificationID => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get scheduleDateTime => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate => throw _privateConstructorUsedError;

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
      String title,
      String message,
      int localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime scheduleDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});
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
    Object? title = freezed,
    Object? message = freezed,
    Object? localNotificationID = freezed,
    Object? scheduleDateTime = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_value.copyWith(
      kind: kind == freezed
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      localNotificationID: localNotificationID == freezed
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
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
  $Res call(
      {LocalNotificationScheduleKind kind,
      String title,
      String message,
      int localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime scheduleDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});
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
    Object? title = freezed,
    Object? message = freezed,
    Object? localNotificationID = freezed,
    Object? scheduleDateTime = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_LocalNotificationSchedule(
      kind: kind == freezed
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      localNotificationID: localNotificationID == freezed
          ? _value.localNotificationID
          : localNotificationID // ignore: cast_nullable_to_non_nullable
              as int,
      scheduleDateTime: scheduleDateTime == freezed
          ? _value.scheduleDateTime
          : scheduleDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationSchedule extends _LocalNotificationSchedule {
  _$_LocalNotificationSchedule(
      {required this.kind,
      required this.title,
      required this.message,
      required this.localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.scheduleDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDate})
      : super._();

  factory _$_LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleFromJson(json);

  @override
  final LocalNotificationScheduleKind kind;
  @override
  final String title;
  @override
  final String message;
  @override // NOTE: localNotificationID set  to count of all local notification schedules
  final int localNotificationID;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime scheduleDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDate;

  @override
  String toString() {
    return 'LocalNotificationSchedule(kind: $kind, title: $title, message: $message, localNotificationID: $localNotificationID, scheduleDateTime: $scheduleDateTime, createdDate: $createdDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationSchedule &&
            const DeepCollectionEquality().equals(other.kind, kind) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality()
                .equals(other.localNotificationID, localNotificationID) &&
            const DeepCollectionEquality()
                .equals(other.scheduleDateTime, scheduleDateTime) &&
            const DeepCollectionEquality()
                .equals(other.createdDate, createdDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(kind),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(localNotificationID),
      const DeepCollectionEquality().hash(scheduleDateTime),
      const DeepCollectionEquality().hash(createdDate));

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
      required String title,
      required String message,
      required int localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime scheduleDateTime,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDate}) = _$_LocalNotificationSchedule;
  _LocalNotificationSchedule._() : super._();

  factory _LocalNotificationSchedule.fromJson(Map<String, dynamic> json) =
      _$_LocalNotificationSchedule.fromJson;

  @override
  LocalNotificationScheduleKind get kind;
  @override
  String get title;
  @override
  String get message;
  @override // NOTE: localNotificationID set  to count of all local notification schedules
  int get localNotificationID;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get scheduleDateTime;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleCopyWith<_LocalNotificationSchedule>
      get copyWith => throw _privateConstructorUsedError;
}

LocalNotificationScheduleCollection
    _$LocalNotificationScheduleCollectionFromJson(Map<String, dynamic> json) {
  return _LocalNotificationScheduleCollection.fromJson(json);
}

/// @nodoc
class _$LocalNotificationScheduleCollectionTearOff {
  const _$LocalNotificationScheduleCollectionTearOff();

  _LocalNotificationScheduleCollection call(
      {required LocalNotificationScheduleKind kind,
      required List<LocalNotificationSchedule> schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDate}) {
    return _LocalNotificationScheduleCollection(
      kind: kind,
      schedules: schedules,
      createdDate: createdDate,
    );
  }

  LocalNotificationScheduleCollection fromJson(Map<String, Object?> json) {
    return LocalNotificationScheduleCollection.fromJson(json);
  }
}

/// @nodoc
const $LocalNotificationScheduleCollection =
    _$LocalNotificationScheduleCollectionTearOff();

/// @nodoc
mixin _$LocalNotificationScheduleCollection {
  LocalNotificationScheduleKind get kind => throw _privateConstructorUsedError;
  List<LocalNotificationSchedule> get schedules =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationScheduleCollectionCopyWith<
          LocalNotificationScheduleCollection>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationScheduleCollectionCopyWith<$Res> {
  factory $LocalNotificationScheduleCollectionCopyWith(
          LocalNotificationScheduleCollection value,
          $Res Function(LocalNotificationScheduleCollection) then) =
      _$LocalNotificationScheduleCollectionCopyWithImpl<$Res>;
  $Res call(
      {LocalNotificationScheduleKind kind,
      List<LocalNotificationSchedule> schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});
}

/// @nodoc
class _$LocalNotificationScheduleCollectionCopyWithImpl<$Res>
    implements $LocalNotificationScheduleCollectionCopyWith<$Res> {
  _$LocalNotificationScheduleCollectionCopyWithImpl(this._value, this._then);

  final LocalNotificationScheduleCollection _value;
  // ignore: unused_field
  final $Res Function(LocalNotificationScheduleCollection) _then;

  @override
  $Res call({
    Object? kind = freezed,
    Object? schedules = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_value.copyWith(
      kind: kind == freezed
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      schedules: schedules == freezed
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<LocalNotificationSchedule>,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$LocalNotificationScheduleCollectionCopyWith<$Res>
    implements $LocalNotificationScheduleCollectionCopyWith<$Res> {
  factory _$LocalNotificationScheduleCollectionCopyWith(
          _LocalNotificationScheduleCollection value,
          $Res Function(_LocalNotificationScheduleCollection) then) =
      __$LocalNotificationScheduleCollectionCopyWithImpl<$Res>;
  @override
  $Res call(
      {LocalNotificationScheduleKind kind,
      List<LocalNotificationSchedule> schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});
}

/// @nodoc
class __$LocalNotificationScheduleCollectionCopyWithImpl<$Res>
    extends _$LocalNotificationScheduleCollectionCopyWithImpl<$Res>
    implements _$LocalNotificationScheduleCollectionCopyWith<$Res> {
  __$LocalNotificationScheduleCollectionCopyWithImpl(
      _LocalNotificationScheduleCollection _value,
      $Res Function(_LocalNotificationScheduleCollection) _then)
      : super(_value, (v) => _then(v as _LocalNotificationScheduleCollection));

  @override
  _LocalNotificationScheduleCollection get _value =>
      super._value as _LocalNotificationScheduleCollection;

  @override
  $Res call({
    Object? kind = freezed,
    Object? schedules = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_LocalNotificationScheduleCollection(
      kind: kind == freezed
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      schedules: schedules == freezed
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as List<LocalNotificationSchedule>,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationScheduleCollection
    extends _LocalNotificationScheduleCollection {
  _$_LocalNotificationScheduleCollection(
      {required this.kind,
      required this.schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDate})
      : super._();

  factory _$_LocalNotificationScheduleCollection.fromJson(
          Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleCollectionFromJson(json);

  @override
  final LocalNotificationScheduleKind kind;
  @override
  final List<LocalNotificationSchedule> schedules;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDate;

  @override
  String toString() {
    return 'LocalNotificationScheduleCollection(kind: $kind, schedules: $schedules, createdDate: $createdDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationScheduleCollection &&
            const DeepCollectionEquality().equals(other.kind, kind) &&
            const DeepCollectionEquality().equals(other.schedules, schedules) &&
            const DeepCollectionEquality()
                .equals(other.createdDate, createdDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(kind),
      const DeepCollectionEquality().hash(schedules),
      const DeepCollectionEquality().hash(createdDate));

  @JsonKey(ignore: true)
  @override
  _$LocalNotificationScheduleCollectionCopyWith<
          _LocalNotificationScheduleCollection>
      get copyWith => __$LocalNotificationScheduleCollectionCopyWithImpl<
          _LocalNotificationScheduleCollection>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocalNotificationScheduleCollectionToJson(this);
  }
}

abstract class _LocalNotificationScheduleCollection
    extends LocalNotificationScheduleCollection {
  factory _LocalNotificationScheduleCollection(
      {required LocalNotificationScheduleKind kind,
      required List<LocalNotificationSchedule> schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime
              createdDate}) = _$_LocalNotificationScheduleCollection;
  _LocalNotificationScheduleCollection._() : super._();

  factory _LocalNotificationScheduleCollection.fromJson(
          Map<String, dynamic> json) =
      _$_LocalNotificationScheduleCollection.fromJson;

  @override
  LocalNotificationScheduleKind get kind;
  @override
  List<LocalNotificationSchedule> get schedules;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleCollectionCopyWith<
          _LocalNotificationScheduleCollection>
      get copyWith => throw _privateConstructorUsedError;
}
