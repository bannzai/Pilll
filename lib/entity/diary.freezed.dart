// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return _Diary.fromJson(json);
}

/// @nodoc
class _$DiaryTearOff {
  const _$DiaryTearOff();

// ignore: unused_element
  _Diary call(
      {@required
      @JsonKey(nullable: false, fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime date,
      PhysicalConditionStatus physicalConditionStatus,
      @required
          List<String> physicalConditions,
      @required
          bool hasSex,
      @required
          String memo}) {
    return _Diary(
      date: date,
      physicalConditionStatus: physicalConditionStatus,
      physicalConditions: physicalConditions,
      hasSex: hasSex,
      memo: memo,
    );
  }

// ignore: unused_element
  Diary fromJson(Map<String, Object> json) {
    return Diary.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Diary = _$DiaryTearOff();

/// @nodoc
mixin _$Diary {
  @JsonKey(
      nullable: false,
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  PhysicalConditionStatus get physicalConditionStatus;
  List<String> get physicalConditions;
  bool get hasSex;
  String get memo;

  Map<String, dynamic> toJson();
  $DiaryCopyWith<Diary> get copyWith;
}

/// @nodoc
abstract class $DiaryCopyWith<$Res> {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) then) =
      _$DiaryCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(nullable: false, fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime date,
      PhysicalConditionStatus physicalConditionStatus,
      List<String> physicalConditions,
      bool hasSex,
      String memo});
}

/// @nodoc
class _$DiaryCopyWithImpl<$Res> implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._value, this._then);

  final Diary _value;
  // ignore: unused_field
  final $Res Function(Diary) _then;

  @override
  $Res call({
    Object date = freezed,
    Object physicalConditionStatus = freezed,
    Object physicalConditions = freezed,
    Object hasSex = freezed,
    Object memo = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed ? _value.date : date as DateTime,
      physicalConditionStatus: physicalConditionStatus == freezed
          ? _value.physicalConditionStatus
          : physicalConditionStatus as PhysicalConditionStatus,
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions as List<String>,
      hasSex: hasSex == freezed ? _value.hasSex : hasSex as bool,
      memo: memo == freezed ? _value.memo : memo as String,
    ));
  }
}

/// @nodoc
abstract class _$DiaryCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$DiaryCopyWith(_Diary value, $Res Function(_Diary) then) =
      __$DiaryCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(nullable: false, fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime date,
      PhysicalConditionStatus physicalConditionStatus,
      List<String> physicalConditions,
      bool hasSex,
      String memo});
}

/// @nodoc
class __$DiaryCopyWithImpl<$Res> extends _$DiaryCopyWithImpl<$Res>
    implements _$DiaryCopyWith<$Res> {
  __$DiaryCopyWithImpl(_Diary _value, $Res Function(_Diary) _then)
      : super(_value, (v) => _then(v as _Diary));

  @override
  _Diary get _value => super._value as _Diary;

  @override
  $Res call({
    Object date = freezed,
    Object physicalConditionStatus = freezed,
    Object physicalConditions = freezed,
    Object hasSex = freezed,
    Object memo = freezed,
  }) {
    return _then(_Diary(
      date: date == freezed ? _value.date : date as DateTime,
      physicalConditionStatus: physicalConditionStatus == freezed
          ? _value.physicalConditionStatus
          : physicalConditionStatus as PhysicalConditionStatus,
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions as List<String>,
      hasSex: hasSex == freezed ? _value.hasSex : hasSex as bool,
      memo: memo == freezed ? _value.memo : memo as String,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_Diary implements _Diary {
  _$_Diary(
      {@required
      @JsonKey(nullable: false, fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.date,
      this.physicalConditionStatus,
      @required
          this.physicalConditions,
      @required
          this.hasSex,
      @required
          this.memo})
      : assert(date != null),
        assert(physicalConditions != null),
        assert(hasSex != null),
        assert(memo != null);

  factory _$_Diary.fromJson(Map<String, dynamic> json) =>
      _$_$_DiaryFromJson(json);

  @override
  @JsonKey(
      nullable: false,
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime date;
  @override
  final PhysicalConditionStatus physicalConditionStatus;
  @override
  final List<String> physicalConditions;
  @override
  final bool hasSex;
  @override
  final String memo;

  bool _didid = false;
  String _id;

  @override
  String get id {
    if (_didid == false) {
      _didid = true;
      _id = "Diary_${DateTimeFormatter.diaryIdentifier(date)}";
    }
    return _id;
  }

  @override
  String toString() {
    return 'Diary(date: $date, physicalConditionStatus: $physicalConditionStatus, physicalConditions: $physicalConditions, hasSex: $hasSex, memo: $memo, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Diary &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(
                    other.physicalConditionStatus, physicalConditionStatus) ||
                const DeepCollectionEquality().equals(
                    other.physicalConditionStatus, physicalConditionStatus)) &&
            (identical(other.physicalConditions, physicalConditions) ||
                const DeepCollectionEquality()
                    .equals(other.physicalConditions, physicalConditions)) &&
            (identical(other.hasSex, hasSex) ||
                const DeepCollectionEquality().equals(other.hasSex, hasSex)) &&
            (identical(other.memo, memo) ||
                const DeepCollectionEquality().equals(other.memo, memo)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(physicalConditionStatus) ^
      const DeepCollectionEquality().hash(physicalConditions) ^
      const DeepCollectionEquality().hash(hasSex) ^
      const DeepCollectionEquality().hash(memo);

  @override
  _$DiaryCopyWith<_Diary> get copyWith =>
      __$DiaryCopyWithImpl<_Diary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DiaryToJson(this);
  }
}

abstract class _Diary implements Diary {
  factory _Diary(
      {@required
      @JsonKey(nullable: false, fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          DateTime date,
      PhysicalConditionStatus physicalConditionStatus,
      @required
          List<String> physicalConditions,
      @required
          bool hasSex,
      @required
          String memo}) = _$_Diary;

  factory _Diary.fromJson(Map<String, dynamic> json) = _$_Diary.fromJson;

  @override
  @JsonKey(
      nullable: false,
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  @override
  PhysicalConditionStatus get physicalConditionStatus;
  @override
  List<String> get physicalConditions;
  @override
  bool get hasSex;
  @override
  String get memo;
  @override
  _$DiaryCopyWith<_Diary> get copyWith;
}
