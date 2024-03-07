// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_pill_sheet_type.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPillSheetType _$UserPillSheetTypeFromJson(Map<String, dynamic> json) {
  return _UserPillSheetType.fromJson(json);
}

/// @nodoc
mixin _$UserPillSheetType {
  String get name => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  int get dosingPeriod => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPillSheetTypeCopyWith<UserPillSheetType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPillSheetTypeCopyWith<$Res> {
  factory $UserPillSheetTypeCopyWith(
          UserPillSheetType value, $Res Function(UserPillSheetType) then) =
      _$UserPillSheetTypeCopyWithImpl<$Res, UserPillSheetType>;
  @useResult
  $Res call(
      {String name,
      int totalCount,
      int dosingPeriod,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdDateTime});
}

/// @nodoc
class _$UserPillSheetTypeCopyWithImpl<$Res, $Val extends UserPillSheetType>
    implements $UserPillSheetTypeCopyWith<$Res> {
  _$UserPillSheetTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? totalCount = null,
    Object? dosingPeriod = null,
    Object? createdDateTime = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      dosingPeriod: null == dosingPeriod
          ? _value.dosingPeriod
          : dosingPeriod // ignore: cast_nullable_to_non_nullable
              as int,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPillSheetTypeImplCopyWith<$Res>
    implements $UserPillSheetTypeCopyWith<$Res> {
  factory _$$UserPillSheetTypeImplCopyWith(_$UserPillSheetTypeImpl value,
          $Res Function(_$UserPillSheetTypeImpl) then) =
      __$$UserPillSheetTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int totalCount,
      int dosingPeriod,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      DateTime createdDateTime});
}

/// @nodoc
class __$$UserPillSheetTypeImplCopyWithImpl<$Res>
    extends _$UserPillSheetTypeCopyWithImpl<$Res, _$UserPillSheetTypeImpl>
    implements _$$UserPillSheetTypeImplCopyWith<$Res> {
  __$$UserPillSheetTypeImplCopyWithImpl(_$UserPillSheetTypeImpl _value,
      $Res Function(_$UserPillSheetTypeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? totalCount = null,
    Object? dosingPeriod = null,
    Object? createdDateTime = null,
  }) {
    return _then(_$UserPillSheetTypeImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      dosingPeriod: null == dosingPeriod
          ? _value.dosingPeriod
          : dosingPeriod // ignore: cast_nullable_to_non_nullable
              as int,
      createdDateTime: null == createdDateTime
          ? _value.createdDateTime
          : createdDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UserPillSheetTypeImpl extends _UserPillSheetType
    with DiagnosticableTreeMixin {
  const _$UserPillSheetTypeImpl(
      {required this.name,
      required this.totalCount,
      required this.dosingPeriod,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required this.createdDateTime})
      : super._();

  factory _$UserPillSheetTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPillSheetTypeImplFromJson(json);

  @override
  final String name;
  @override
  final int totalCount;
  @override
  final int dosingPeriod;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdDateTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserPillSheetType(name: $name, totalCount: $totalCount, dosingPeriod: $dosingPeriod, createdDateTime: $createdDateTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserPillSheetType'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('totalCount', totalCount))
      ..add(DiagnosticsProperty('dosingPeriod', dosingPeriod))
      ..add(DiagnosticsProperty('createdDateTime', createdDateTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPillSheetTypeImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.dosingPeriod, dosingPeriod) ||
                other.dosingPeriod == dosingPeriod) &&
            (identical(other.createdDateTime, createdDateTime) ||
                other.createdDateTime == createdDateTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, totalCount, dosingPeriod, createdDateTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPillSheetTypeImplCopyWith<_$UserPillSheetTypeImpl> get copyWith =>
      __$$UserPillSheetTypeImplCopyWithImpl<_$UserPillSheetTypeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPillSheetTypeImplToJson(
      this,
    );
  }
}

abstract class _UserPillSheetType extends UserPillSheetType {
  const factory _UserPillSheetType(
      {required final String name,
      required final int totalCount,
      required final int dosingPeriod,
      @JsonKey(
          fromJson: NonNullTimestampConverter.timestampToDateTime,
          toJson: NonNullTimestampConverter.dateTimeToTimestamp)
      required final DateTime createdDateTime}) = _$UserPillSheetTypeImpl;
  const _UserPillSheetType._() : super._();

  factory _UserPillSheetType.fromJson(Map<String, dynamic> json) =
      _$UserPillSheetTypeImpl.fromJson;

  @override
  String get name;
  @override
  int get totalCount;
  @override
  int get dosingPeriod;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdDateTime;
  @override
  @JsonKey(ignore: true)
  _$$UserPillSheetTypeImplCopyWith<_$UserPillSheetTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
