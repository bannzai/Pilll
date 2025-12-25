// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Package {

/// 端末の最新OS種別
///
/// Platform.operatingSystemから取得される値（"android", "ios"など）
/// 端末のOS種別を識別するために使用される
 String get latestOS;/// アプリケーション名
///
/// PackageInfo.fromPlatform().appNameから取得される値
/// 通常は"Pilll"が設定される
 String get appName;/// アプリケーションのバージョン番号
///
/// PackageInfo.fromPlatform().versionから取得される値
/// アプリストアで公開されているバージョン番号（例: "2025.08.06"）
 String get appVersion;/// アプリケーションのビルド番号
///
/// PackageInfo.fromPlatform().buildNumberから取得される値
/// 開発時のビルド識別子として使用される
 String get buildNumber;
/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackageCopyWith<Package> get copyWith => _$PackageCopyWithImpl<Package>(this as Package, _$identity);

  /// Serializes this Package to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Package&&(identical(other.latestOS, latestOS) || other.latestOS == latestOS)&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latestOS,appName,appVersion,buildNumber);

@override
String toString() {
  return 'Package(latestOS: $latestOS, appName: $appName, appVersion: $appVersion, buildNumber: $buildNumber)';
}


}

/// @nodoc
abstract mixin class $PackageCopyWith<$Res>  {
  factory $PackageCopyWith(Package value, $Res Function(Package) _then) = _$PackageCopyWithImpl;
@useResult
$Res call({
 String latestOS, String appName, String appVersion, String buildNumber
});




}
/// @nodoc
class _$PackageCopyWithImpl<$Res>
    implements $PackageCopyWith<$Res> {
  _$PackageCopyWithImpl(this._self, this._then);

  final Package _self;
  final $Res Function(Package) _then;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latestOS = null,Object? appName = null,Object? appVersion = null,Object? buildNumber = null,}) {
  return _then(_self.copyWith(
latestOS: null == latestOS ? _self.latestOS : latestOS // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Package].
extension PackagePatterns on Package {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Package value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Package value)  $default,){
final _that = this;
switch (_that) {
case _Package():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Package value)?  $default,){
final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String latestOS,  String appName,  String appVersion,  String buildNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that.latestOS,_that.appName,_that.appVersion,_that.buildNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String latestOS,  String appName,  String appVersion,  String buildNumber)  $default,) {final _that = this;
switch (_that) {
case _Package():
return $default(_that.latestOS,_that.appName,_that.appVersion,_that.buildNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String latestOS,  String appName,  String appVersion,  String buildNumber)?  $default,) {final _that = this;
switch (_that) {
case _Package() when $default != null:
return $default(_that.latestOS,_that.appName,_that.appVersion,_that.buildNumber);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Package implements Package {
  const _Package({required this.latestOS, required this.appName, required this.appVersion, required this.buildNumber});
  factory _Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);

/// 端末の最新OS種別
///
/// Platform.operatingSystemから取得される値（"android", "ios"など）
/// 端末のOS種別を識別するために使用される
@override final  String latestOS;
/// アプリケーション名
///
/// PackageInfo.fromPlatform().appNameから取得される値
/// 通常は"Pilll"が設定される
@override final  String appName;
/// アプリケーションのバージョン番号
///
/// PackageInfo.fromPlatform().versionから取得される値
/// アプリストアで公開されているバージョン番号（例: "2025.08.06"）
@override final  String appVersion;
/// アプリケーションのビルド番号
///
/// PackageInfo.fromPlatform().buildNumberから取得される値
/// 開発時のビルド識別子として使用される
@override final  String buildNumber;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackageCopyWith<_Package> get copyWith => __$PackageCopyWithImpl<_Package>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PackageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Package&&(identical(other.latestOS, latestOS) || other.latestOS == latestOS)&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,latestOS,appName,appVersion,buildNumber);

@override
String toString() {
  return 'Package(latestOS: $latestOS, appName: $appName, appVersion: $appVersion, buildNumber: $buildNumber)';
}


}

/// @nodoc
abstract mixin class _$PackageCopyWith<$Res> implements $PackageCopyWith<$Res> {
  factory _$PackageCopyWith(_Package value, $Res Function(_Package) _then) = __$PackageCopyWithImpl;
@override @useResult
$Res call({
 String latestOS, String appName, String appVersion, String buildNumber
});




}
/// @nodoc
class __$PackageCopyWithImpl<$Res>
    implements _$PackageCopyWith<$Res> {
  __$PackageCopyWithImpl(this._self, this._then);

  final _Package _self;
  final $Res Function(_Package) _then;

/// Create a copy of Package
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latestOS = null,Object? appName = null,Object? appVersion = null,Object? buildNumber = null,}) {
  return _then(_Package(
latestOS: null == latestOS ? _self.latestOS : latestOS // ignore: cast_nullable_to_non_nullable
as String,appName: null == appName ? _self.appName : appName // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
