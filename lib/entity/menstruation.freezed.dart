// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'menstruation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Menstruation _$MenstruationFromJson(Map<String, dynamic> json) {
  return _Menstruation.fromJson(json);
}

/// @nodoc
class _$MenstruationTearOff {
  const _$MenstruationTearOff();

  _Menstruation call(
      {required DateTime date,
      required List<String> physicalConditions,
      required bool hasSex,
      required String memo}) {
    return _Menstruation(
      date: date,
      physicalConditions: physicalConditions,
      hasSex: hasSex,
      memo: memo,
    );
  }

  Menstruation fromJson(Map<String, Object> json) {
    return Menstruation.fromJson(json);
  }
}

/// @nodoc
const $Menstruation = _$MenstruationTearOff();

/// @nodoc
mixin _$Menstruation {
  DateTime get date => throw _privateConstructorUsedError;
  List<String> get physicalConditions => throw _privateConstructorUsedError;
  bool get hasSex => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MenstruationCopyWith<Menstruation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenstruationCopyWith<$Res> {
  factory $MenstruationCopyWith(
          Menstruation value, $Res Function(Menstruation) then) =
      _$MenstruationCopyWithImpl<$Res>;
  $Res call(
      {DateTime date,
      List<String> physicalConditions,
      bool hasSex,
      String memo});
}

/// @nodoc
class _$MenstruationCopyWithImpl<$Res> implements $MenstruationCopyWith<$Res> {
  _$MenstruationCopyWithImpl(this._value, this._then);

  final Menstruation _value;
  // ignore: unused_field
  final $Res Function(Menstruation) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? physicalConditions = freezed,
    Object? hasSex = freezed,
    Object? memo = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSex: hasSex == freezed
          ? _value.hasSex
          : hasSex // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: memo == freezed
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$MenstruationCopyWith<$Res>
    implements $MenstruationCopyWith<$Res> {
  factory _$MenstruationCopyWith(
          _Menstruation value, $Res Function(_Menstruation) then) =
      __$MenstruationCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime date,
      List<String> physicalConditions,
      bool hasSex,
      String memo});
}

/// @nodoc
class __$MenstruationCopyWithImpl<$Res> extends _$MenstruationCopyWithImpl<$Res>
    implements _$MenstruationCopyWith<$Res> {
  __$MenstruationCopyWithImpl(
      _Menstruation _value, $Res Function(_Menstruation) _then)
      : super(_value, (v) => _then(v as _Menstruation));

  @override
  _Menstruation get _value => super._value as _Menstruation;

  @override
  $Res call({
    Object? date = freezed,
    Object? physicalConditions = freezed,
    Object? hasSex = freezed,
    Object? memo = freezed,
  }) {
    return _then(_Menstruation(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasSex: hasSex == freezed
          ? _value.hasSex
          : hasSex // ignore: cast_nullable_to_non_nullable
              as bool,
      memo: memo == freezed
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

@JsonSerializable(explicitToJson: true)

/// @nodoc
class _$_Menstruation implements _Menstruation {
  _$_Menstruation(
      {required this.date,
      required this.physicalConditions,
      required this.hasSex,
      required this.memo});

  factory _$_Menstruation.fromJson(Map<String, dynamic> json) =>
      _$_$_MenstruationFromJson(json);

  @override
  final DateTime date;
  @override
  final List<String> physicalConditions;
  @override
  final bool hasSex;
  @override
  final String memo;

  @override
  String toString() {
    return 'Menstruation(date: $date, physicalConditions: $physicalConditions, hasSex: $hasSex, memo: $memo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Menstruation &&
            (identical(other.date, date) ||
                const DeepCollectionEquality().equals(other.date, date)) &&
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
      const DeepCollectionEquality().hash(physicalConditions) ^
      const DeepCollectionEquality().hash(hasSex) ^
      const DeepCollectionEquality().hash(memo);

  @JsonKey(ignore: true)
  @override
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      __$MenstruationCopyWithImpl<_Menstruation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_MenstruationToJson(this);
  }
}

abstract class _Menstruation implements Menstruation {
  factory _Menstruation(
      {required DateTime date,
      required List<String> physicalConditions,
      required bool hasSex,
      required String memo}) = _$_Menstruation;

  factory _Menstruation.fromJson(Map<String, dynamic> json) =
      _$_Menstruation.fromJson;

  @override
  DateTime get date => throw _privateConstructorUsedError;
  @override
  List<String> get physicalConditions => throw _privateConstructorUsedError;
  @override
  bool get hasSex => throw _privateConstructorUsedError;
  @override
  String get memo => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MenstruationCopyWith<_Menstruation> get copyWith =>
      throw _privateConstructorUsedError;
}
