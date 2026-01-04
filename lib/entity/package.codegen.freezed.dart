// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Package _$PackageFromJson(Map<String, dynamic> json) {
  return _Package.fromJson(json);
}

/// @nodoc
mixin _$Package {
  /// 端末の最新OS種別
  ///
  /// Platform.operatingSystemから取得される値（"android", "ios"など）
  /// 端末のOS種別を識別するために使用される
  String get latestOS => throw _privateConstructorUsedError;

  /// アプリケーション名
  ///
  /// PackageInfo.fromPlatform().appNameから取得される値
  /// 通常は"Pilll"が設定される
  String get appName => throw _privateConstructorUsedError;

  /// アプリケーションのバージョン番号
  ///
  /// PackageInfo.fromPlatform().versionから取得される値
  /// アプリストアで公開されているバージョン番号（例: "2025.08.06"）
  String get appVersion => throw _privateConstructorUsedError;

  /// アプリケーションのビルド番号
  ///
  /// PackageInfo.fromPlatform().buildNumberから取得される値
  /// 開発時のビルド識別子として使用される
  String get buildNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PackageCopyWith<Package> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageCopyWith<$Res> {
  factory $PackageCopyWith(Package value, $Res Function(Package) then) =
      _$PackageCopyWithImpl<$Res, Package>;
  @useResult
  $Res call(
      {String latestOS, String appName, String appVersion, String buildNumber});
}

/// @nodoc
class _$PackageCopyWithImpl<$Res, $Val extends Package>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestOS = null,
    Object? appName = null,
    Object? appVersion = null,
    Object? buildNumber = null,
  }) {
    return _then(_value.copyWith(
      latestOS: null == latestOS
          ? _value.latestOS
          : latestOS // ignore: cast_nullable_to_non_nullable
              as String,
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PackageImplCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$$PackageImplCopyWith(
          _$PackageImpl value, $Res Function(_$PackageImpl) then) =
      __$$PackageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String latestOS, String appName, String appVersion, String buildNumber});
}

/// @nodoc
class __$$PackageImplCopyWithImpl<$Res>
    extends _$PackageCopyWithImpl<$Res, _$PackageImpl>
    implements _$$PackageImplCopyWith<$Res> {
  __$$PackageImplCopyWithImpl(
      _$PackageImpl _value, $Res Function(_$PackageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latestOS = null,
    Object? appName = null,
    Object? appVersion = null,
    Object? buildNumber = null,
  }) {
    return _then(_$PackageImpl(
      latestOS: null == latestOS
          ? _value.latestOS
          : latestOS // ignore: cast_nullable_to_non_nullable
              as String,
      appName: null == appName
          ? _value.appName
          : appName // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      buildNumber: null == buildNumber
          ? _value.buildNumber
          : buildNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$PackageImpl implements _Package {
  const _$PackageImpl(
      {required this.latestOS,
      required this.appName,
      required this.appVersion,
      required this.buildNumber});

  factory _$PackageImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageImplFromJson(json);

  /// 端末の最新OS種別
  ///
  /// Platform.operatingSystemから取得される値（"android", "ios"など）
  /// 端末のOS種別を識別するために使用される
  @override
  final String latestOS;

  /// アプリケーション名
  ///
  /// PackageInfo.fromPlatform().appNameから取得される値
  /// 通常は"Pilll"が設定される
  @override
  final String appName;

  /// アプリケーションのバージョン番号
  ///
  /// PackageInfo.fromPlatform().versionから取得される値
  /// アプリストアで公開されているバージョン番号（例: "2025.08.06"）
  @override
  final String appVersion;

  /// アプリケーションのビルド番号
  ///
  /// PackageInfo.fromPlatform().buildNumberから取得される値
  /// 開発時のビルド識別子として使用される
  @override
  final String buildNumber;

  @override
  String toString() {
    return 'Package(latestOS: $latestOS, appName: $appName, appVersion: $appVersion, buildNumber: $buildNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageImpl &&
            (identical(other.latestOS, latestOS) ||
                other.latestOS == latestOS) &&
            (identical(other.appName, appName) || other.appName == appName) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.buildNumber, buildNumber) ||
                other.buildNumber == buildNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, latestOS, appName, appVersion, buildNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      __$$PackageImplCopyWithImpl<_$PackageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageImplToJson(
      this,
    );
  }
}

abstract class _Package implements Package {
  const factory _Package(
      {required final String latestOS,
      required final String appName,
      required final String appVersion,
      required final String buildNumber}) = _$PackageImpl;

  factory _Package.fromJson(Map<String, dynamic> json) = _$PackageImpl.fromJson;

  @override

  /// 端末の最新OS種別
  ///
  /// Platform.operatingSystemから取得される値（"android", "ios"など）
  /// 端末のOS種別を識別するために使用される
  String get latestOS;
  @override

  /// アプリケーション名
  ///
  /// PackageInfo.fromPlatform().appNameから取得される値
  /// 通常は"Pilll"が設定される
  String get appName;
  @override

  /// アプリケーションのバージョン番号
  ///
  /// PackageInfo.fromPlatform().versionから取得される値
  /// アプリストアで公開されているバージョン番号（例: "2025.08.06"）
  String get appVersion;
  @override

  /// アプリケーションのビルド番号
  ///
  /// PackageInfo.fromPlatform().buildNumberから取得される値
  /// 開発時のビルド識別子として使用される
  String get buildNumber;
  @override
  @JsonKey(ignore: true)
  _$$PackageImplCopyWith<_$PackageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
