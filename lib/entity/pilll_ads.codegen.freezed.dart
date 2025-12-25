// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pilll_ads.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PilllAds {

/// 広告の表示開始日時
/// この時刻以降に広告が表示される
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get startDateTime;/// 広告の表示終了日時
/// この時刻以降は広告が表示されなくなる
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime get endDateTime;/// 広告のテキスト説明
/// バナーに表示される広告文言
 String get description;/// 広告画像のURL
/// nullの場合はテキストのみの広告として表示される
 String? get imageURL;/// 広告タップ時の遷移先URL
/// WebViewまたは外部ブラウザで開かれる
 String get destinationURL;/// 広告バナーの背景色
/// 16進数カラーコード（例: "FF0000"）
 String get hexColor;/// 閉じるボタンの色
/// 16進数カラーコード、デフォルトは白色
 String get closeButtonColor;/// 右向き矢印アイコンの色
/// 16進数カラーコード、デフォルトは白色
 String get chevronRightColor;
/// Create a copy of PilllAds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PilllAdsCopyWith<PilllAds> get copyWith => _$PilllAdsCopyWithImpl<PilllAds>(this as PilllAds, _$identity);

  /// Serializes this PilllAds to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PilllAds&&(identical(other.startDateTime, startDateTime) || other.startDateTime == startDateTime)&&(identical(other.endDateTime, endDateTime) || other.endDateTime == endDateTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageURL, imageURL) || other.imageURL == imageURL)&&(identical(other.destinationURL, destinationURL) || other.destinationURL == destinationURL)&&(identical(other.hexColor, hexColor) || other.hexColor == hexColor)&&(identical(other.closeButtonColor, closeButtonColor) || other.closeButtonColor == closeButtonColor)&&(identical(other.chevronRightColor, chevronRightColor) || other.chevronRightColor == chevronRightColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDateTime,endDateTime,description,imageURL,destinationURL,hexColor,closeButtonColor,chevronRightColor);

@override
String toString() {
  return 'PilllAds(startDateTime: $startDateTime, endDateTime: $endDateTime, description: $description, imageURL: $imageURL, destinationURL: $destinationURL, hexColor: $hexColor, closeButtonColor: $closeButtonColor, chevronRightColor: $chevronRightColor)';
}


}

