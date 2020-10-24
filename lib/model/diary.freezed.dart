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
      @required
          String memo,
      @required
          List<String> physicalCondtions,
      @required
          bool hasSex}) {
    return _Diary(
      date: date,
      memo: memo,
      physicalCondtions: physicalCondtions,
      hasSex: hasSex,
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
  String get memo;
  List<String> get physicalCondtions;
  bool get hasSex;

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
      String memo,
      List<String> physicalCondtions,
      bool hasSex});
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
    Object memo = freezed,
    Object physicalCondtions = freezed,
    Object hasSex = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed ? _value.date : date as DateTime,
      memo: memo == freezed ? _value.memo : memo as String,
      physicalCondtions: physicalCondtions == freezed
          ? _value.physicalCondtions
          : physicalCondtions as List<String>,
      hasSex: hasSex == freezed ? _value.hasSex : hasSex as bool,
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
      String memo,
      List<String> physicalCondtions,
      bool hasSex});
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
    Object memo = freezed,
    Object physicalCondtions = freezed,
    Object hasSex = freezed,
  }) {
    return _then(_Diary(
      date: date == freezed ? _value.date : date as DateTime,
      memo: memo == freezed ? _value.memo : memo as String,
      physicalCondtions: physicalCondtions == freezed
          ? _value.physicalCondtions
          : physicalCondtions as List<String>,
      hasSex: hasSex == freezed ? _value.hasSex : hasSex as bool,
    ));
  }
}

@JsonSerializable(nullable: false, explicitToJson: true)

/// @nodoc
class _$_Diary implements _Diary {
  _$_Diary(
      {@required
      @JsonKey(nullable: false, fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
          this.date,
      @required
          this.memo,
      @required
          this.physicalCondtions,
      @required
          this.hasSex})
      : assert(date != null),
        assert(memo != null),
        assert(physicalCondtions != null),
        assert(hasSex != null);

  factory _$_Diary.fromJson(Map<String, dynamic> json) =>
      _$_$_DiaryFromJson(json);

  @override
  @JsonKey(
      nullable: false,
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime date;
  @override
  final String memo;
  @override
  final List<String> physicalCondtions;
  @override
  final bool hasSex;

  @override
  String toString() {
    return 'Diary(date: $date, memo: $memo, physicalCondtions: $physicalCondtions, hasSex: $hasSex)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Diary &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
            (identical(other.memo, memo) ||
                const DeepCollectionEquality().equals(other.memo, memo)) &&
            (identical(other.physicalCondtions, physicalCondtions) ||
                const DeepCollectionEquality()
                    .equals(other.physicalCondtions, physicalCondtions)) &&
            (identical(other.hasSex, hasSex) ||
                const DeepCollectionEquality().equals(other.hasSex, hasSex)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(date) ^
      const DeepCollectionEquality().hash(memo) ^
      const DeepCollectionEquality().hash(physicalCondtions) ^
      const DeepCollectionEquality().hash(hasSex);

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
      @required
          String memo,
      @required
          List<String> physicalCondtions,
      @required
          bool hasSex}) = _$_Diary;

  factory _Diary.fromJson(Map<String, dynamic> json) = _$_Diary.fromJson;

  @override
  @JsonKey(
      nullable: false,
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime get date;
  @override
  String get memo;
  @override
  List<String> get physicalCondtions;
  @override
  bool get hasSex;
  @override
  _$DiaryCopyWith<_Diary> get copyWith;
}
