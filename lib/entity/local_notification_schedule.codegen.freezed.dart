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
      required int localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDate}) {
    return _LocalNotificationSchedule(
      kind: kind,
      scheduleDateTime: scheduleDateTime,
      localNotificationID: localNotificationID,
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
  DateTime get scheduleDateTime =>
      throw _privateConstructorUsedError; // NOTE: localNotificationID set  to count of all local notification schedules
  int get localNotificationID => throw _privateConstructorUsedError;
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
      DateTime scheduleDateTime,
      int localNotificationID,
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
    Object? scheduleDateTime = freezed,
    Object? localNotificationID = freezed,
    Object? createdDate = freezed,
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
      DateTime scheduleDateTime,
      int localNotificationID,
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
    Object? scheduleDateTime = freezed,
    Object? localNotificationID = freezed,
    Object? createdDate = freezed,
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
      required this.scheduleDateTime,
      required this.localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDate})
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
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDate;

  @override
  String toString() {
    return 'LocalNotificationSchedule(kind: $kind, scheduleDateTime: $scheduleDateTime, localNotificationID: $localNotificationID, createdDate: $createdDate)';
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
                .equals(other.localNotificationID, localNotificationID) &&
            const DeepCollectionEquality()
                .equals(other.createdDate, createdDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(kind),
      const DeepCollectionEquality().hash(scheduleDateTime),
      const DeepCollectionEquality().hash(localNotificationID),
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
      required DateTime scheduleDateTime,
      required int localNotificationID,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDate}) = _$_LocalNotificationSchedule;
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
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleCopyWith<_LocalNotificationSchedule>
      get copyWith => throw _privateConstructorUsedError;
}

LocalNotificationScheduleDocument _$LocalNotificationScheduleDocumentFromJson(
    Map<String, dynamic> json) {
  return _LocalNotificationScheduleDocument.fromJson(json);
}

/// @nodoc
class _$LocalNotificationScheduleDocumentTearOff {
  const _$LocalNotificationScheduleDocumentTearOff();

  _LocalNotificationScheduleDocument call(
      {required LocalNotificationScheduleKind id,
      required LocalNotificationSchedule schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDate}) {
    return _LocalNotificationScheduleDocument(
      id: id,
      schedules: schedules,
      createdDate: createdDate,
    );
  }

  LocalNotificationScheduleDocument fromJson(Map<String, Object?> json) {
    return LocalNotificationScheduleDocument.fromJson(json);
  }
}

/// @nodoc
const $LocalNotificationScheduleDocument =
    _$LocalNotificationScheduleDocumentTearOff();