/// @nodoc
abstract mixin class $PilllAdsCopyWith<$Res>  {
  factory $PilllAdsCopyWith(PilllAds value, $Res Function(PilllAds) _then) = _$PilllAdsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime startDateTime,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endDateTime, String description, String? imageURL, String destinationURL, String hexColor, String closeButtonColor, String chevronRightColor
});




}
/// @nodoc
class _$PilllAdsCopyWithImpl<$Res>
    implements $PilllAdsCopyWith<$Res> {
  _$PilllAdsCopyWithImpl(this._self, this._then);

  final PilllAds _self;
  final $Res Function(PilllAds) _then;

/// Create a copy of PilllAds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDateTime = null,Object? endDateTime = null,Object? description = null,Object? imageURL = freezed,Object? destinationURL = null,Object? hexColor = null,Object? closeButtonColor = null,Object? chevronRightColor = null,}) {
  return _then(_self.copyWith(
startDateTime: null == startDateTime ? _self.startDateTime : startDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,endDateTime: null == endDateTime ? _self.endDateTime : endDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageURL: freezed == imageURL ? _self.imageURL : imageURL // ignore: cast_nullable_to_non_nullable
as String?,destinationURL: null == destinationURL ? _self.destinationURL : destinationURL // ignore: cast_nullable_to_non_nullable
as String,hexColor: null == hexColor ? _self.hexColor : hexColor // ignore: cast_nullable_to_non_nullable
as String,closeButtonColor: null == closeButtonColor ? _self.closeButtonColor : closeButtonColor // ignore: cast_nullable_to_non_nullable
as String,chevronRightColor: null == chevronRightColor ? _self.chevronRightColor : chevronRightColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PilllAds].
extension PilllAdsPatterns on PilllAds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PilllAds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PilllAds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PilllAds value)  $default,){
final _that = this;
switch (_that) {
case _PilllAds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PilllAds value)?  $default,){
final _that = this;
switch (_that) {
case _PilllAds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime startDateTime, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endDateTime,  String description,  String? imageURL,  String destinationURL,  String hexColor,  String closeButtonColor,  String chevronRightColor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PilllAds() when $default != null:
return $default(_that.startDateTime,_that.endDateTime,_that.description,_that.imageURL,_that.destinationURL,_that.hexColor,_that.closeButtonColor,_that.chevronRightColor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime startDateTime, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endDateTime,  String description,  String? imageURL,  String destinationURL,  String hexColor,  String closeButtonColor,  String chevronRightColor)  $default,) {final _that = this;
switch (_that) {
case _PilllAds():
return $default(_that.startDateTime,_that.endDateTime,_that.description,_that.imageURL,_that.destinationURL,_that.hexColor,_that.closeButtonColor,_that.chevronRightColor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime startDateTime, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp)  DateTime endDateTime,  String description,  String? imageURL,  String destinationURL,  String hexColor,  String closeButtonColor,  String chevronRightColor)?  $default,) {final _that = this;
switch (_that) {
case _PilllAds() when $default != null:
return $default(_that.startDateTime,_that.endDateTime,_that.description,_that.imageURL,_that.destinationURL,_that.hexColor,_that.closeButtonColor,_that.chevronRightColor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PilllAds extends PilllAds {
   _PilllAds({@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.startDateTime, @JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) required this.endDateTime, required this.description, required this.imageURL, required this.destinationURL, required this.hexColor, this.closeButtonColor = 'FFFFFF', this.chevronRightColor = 'FFFFFF'}): super._();
  factory _PilllAds.fromJson(Map<String, dynamic> json) => _$PilllAdsFromJson(json);

/// 広告の表示開始日時
/// この時刻以降に広告が表示される
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime startDateTime;
/// 広告の表示終了日時
/// この時刻以降は広告が表示されなくなる
@override@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) final  DateTime endDateTime;
/// 広告のテキスト説明
/// バナーに表示される広告文言
@override final  String description;
/// 広告画像のURL
/// nullの場合はテキストのみの広告として表示される
@override final  String? imageURL;
/// 広告タップ時の遷移先URL
/// WebViewまたは外部ブラウザで開かれる
@override final  String destinationURL;
/// 広告バナーの背景色
/// 16進数カラーコード（例: "FF0000"）
@override final  String hexColor;
/// 閉じるボタンの色
/// 16進数カラーコード、デフォルトは白色
@override@JsonKey() final  String closeButtonColor;
/// 右向き矢印アイコンの色
/// 16進数カラーコード、デフォルトは白色
@override@JsonKey() final  String chevronRightColor;

/// Create a copy of PilllAds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PilllAdsCopyWith<_PilllAds> get copyWith => __$PilllAdsCopyWithImpl<_PilllAds>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PilllAdsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PilllAds&&(identical(other.startDateTime, startDateTime) || other.startDateTime == startDateTime)&&(identical(other.endDateTime, endDateTime) || other.endDateTime == endDateTime)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageURL, imageURL) || other.imageURL == imageURL)&&(identical(other.destinationURL, destinationURL) || other.destinationURL == destinationURL)&&(identical(other.hexColor, hexColor) || other.hexColor == hexColor)&&(identical(other.closeButtonColor, closeButtonColor) || other.closeButtonColor == closeButtonColor)&&(identical(other.chevronRightColor, chevronRightColor) || other.chevronRightColor == chevronRightColor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startDateTime,endDateTime,description,imageURL,destinationURL,hexColor,closeButtonColor,chevronRightColor);

@override
String toString() {
  return 'PilllAds(startDateTime: $startDateTime, endDateTime: $endDateTime, description: $description, imageURL: $imageURL, destinationURL: $destinationURL, hexColor: $hexColor, closeButtonColor: $closeButtonColor, chevronRightColor: $chevronRightColor)';
}


}

/// @nodoc
abstract mixin class _$PilllAdsCopyWith<$Res> implements $PilllAdsCopyWith<$Res> {
  factory _$PilllAdsCopyWith(_PilllAds value, $Res Function(_PilllAds) _then) = __$PilllAdsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime startDateTime,@JsonKey(fromJson: NonNullTimestampConverter.timestampToDateTime, toJson: NonNullTimestampConverter.dateTimeToTimestamp) DateTime endDateTime, String description, String? imageURL, String destinationURL, String hexColor, String closeButtonColor, String chevronRightColor
});




}
/// @nodoc
class __$PilllAdsCopyWithImpl<$Res>
    implements _$PilllAdsCopyWith<$Res> {
  __$PilllAdsCopyWithImpl(this._self, this._then);

  final _PilllAds _self;
  final $Res Function(_PilllAds) _then;

/// Create a copy of PilllAds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDateTime = null,Object? endDateTime = null,Object? description = null,Object? imageURL = freezed,Object? destinationURL = null,Object? hexColor = null,Object? closeButtonColor = null,Object? chevronRightColor = null,}) {
  return _then(_PilllAds(
startDateTime: null == startDateTime ? _self.startDateTime : startDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,endDateTime: null == endDateTime ? _self.endDateTime : endDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageURL: freezed == imageURL ? _self.imageURL : imageURL // ignore: cast_nullable_to_non_nullable
as String?,destinationURL: null == destinationURL ? _self.destinationURL : destinationURL // ignore: cast_nullable_to_non_nullable
as String,hexColor: null == hexColor ? _self.hexColor : hexColor // ignore: cast_nullable_to_non_nullable
as String,closeButtonColor: null == closeButtonColor ? _self.closeButtonColor : closeButtonColor // ignore: cast_nullable_to_non_nullable
as String,chevronRightColor: null == chevronRightColor ? _self.chevronRightColor : chevronRightColor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
