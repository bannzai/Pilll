// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
class _$PackageTearOff {
  const _$PackageTearOff();

  _Package call(
      {required String latestOS,
      required String appName,
      required String appVersion,
      required String buildNumber}) {
    return _Package(
      latestOS: latestOS,
      appName: appName,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );
  }

  Package fromJson(Map<String, Object> json) {
    return Package.fromJson(json);
  }
}

/// @nodoc
const $Package = _$PackageTearOff();

/// @nodoc
mixin _$Package {
  String get latestOS => throw _privateConstructorUsedError;
  String get appName => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  String get buildNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res>;
  $Res call(
      {String latestOS, String appName, String appVersion, String buildNumber});
}

/// @nodoc
class _$PackageCopyWithImpl<$Res> implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  final Package _value;
  // ignore: unused_field
  final $Res Function(Package) _then;

  @override
  $Res call({
    Object? latestOS = freezed,
    Object? appName = freezed,
    Object? appVersion = freezed,
    Object? buildNumber = freezed,
  }) {
    return _then(_value.copyWith(
      latestOS: latestOS == freezed
          ? _value.latestOS
          : latestOS // ignore: cast_nullable_to_non_nullable
              as String,
      appName: appName == freezed
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: appVersion == freezed
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: buildNumber == freezed
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$PackageCopyWith(_Package value, $Res Function(_Package) then) =
      __$PackageCopyWithImpl<$Res>;
  @override
  $Res call(
      {String latestOS, String appName, String appVersion, String buildNumber});
}

/// @nodoc
class __$PackageCopyWithImpl<$Res> extends _$PackageCopyWithImpl<$Res>
    implements _$PackageCopyWith<$Res> {
  __$PackageCopyWithImpl(_Package _value, $Res Function(_Package) _then)
      : super(_value, (v) => _then(v as _Package));

  @override
  _Package get _value => super._value as _Package;

  @override
  $Res call({
    Object? latestOS = freezed,
    Object? appName = freezed,
    Object? appVersion = freezed,
    Object? buildNumber = freezed,
  }) {
    return _then(_Package(
      latestOS: latestOS == freezed
          ? _value.latestOS
          : latestOS // ignore: cast_nullable_to_non_nullable
              as String,
      appName: appName == freezed
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: appVersion == freezed
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: buildNumber == freezed
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Package implements _Package {
  _$_Package(
      {required this.latestOS,
      required this.appName,
      required this.appVersion,
      required this.buildNumber});

  factory _$_Package.fromJson(Map<String, dynamic> json) =>
      _$_$_PackageFromJson(json);

  @override
  final String latestOS;
  @override
  final String appName;
  @override
  final String appVersion;
  @override
  final String buildNumber;

  @override
  String toString() {
    return 'Package(latestOS: $latestOS, appName: $appName, appVersion: $appVersion, buildNumber: $buildNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Package &&
            (identical(other.latestOS, latestOS) ||
                const DeepCollectionEquality()
                    .equals(other.latestOS, latestOS)) &&
            (identical(other.appName, appName) ||
                const DeepCollectionEquality()
                    .equals(other.appName, appName)) &&
            (identical(other.appVersion, appVersion) ||
                const DeepCollectionEquality()
                    .equals(other.appVersion, appVersion)) &&
            (identical(other.buildNumber, buildNumber) ||
                const DeepCollectionEquality()
                    .equals(other.buildNumber, buildNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(latestOS) ^
      const DeepCollectionEquality().hash(appName) ^
      const DeepCollectionEquality().hash(appVersion) ^
      const DeepCollectionEquality().hash(buildNumber);

  @JsonKey(ignore: true)
  @override
  _$PackageCopyWith<_Package> get copyWith =>
      __$PackageCopyWithImpl<_Package>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PackageToJson(this);
  }
}

abstract class _Package implements Package {
  factory _Package(
      {required String latestOS,
      required String appName,
      required String appVersion,
      required String buildNumber}) = _$_Package;

  factory _Package.fromJson(Map<String, dynamic> json) = _$_Package.fromJson;

  @override
  String get latestOS => throw _privateConstructorUsedError;
  @override
  String get appName => throw _privateConstructorUsedError;
  @override
  String get appVersion => throw _privateConstructorUsedError;
  @override
  String get buildNumber => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$PackageCopyWith<_Package> get copyWith =>
      throw _privateConstructorUsedError;
}