/// @nodoc
mixin _$LocalNotificationScheduleDocument {
  LocalNotificationScheduleKind get id => throw _privateConstructorUsedError;
  LocalNotificationSchedule get schedules => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LocalNotificationScheduleDocumentCopyWith<LocalNotificationScheduleDocument>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalNotificationScheduleDocumentCopyWith<$Res> {
  factory $LocalNotificationScheduleDocumentCopyWith(
          LocalNotificationScheduleDocument value,
          $Res Function(LocalNotificationScheduleDocument) then) =
      _$LocalNotificationScheduleDocumentCopyWithImpl<$Res>;
  $Res call(
      {LocalNotificationScheduleKind id,
      LocalNotificationSchedule schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});

  $LocalNotificationScheduleCopyWith<$Res> get schedules;
}

/// @nodoc
class _$LocalNotificationScheduleDocumentCopyWithImpl<$Res>
    implements $LocalNotificationScheduleDocumentCopyWith<$Res> {
  _$LocalNotificationScheduleDocumentCopyWithImpl(this._value, this._then);

  final LocalNotificationScheduleDocument _value;
  // ignore: unused_field
  final $Res Function(LocalNotificationScheduleDocument) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? schedules = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      schedules: schedules == freezed
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as LocalNotificationSchedule,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  @override
  $LocalNotificationScheduleCopyWith<$Res> get schedules {
    return $LocalNotificationScheduleCopyWith<$Res>(_value.schedules, (value) {
      return _then(_value.copyWith(schedules: value));
    });
  }
}

/// @nodoc
abstract class _$LocalNotificationScheduleDocumentCopyWith<$Res>
    implements $LocalNotificationScheduleDocumentCopyWith<$Res> {
  factory _$LocalNotificationScheduleDocumentCopyWith(
          _LocalNotificationScheduleDocument value,
          $Res Function(_LocalNotificationScheduleDocument) then) =
      __$LocalNotificationScheduleDocumentCopyWithImpl<$Res>;
  @override
  $Res call(
      {LocalNotificationScheduleKind id,
      LocalNotificationSchedule schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDate});

  @override
  $LocalNotificationScheduleCopyWith<$Res> get schedules;
}

/// @nodoc
class __$LocalNotificationScheduleDocumentCopyWithImpl<$Res>
    extends _$LocalNotificationScheduleDocumentCopyWithImpl<$Res>
    implements _$LocalNotificationScheduleDocumentCopyWith<$Res> {
  __$LocalNotificationScheduleDocumentCopyWithImpl(
      _LocalNotificationScheduleDocument _value,
      $Res Function(_LocalNotificationScheduleDocument) _then)
      : super(_value, (v) => _then(v as _LocalNotificationScheduleDocument));

  @override
  _LocalNotificationScheduleDocument get _value =>
      super._value as _LocalNotificationScheduleDocument;

  @override
  $Res call({
    Object? id = freezed,
    Object? schedules = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_LocalNotificationScheduleDocument(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as LocalNotificationScheduleKind,
      schedules: schedules == freezed
          ? _value.schedules
          : schedules // ignore: cast_nullable_to_non_nullable
              as LocalNotificationSchedule,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LocalNotificationScheduleDocument
    extends _LocalNotificationScheduleDocument {
  _$_LocalNotificationScheduleDocument(
      {required this.id,
      required this.schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDate})
      : super._();

  factory _$_LocalNotificationScheduleDocument.fromJson(
          Map<String, dynamic> json) =>
      _$$_LocalNotificationScheduleDocumentFromJson(json);

  @override
  final LocalNotificationScheduleKind id;
  @override
  final LocalNotificationSchedule schedules;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDate;

  @override
  String toString() {
    return 'LocalNotificationScheduleDocument(id: $id, schedules: $schedules, createdDate: $createdDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LocalNotificationScheduleDocument &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.schedules, schedules) &&
            const DeepCollectionEquality()
                .equals(other.createdDate, createdDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(schedules),
      const DeepCollectionEquality().hash(createdDate));

  @JsonKey(ignore: true)
  @override
  _$LocalNotificationScheduleDocumentCopyWith<
          _LocalNotificationScheduleDocument>
      get copyWith => __$LocalNotificationScheduleDocumentCopyWithImpl<
          _LocalNotificationScheduleDocument>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LocalNotificationScheduleDocumentToJson(this);
  }
}

abstract class _LocalNotificationScheduleDocument
    extends LocalNotificationScheduleDocument {
  factory _LocalNotificationScheduleDocument(
      {required LocalNotificationScheduleKind id,
      required LocalNotificationSchedule schedules,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime
              createdDate}) = _$_LocalNotificationScheduleDocument;
  _LocalNotificationScheduleDocument._() : super._();

  factory _LocalNotificationScheduleDocument.fromJson(
          Map<String, dynamic> json) =
      _$_LocalNotificationScheduleDocument.fromJson;

  @override
  LocalNotificationScheduleKind get id;
  @override
  LocalNotificationSchedule get schedules;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDate;
  @override
  @JsonKey(ignore: true)
  _$LocalNotificationScheduleDocumentCopyWith<
          _LocalNotificationScheduleDocument>
      get copyWith => throw _privateConstructorUsedError;
}
