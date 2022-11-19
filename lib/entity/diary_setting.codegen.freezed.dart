// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'diary_setting.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DiarySetting _$DiarySettingFromJson(Map<String, dynamic> json) {
  return _DiarySetting.fromJson(json);
}

/// @nodoc
mixin _$DiarySetting {
  List<String> get physicalConditions => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiarySettingCopyWith<DiarySetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiarySettingCopyWith<$Res> {
  factory $DiarySettingCopyWith(
          DiarySetting value, $Res Function(DiarySetting) then) =
      _$DiarySettingCopyWithImpl<$Res, DiarySetting>;
  @useResult
  $Res call(
      {List<String> physicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});
}

/// @nodoc
class _$DiarySettingCopyWithImpl<$Res, $Val extends DiarySetting>
    implements $DiarySettingCopyWith<$Res> {
  _$DiarySettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? physicalConditions = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      physicalConditions: null == physicalConditions
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DiarySettingCopyWith<$Res>
    implements $DiarySettingCopyWith<$Res> {
  factory _$$_DiarySettingCopyWith(
          _$_DiarySetting value, $Res Function(_$_DiarySetting) then) =
      __$$_DiarySettingCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> physicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          DateTime createdAt});
}

/// @nodoc
class __$$_DiarySettingCopyWithImpl<$Res>
    extends _$DiarySettingCopyWithImpl<$Res, _$_DiarySetting>
    implements _$$_DiarySettingCopyWith<$Res> {
  __$$_DiarySettingCopyWithImpl(
      _$_DiarySetting _value, $Res Function(_$_DiarySetting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? physicalConditions = null,
    Object? createdAt = null,
  }) {
    return _then(_$_DiarySetting(
      physicalConditions: null == physicalConditions
          ? _value._physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_DiarySetting extends _DiarySetting with DiagnosticableTreeMixin {
  const _$_DiarySetting(
      {final List<String> physicalConditions = defaultPhysicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required this.createdAt})
      : _physicalConditions = physicalConditions,
        super._();

  factory _$_DiarySetting.fromJson(Map<String, dynamic> json) =>
      _$$_DiarySettingFromJson(json);

  final List<String> _physicalConditions;
  @override
  @JsonKey()
  List<String> get physicalConditions {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_physicalConditions);
  }

  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DiarySetting(physicalConditions: $physicalConditions, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DiarySetting'))
      ..add(DiagnosticsProperty('physicalConditions', physicalConditions))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DiarySetting &&
            const DeepCollectionEquality()
                .equals(other._physicalConditions, _physicalConditions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_physicalConditions), createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiarySettingCopyWith<_$_DiarySetting> get copyWith =>
      __$$_DiarySettingCopyWithImpl<_$_DiarySetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DiarySettingToJson(
      this,
    );
  }
}

abstract class _DiarySetting extends DiarySetting {
  const factory _DiarySetting(
      {final List<String> physicalConditions,
      @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)
          required final DateTime createdAt}) = _$_DiarySetting;
  const _DiarySetting._() : super._();

  factory _DiarySetting.fromJson(Map<String, dynamic> json) =
      _$_DiarySetting.fromJson;

  @override
  List<String> get physicalConditions;
  @override
  @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp)
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$_DiarySettingCopyWith<_$_DiarySetting> get copyWith =>
      throw _privateConstructorUsedError;
}
