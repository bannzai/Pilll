// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'package.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
class _$PackageTearOff {
  const _$PackageTearOff();

// ignore: unused_element
  _Package call(
      {@required String latestOS,
      @required String appName,
      @required String appVersion,
      @required String buildNumber}) {
    return _Package(
      latestOS: latestOS,
      appName: appName,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );
  }

// ignore: unused_element
  Package fromJson(Map<String, Object> json) {
    return Package.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $Package = _$PackageTearOff();

/// @nodoc
mixin _$Package {
  String get latestOS;
  String get appName;
  String get appVersion;
  String get buildNumber;

  Map<String, dynamic> toJson();
  $PackageCopyWith<Package> get copyWith;
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
    Object latestOS = freezed,
    Object appName = freezed,
    Object appVersion = freezed,
    Object buildNumber = freezed,
  }) {
    return _then(_value.copyWith(
      latestOS: latestOS == freezed ? _value.latestOS : latestOS as String,
      appName: appName == freezed ? _value.appName : appName as String,
      appVersion:
          appVersion == freezed ? _value.appVersion : appVersion as String,
      buildNumber:
          buildNumber == freezed ? _value.buildNumber : buildNumber as String,
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
    Object latestOS = freezed,
    Object appName = freezed,
    Object appVersion = freezed,
    Object buildNumber = freezed,
  }) {
    return _then(_Package(
      latestOS: latestOS == freezed ? _value.latestOS : latestOS as String,
      appName: appName == freezed ? _value.appName : appName as String,
      appVersion:
          appVersion == freezed ? _value.appVersion : appVersion as String,
      buildNumber:
          buildNumber == freezed ? _value.buildNumber : buildNumber as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_Package extends _Package {
  _$_Package(
      {@required this.latestOS,
      @required this.appName,
      @required this.appVersion,
      @required this.buildNumber})
      : assert(latestOS != null),
        assert(appName != null),
        assert(appVersion != null),
        assert(buildNumber != null),
        super._();

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

  @override
  _$PackageCopyWith<_Package> get copyWith =>
      __$PackageCopyWithImpl<_Package>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PackageToJson(this);
  }
}

abstract class _Package extends Package {
  _Package._() : super._();
  factory _Package(
      {@required String latestOS,
      @required String appName,
      @required String appVersion,
      @required String buildNumber}) = _$_Package;

  factory _Package.fromJson(Map<String, dynamic> json) = _$_Package.fromJson;

  @override
  String get latestOS;
  @override
  String get appName;
  @override
  String get appVersion;
  @override
  String get buildNumber;
  @override
  _$PackageCopyWith<_Package> get copyWith;
}
