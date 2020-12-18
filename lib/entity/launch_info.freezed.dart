// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'launch_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
LaunchInfo _$LaunchInfoFromJson(Map<String, dynamic> json) {
  return _LaunchInfo.fromJson(json);
}

/// @nodoc
class _$LaunchInfoTearOff {
  const _$LaunchInfoTearOff();

// ignore: unused_element
  _LaunchInfo call({@required String latestOS, @required String appVersion}) {
    return _LaunchInfo(
      latestOS: latestOS,
      appVersion: appVersion,
    );
  }

// ignore: unused_element
  LaunchInfo fromJson(Map<String, Object> json) {
    return LaunchInfo.fromJson(json);
  }
}

/// @nodoc
// ignore: unused_element
const $LaunchInfo = _$LaunchInfoTearOff();

/// @nodoc
mixin _$LaunchInfo {
  String get latestOS;
  String get appVersion;

  Map<String, dynamic> toJson();
  $LaunchInfoCopyWith<LaunchInfo> get copyWith;
}

/// @nodoc
abstract class $LaunchInfoCopyWith<$Res> {
  factory $LaunchInfoCopyWith(
          LaunchInfo value, $Res Function(LaunchInfo) then) =
      _$LaunchInfoCopyWithImpl<$Res>;
  $Res call({String latestOS, String appVersion});
}

/// @nodoc
class _$LaunchInfoCopyWithImpl<$Res> implements $LaunchInfoCopyWith<$Res> {
  _$LaunchInfoCopyWithImpl(this._value, this._then);

  final LaunchInfo _value;
  // ignore: unused_field
  final $Res Function(LaunchInfo) _then;

  @override
  $Res call({
    Object latestOS = freezed,
    Object appVersion = freezed,
  }) {
    return _then(_value.copyWith(
      latestOS: latestOS == freezed ? _value.latestOS : latestOS as String,
      appVersion:
          appVersion == freezed ? _value.appVersion : appVersion as String,
    ));
  }
}

/// @nodoc
abstract class _$LaunchInfoCopyWith<$Res> implements $LaunchInfoCopyWith<$Res> {
  factory _$LaunchInfoCopyWith(
          _LaunchInfo value, $Res Function(_LaunchInfo) then) =
      __$LaunchInfoCopyWithImpl<$Res>;
  @override
  $Res call({String latestOS, String appVersion});
}

/// @nodoc
class __$LaunchInfoCopyWithImpl<$Res> extends _$LaunchInfoCopyWithImpl<$Res>
    implements _$LaunchInfoCopyWith<$Res> {
  __$LaunchInfoCopyWithImpl(
      _LaunchInfo _value, $Res Function(_LaunchInfo) _then)
      : super(_value, (v) => _then(v as _LaunchInfo));

  @override
  _LaunchInfo get _value => super._value as _LaunchInfo;

  @override
  $Res call({
    Object latestOS = freezed,
    Object appVersion = freezed,
  }) {
    return _then(_LaunchInfo(
      latestOS: latestOS == freezed ? _value.latestOS : latestOS as String,
      appVersion:
          appVersion == freezed ? _value.appVersion : appVersion as String,
    ));
  }
}

@JsonSerializable()

/// @nodoc
class _$_LaunchInfo extends _LaunchInfo {
  _$_LaunchInfo({@required this.latestOS, @required this.appVersion})
      : assert(latestOS != null),
        assert(appVersion != null),
        super._();

  factory _$_LaunchInfo.fromJson(Map<String, dynamic> json) =>
      _$_$_LaunchInfoFromJson(json);

  @override
  final String latestOS;
  @override
  final String appVersion;

  @override
  String toString() {
    return 'LaunchInfo(latestOS: $latestOS, appVersion: $appVersion)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LaunchInfo &&
            (identical(other.latestOS, latestOS) ||
                const DeepCollectionEquality()
                    .equals(other.latestOS, latestOS)) &&
            (identical(other.appVersion, appVersion) ||
                const DeepCollectionEquality()
                    .equals(other.appVersion, appVersion)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(latestOS) ^
      const DeepCollectionEquality().hash(appVersion);

  @override
  _$LaunchInfoCopyWith<_LaunchInfo> get copyWith =>
      __$LaunchInfoCopyWithImpl<_LaunchInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LaunchInfoToJson(this);
  }
}

abstract class _LaunchInfo extends LaunchInfo {
  _LaunchInfo._() : super._();
  factory _LaunchInfo(
      {@required String latestOS, @required String appVersion}) = _$_LaunchInfo;

  factory _LaunchInfo.fromJson(Map<String, dynamic> json) =
      _$_LaunchInfo.fromJson;

  @override
  String get latestOS;
  @override
  String get appVersion;
  @override
  _$LaunchInfoCopyWith<_LaunchInfo> get copyWith;
}
