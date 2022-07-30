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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DiarySetting _$DiarySettingFromJson(Map<String, dynamic> json) {
  return _DiarySetting.fromJson(json);
}

/// @nodoc
class _$DiarySettingTearOff {
  const _$DiarySettingTearOff();

  _DiarySetting call(
      {List<String> physicalConditions = defaultPhysicalConditions}) {
    return _DiarySetting(
      physicalConditions: physicalConditions,
    );
  }

  DiarySetting fromJson(Map<String, Object?> json) {
    return DiarySetting.fromJson(json);
  }
}

/// @nodoc
const $DiarySetting = _$DiarySettingTearOff();

/// @nodoc
mixin _$DiarySetting {
  List<String> get physicalConditions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DiarySettingCopyWith<DiarySetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiarySettingCopyWith<$Res> {
  factory $DiarySettingCopyWith(
          DiarySetting value, $Res Function(DiarySetting) then) =
      _$DiarySettingCopyWithImpl<$Res>;
  $Res call({List<String> physicalConditions});
}

/// @nodoc
class _$DiarySettingCopyWithImpl<$Res> implements $DiarySettingCopyWith<$Res> {
  _$DiarySettingCopyWithImpl(this._value, this._then);

  final DiarySetting _value;
  // ignore: unused_field
  final $Res Function(DiarySetting) _then;

  @override
  $Res call({
    Object? physicalConditions = freezed,
  }) {
    return _then(_value.copyWith(
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$DiarySettingCopyWith<$Res>
    implements $DiarySettingCopyWith<$Res> {
  factory _$DiarySettingCopyWith(
          _DiarySetting value, $Res Function(_DiarySetting) then) =
      __$DiarySettingCopyWithImpl<$Res>;
  @override
  $Res call({List<String> physicalConditions});
}

/// @nodoc
class __$DiarySettingCopyWithImpl<$Res> extends _$DiarySettingCopyWithImpl<$Res>
    implements _$DiarySettingCopyWith<$Res> {
  __$DiarySettingCopyWithImpl(
      _DiarySetting _value, $Res Function(_DiarySetting) _then)
      : super(_value, (v) => _then(v as _DiarySetting));

  @override
  _DiarySetting get _value => super._value as _DiarySetting;

  @override
  $Res call({
    Object? physicalConditions = freezed,
  }) {
    return _then(_DiarySetting(
      physicalConditions: physicalConditions == freezed
          ? _value.physicalConditions
          : physicalConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_DiarySetting extends _DiarySetting with DiagnosticableTreeMixin {
  const _$_DiarySetting({this.physicalConditions = defaultPhysicalConditions})
      : super._();

  factory _$_DiarySetting.fromJson(Map<String, dynamic> json) =>
      _$$_DiarySettingFromJson(json);

  @JsonKey()
  @override
  final List<String> physicalConditions;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'DiarySetting(physicalConditions: $physicalConditions)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'DiarySetting'))
      ..add(DiagnosticsProperty('physicalConditions', physicalConditions));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiarySetting &&
            const DeepCollectionEquality()
                .equals(other.physicalConditions, physicalConditions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(physicalConditions));

  @JsonKey(ignore: true)
  @override
  _$DiarySettingCopyWith<_DiarySetting> get copyWith =>
      __$DiarySettingCopyWithImpl<_DiarySetting>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DiarySettingToJson(this);
  }
}

abstract class _DiarySetting extends DiarySetting {
  const factory _DiarySetting({List<String> physicalConditions}) =
      _$_DiarySetting;
  const _DiarySetting._() : super._();

  factory _DiarySetting.fromJson(Map<String, dynamic> json) =
      _$_DiarySetting.fromJson;

  @override
  List<String> get physicalConditions;
  @override
  @JsonKey(ignore: true)
  _$DiarySettingCopyWith<_DiarySetting> get copyWith =>
      throw _privateConstructorUsedError;
}
