// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return _Config.fromJson(json);
}

/// @nodoc
mixin _$Config {
  /// 最小サポートバージョンを表すバージョン文字列。
  /// このバージョンより古いアプリは強制アップデートが必要となる。
  /// バージョン形式は`Version.parse()`で解析可能な文字列（例: "1.0.0"）。
  String get minimumSupportedAppVersion => throw _privateConstructorUsedError;

  /// Serializes this Config to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConfigCopyWith<Config> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConfigCopyWith<$Res> {
  factory $ConfigCopyWith(Config value, $Res Function(Config) then) = _$ConfigCopyWithImpl<$Res, Config>;
  @useResult
  $Res call({String minimumSupportedAppVersion});
}

/// @nodoc
class _$ConfigCopyWithImpl<$Res, $Val extends Config> implements $ConfigCopyWith<$Res> {
  _$ConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumSupportedAppVersion = null,
  }) {
    return _then(_value.copyWith(
      minimumSupportedAppVersion: null == minimumSupportedAppVersion
          ? _value.minimumSupportedAppVersion
          : minimumSupportedAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConfigImplCopyWith<$Res> implements $ConfigCopyWith<$Res> {
  factory _$$ConfigImplCopyWith(_$ConfigImpl value, $Res Function(_$ConfigImpl) then) = __$$ConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String minimumSupportedAppVersion});
}

/// @nodoc
class __$$ConfigImplCopyWithImpl<$Res> extends _$ConfigCopyWithImpl<$Res, _$ConfigImpl> implements _$$ConfigImplCopyWith<$Res> {
  __$$ConfigImplCopyWithImpl(_$ConfigImpl _value, $Res Function(_$ConfigImpl) _then) : super(_value, _then);

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minimumSupportedAppVersion = null,
  }) {
    return _then(_$ConfigImpl(
      minimumSupportedAppVersion: null == minimumSupportedAppVersion
          ? _value.minimumSupportedAppVersion
          : minimumSupportedAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConfigImpl extends _Config {
  _$ConfigImpl({required this.minimumSupportedAppVersion}) : super._();

  factory _$ConfigImpl.fromJson(Map<String, dynamic> json) => _$$ConfigImplFromJson(json);

  /// 最小サポートバージョンを表すバージョン文字列。
  /// このバージョンより古いアプリは強制アップデートが必要となる。
  /// バージョン形式は`Version.parse()`で解析可能な文字列（例: "1.0.0"）。
  @override
  final String minimumSupportedAppVersion;

  @override
  String toString() {
    return 'Config(minimumSupportedAppVersion: $minimumSupportedAppVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConfigImpl &&
            (identical(other.minimumSupportedAppVersion, minimumSupportedAppVersion) ||
                other.minimumSupportedAppVersion == minimumSupportedAppVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, minimumSupportedAppVersion);

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith => __$$ConfigImplCopyWithImpl<_$ConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConfigImplToJson(
      this,
    );
  }
}

abstract class _Config extends Config {
  factory _Config({required final String minimumSupportedAppVersion}) = _$ConfigImpl;
  _Config._() : super._();

  factory _Config.fromJson(Map<String, dynamic> json) = _$ConfigImpl.fromJson;

  /// 最小サポートバージョンを表すバージョン文字列。
  /// このバージョンより古いアプリは強制アップデートが必要となる。
  /// バージョン形式は`Version.parse()`で解析可能な文字列（例: "1.0.0"）。
  @override
  String get minimumSupportedAppVersion;

  /// Create a copy of Config
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConfigImplCopyWith<_$ConfigImpl> get copyWith => throw _privateConstructorUsedError;
}
