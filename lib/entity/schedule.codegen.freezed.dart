// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'schedule.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return _Schedule.fromJson(json);
}

/// @nodoc
class _$ScheduleTearOff {
  const _$ScheduleTearOff();

  _Schedule call(
      {String? id,
      required String title,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime date,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDateTime}) {
    return _Schedule(
      id: id,
      title: title,
      date: date,
      createdDateTime: createdDateTime,
    );
  }

  Schedule fromJson(Map<String, Object?> json) {
    return Schedule.fromJson(json);
  }
}

/// @nodoc
const $Schedule = _$ScheduleTearOff();

/// @nodoc
mixin _$Schedule {
  String? get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date => throw _privateConstructorUsedError;
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
      _$ScheduleCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String title,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime date,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDateTime});
}

/// @nodoc
class _$ScheduleCopyWithImpl<$Res> implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._value, this._then);

  final Schedule _value;
  // ignore: unused_field
  final $Res Function(Schedule) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? date = freezed,
    Object? createdDateTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: createdDateTime == freezed
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) then) =
      __$ScheduleCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String title,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime date,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdDateTime});
}

/// @nodoc
class __$ScheduleCopyWithImpl<$Res> extends _$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(_Schedule _value, $Res Function(_Schedule) _then)
      : super(_value, (v) => _then(v as _Schedule));

  @override
  _Schedule get _value => super._value as _Schedule;

  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? date = freezed,
    Object? createdDateTime = freezed,
  }) {
    return _then(_Schedule(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdDateTime: createdDateTime == freezed
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
      {this.id,
      required this.title,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.date,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdDateTime})
      : super._();

  factory _$_Schedule.fromJson(Map<String, dynamic> json) =>
      _$$_ScheduleFromJson(json);

  @override
  final String? id;
  @override
  final String title;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime date;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;

  @override
  String toString() {
    return 'Schedule(id: $id, title: $title, date: $date, createdDateTime: $createdDateTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Schedule &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality()
                .equals(other.createdDateTime, createdDateTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(createdDateTime));

  @JsonKey(ignore: true)
  @override
  _$ScheduleCopyWith<_Schedule> get copyWith =>
      __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ScheduleToJson(this);
  }
}

abstract class _Schedule extends Schedule {
  const factory _Schedule(
      {String? id,
      required String title,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime date,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required DateTime createdDateTime}) = _$_Schedule;
  const _Schedule._() : super._();

  factory _Schedule.fromJson(Map<String, dynamic> json) = _$_Schedule.fromJson;

  @override
  String? get id;
  @override
  String get title;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override
  @JsonKey(ignore: true)
  _$ScheduleCopyWith<_Schedule> get copyWith =>
      throw _privateConstructorUsedError;
}
