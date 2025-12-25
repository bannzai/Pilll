// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_parameter.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoteConfigParameter {

/// ペイウォール画面を最初に表示するかどうか
/// trueの場合、アプリ起動時にプレミアム機能の課金画面を先に表示する
 bool get isPaywallFirst;/// 初期設定画面をスキップするかどうか
/// trueの場合、新規ユーザーでも初期設定をバイパスしてメイン画面へ遷移
 bool get skipInitialSetting;/// トライアル期限日の基準日からのオフセット日数
/// ユーザー登録日からこの日数後にトライアル期限が設定される
 int get trialDeadlineDateOffsetDay;/// 割引プラン権利付与の基準日からのオフセット日数
/// ユーザー登録日からこの日数後に割引プランの権利が付与される
 int get discountEntitlementOffsetDay;/// 割引カウントダウン表示の境界時間（時間単位）
/// この時間以内になったら割引期限のカウントダウンを表示する
 int get discountCountdownBoundaryHour;/// プレミアム機能紹介パターンの識別子
/// A/Bテスト用のパターン識別子（'default', 'A', 'B'等）
 String get premiumIntroductionPattern;/// プレミアム紹介画面でApp Storeレビューカードを表示するか
/// trueの場合、プレミアム機能紹介時にレビュー促進カードも表示
 bool get premiumIntroductionShowsAppStoreReviewCard;/// 特別オファー対象ユーザー作成日時の基準オフセット値（分単位）
/// ユーザー登録からこの分数経過したユーザーが特別オファーの対象となる
 int get specialOfferingUserCreationDateTimeOffset;/// 特別オファー開始の基準オフセット値（分単位）
/// 特別オファーの表示開始タイミングを制御する
 int get specialOfferingUserCreationDateTimeOffsetSince;/// 特別オファー終了の基準オフセット値（分単位）
/// 特別オファーの表示終了タイミングを制御する
 int get specialOfferingUserCreationDateTimeOffsetUntil;/// 特別オファー2で代替テキストを使用するかどうか
/// trueの場合、特別オファー2画面で異なるテキスト表現を使用する
 bool get specialOffering2UseAlternativeText;
/// Create a copy of RemoteConfigParameter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteConfigParameterCopyWith<RemoteConfigParameter> get copyWith => _$RemoteConfigParameterCopyWithImpl<RemoteConfigParameter>(this as RemoteConfigParameter, _$identity);

  /// Serializes this RemoteConfigParameter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteConfigParameter&&(identical(other.isPaywallFirst, isPaywallFirst) || other.isPaywallFirst == isPaywallFirst)&&(identical(other.skipInitialSetting, skipInitialSetting) || other.skipInitialSetting == skipInitialSetting)&&(identical(other.trialDeadlineDateOffsetDay, trialDeadlineDateOffsetDay) || other.trialDeadlineDateOffsetDay == trialDeadlineDateOffsetDay)&&(identical(other.discountEntitlementOffsetDay, discountEntitlementOffsetDay) || other.discountEntitlementOffsetDay == discountEntitlementOffsetDay)&&(identical(other.discountCountdownBoundaryHour, discountCountdownBoundaryHour) || other.discountCountdownBoundaryHour == discountCountdownBoundaryHour)&&(identical(other.premiumIntroductionPattern, premiumIntroductionPattern) || other.premiumIntroductionPattern == premiumIntroductionPattern)&&(identical(other.premiumIntroductionShowsAppStoreReviewCard, premiumIntroductionShowsAppStoreReviewCard) || other.premiumIntroductionShowsAppStoreReviewCard == premiumIntroductionShowsAppStoreReviewCard)&&(identical(other.specialOfferingUserCreationDateTimeOffset, specialOfferingUserCreationDateTimeOffset) || other.specialOfferingUserCreationDateTimeOffset == specialOfferingUserCreationDateTimeOffset)&&(identical(other.specialOfferingUserCreationDateTimeOffsetSince, specialOfferingUserCreationDateTimeOffsetSince) || other.specialOfferingUserCreationDateTimeOffsetSince == specialOfferingUserCreationDateTimeOffsetSince)&&(identical(other.specialOfferingUserCreationDateTimeOffsetUntil, specialOfferingUserCreationDateTimeOffsetUntil) || other.specialOfferingUserCreationDateTimeOffsetUntil == specialOfferingUserCreationDateTimeOffsetUntil)&&(identical(other.specialOffering2UseAlternativeText, specialOffering2UseAlternativeText) || other.specialOffering2UseAlternativeText == specialOffering2UseAlternativeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPaywallFirst,skipInitialSetting,trialDeadlineDateOffsetDay,discountEntitlementOffsetDay,discountCountdownBoundaryHour,premiumIntroductionPattern,premiumIntroductionShowsAppStoreReviewCard,specialOfferingUserCreationDateTimeOffset,specialOfferingUserCreationDateTimeOffsetSince,specialOfferingUserCreationDateTimeOffsetUntil,specialOffering2UseAlternativeText);

@override
String toString() {
  return 'RemoteConfigParameter(isPaywallFirst: $isPaywallFirst, skipInitialSetting: $skipInitialSetting, trialDeadlineDateOffsetDay: $trialDeadlineDateOffsetDay, discountEntitlementOffsetDay: $discountEntitlementOffsetDay, discountCountdownBoundaryHour: $discountCountdownBoundaryHour, premiumIntroductionPattern: $premiumIntroductionPattern, premiumIntroductionShowsAppStoreReviewCard: $premiumIntroductionShowsAppStoreReviewCard, specialOfferingUserCreationDateTimeOffset: $specialOfferingUserCreationDateTimeOffset, specialOfferingUserCreationDateTimeOffsetSince: $specialOfferingUserCreationDateTimeOffsetSince, specialOfferingUserCreationDateTimeOffsetUntil: $specialOfferingUserCreationDateTimeOffsetUntil, specialOffering2UseAlternativeText: $specialOffering2UseAlternativeText)';
}


}

/// @nodoc
abstract mixin class $RemoteConfigParameterCopyWith<$Res>  {
  factory $RemoteConfigParameterCopyWith(RemoteConfigParameter value, $Res Function(RemoteConfigParameter) _then) = _$RemoteConfigParameterCopyWithImpl;
@useResult
$Res call({
 bool isPaywallFirst, bool skipInitialSetting, int trialDeadlineDateOffsetDay, int discountEntitlementOffsetDay, int discountCountdownBoundaryHour, String premiumIntroductionPattern, bool premiumIntroductionShowsAppStoreReviewCard, int specialOfferingUserCreationDateTimeOffset, int specialOfferingUserCreationDateTimeOffsetSince, int specialOfferingUserCreationDateTimeOffsetUntil, bool specialOffering2UseAlternativeText
});




}
/// @nodoc
class _$RemoteConfigParameterCopyWithImpl<$Res>
    implements $RemoteConfigParameterCopyWith<$Res> {
  _$RemoteConfigParameterCopyWithImpl(this._self, this._then);

  final RemoteConfigParameter _self;
  final $Res Function(RemoteConfigParameter) _then;

/// Create a copy of RemoteConfigParameter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPaywallFirst = null,Object? skipInitialSetting = null,Object? trialDeadlineDateOffsetDay = null,Object? discountEntitlementOffsetDay = null,Object? discountCountdownBoundaryHour = null,Object? premiumIntroductionPattern = null,Object? premiumIntroductionShowsAppStoreReviewCard = null,Object? specialOfferingUserCreationDateTimeOffset = null,Object? specialOfferingUserCreationDateTimeOffsetSince = null,Object? specialOfferingUserCreationDateTimeOffsetUntil = null,Object? specialOffering2UseAlternativeText = null,}) {
  return _then(_self.copyWith(
isPaywallFirst: null == isPaywallFirst ? _self.isPaywallFirst : isPaywallFirst // ignore: cast_nullable_to_non_nullable
as bool,skipInitialSetting: null == skipInitialSetting ? _self.skipInitialSetting : skipInitialSetting // ignore: cast_nullable_to_non_nullable
as bool,trialDeadlineDateOffsetDay: null == trialDeadlineDateOffsetDay ? _self.trialDeadlineDateOffsetDay : trialDeadlineDateOffsetDay // ignore: cast_nullable_to_non_nullable
as int,discountEntitlementOffsetDay: null == discountEntitlementOffsetDay ? _self.discountEntitlementOffsetDay : discountEntitlementOffsetDay // ignore: cast_nullable_to_non_nullable
as int,discountCountdownBoundaryHour: null == discountCountdownBoundaryHour ? _self.discountCountdownBoundaryHour : discountCountdownBoundaryHour // ignore: cast_nullable_to_non_nullable
as int,premiumIntroductionPattern: null == premiumIntroductionPattern ? _self.premiumIntroductionPattern : premiumIntroductionPattern // ignore: cast_nullable_to_non_nullable
as String,premiumIntroductionShowsAppStoreReviewCard: null == premiumIntroductionShowsAppStoreReviewCard ? _self.premiumIntroductionShowsAppStoreReviewCard : premiumIntroductionShowsAppStoreReviewCard // ignore: cast_nullable_to_non_nullable
as bool,specialOfferingUserCreationDateTimeOffset: null == specialOfferingUserCreationDateTimeOffset ? _self.specialOfferingUserCreationDateTimeOffset : specialOfferingUserCreationDateTimeOffset // ignore: cast_nullable_to_non_nullable
as int,specialOfferingUserCreationDateTimeOffsetSince: null == specialOfferingUserCreationDateTimeOffsetSince ? _self.specialOfferingUserCreationDateTimeOffsetSince : specialOfferingUserCreationDateTimeOffsetSince // ignore: cast_nullable_to_non_nullable
as int,specialOfferingUserCreationDateTimeOffsetUntil: null == specialOfferingUserCreationDateTimeOffsetUntil ? _self.specialOfferingUserCreationDateTimeOffsetUntil : specialOfferingUserCreationDateTimeOffsetUntil // ignore: cast_nullable_to_non_nullable
as int,specialOffering2UseAlternativeText: null == specialOffering2UseAlternativeText ? _self.specialOffering2UseAlternativeText : specialOffering2UseAlternativeText // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteConfigParameter].
extension RemoteConfigParameterPatterns on RemoteConfigParameter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteConfigParameter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteConfigParameter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteConfigParameter value)  $default,){
final _that = this;
switch (_that) {
case _RemoteConfigParameter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteConfigParameter value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteConfigParameter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPaywallFirst,  bool skipInitialSetting,  int trialDeadlineDateOffsetDay,  int discountEntitlementOffsetDay,  int discountCountdownBoundaryHour,  String premiumIntroductionPattern,  bool premiumIntroductionShowsAppStoreReviewCard,  int specialOfferingUserCreationDateTimeOffset,  int specialOfferingUserCreationDateTimeOffsetSince,  int specialOfferingUserCreationDateTimeOffsetUntil,  bool specialOffering2UseAlternativeText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteConfigParameter() when $default != null:
return $default(_that.isPaywallFirst,_that.skipInitialSetting,_that.trialDeadlineDateOffsetDay,_that.discountEntitlementOffsetDay,_that.discountCountdownBoundaryHour,_that.premiumIntroductionPattern,_that.premiumIntroductionShowsAppStoreReviewCard,_that.specialOfferingUserCreationDateTimeOffset,_that.specialOfferingUserCreationDateTimeOffsetSince,_that.specialOfferingUserCreationDateTimeOffsetUntil,_that.specialOffering2UseAlternativeText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPaywallFirst,  bool skipInitialSetting,  int trialDeadlineDateOffsetDay,  int discountEntitlementOffsetDay,  int discountCountdownBoundaryHour,  String premiumIntroductionPattern,  bool premiumIntroductionShowsAppStoreReviewCard,  int specialOfferingUserCreationDateTimeOffset,  int specialOfferingUserCreationDateTimeOffsetSince,  int specialOfferingUserCreationDateTimeOffsetUntil,  bool specialOffering2UseAlternativeText)  $default,) {final _that = this;
switch (_that) {
case _RemoteConfigParameter():
return $default(_that.isPaywallFirst,_that.skipInitialSetting,_that.trialDeadlineDateOffsetDay,_that.discountEntitlementOffsetDay,_that.discountCountdownBoundaryHour,_that.premiumIntroductionPattern,_that.premiumIntroductionShowsAppStoreReviewCard,_that.specialOfferingUserCreationDateTimeOffset,_that.specialOfferingUserCreationDateTimeOffsetSince,_that.specialOfferingUserCreationDateTimeOffsetUntil,_that.specialOffering2UseAlternativeText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPaywallFirst,  bool skipInitialSetting,  int trialDeadlineDateOffsetDay,  int discountEntitlementOffsetDay,  int discountCountdownBoundaryHour,  String premiumIntroductionPattern,  bool premiumIntroductionShowsAppStoreReviewCard,  int specialOfferingUserCreationDateTimeOffset,  int specialOfferingUserCreationDateTimeOffsetSince,  int specialOfferingUserCreationDateTimeOffsetUntil,  bool specialOffering2UseAlternativeText)?  $default,) {final _that = this;
switch (_that) {
case _RemoteConfigParameter() when $default != null:
return $default(_that.isPaywallFirst,_that.skipInitialSetting,_that.trialDeadlineDateOffsetDay,_that.discountEntitlementOffsetDay,_that.discountCountdownBoundaryHour,_that.premiumIntroductionPattern,_that.premiumIntroductionShowsAppStoreReviewCard,_that.specialOfferingUserCreationDateTimeOffset,_that.specialOfferingUserCreationDateTimeOffsetSince,_that.specialOfferingUserCreationDateTimeOffsetUntil,_that.specialOffering2UseAlternativeText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RemoteConfigParameter extends RemoteConfigParameter {
   _RemoteConfigParameter({this.isPaywallFirst = RemoteConfigParameterDefaultValues.isPaywallFirst, this.skipInitialSetting = RemoteConfigParameterDefaultValues.skipInitialSetting, this.trialDeadlineDateOffsetDay = RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay, this.discountEntitlementOffsetDay = RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay, this.discountCountdownBoundaryHour = RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour, this.premiumIntroductionPattern = RemoteConfigParameterDefaultValues.premiumIntroductionPattern, this.premiumIntroductionShowsAppStoreReviewCard = RemoteConfigParameterDefaultValues.premiumIntroductionShowsAppStoreReviewCard, this.specialOfferingUserCreationDateTimeOffset = RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffset, this.specialOfferingUserCreationDateTimeOffsetSince = RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetSince, this.specialOfferingUserCreationDateTimeOffsetUntil = RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetUntil, this.specialOffering2UseAlternativeText = RemoteConfigParameterDefaultValues.specialOffering2UseAlternativeText}): super._();
  factory _RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);

/// ペイウォール画面を最初に表示するかどうか
/// trueの場合、アプリ起動時にプレミアム機能の課金画面を先に表示する
@override@JsonKey() final  bool isPaywallFirst;
/// 初期設定画面をスキップするかどうか
/// trueの場合、新規ユーザーでも初期設定をバイパスしてメイン画面へ遷移
@override@JsonKey() final  bool skipInitialSetting;
/// トライアル期限日の基準日からのオフセット日数
/// ユーザー登録日からこの日数後にトライアル期限が設定される
@override@JsonKey() final  int trialDeadlineDateOffsetDay;
/// 割引プラン権利付与の基準日からのオフセット日数
/// ユーザー登録日からこの日数後に割引プランの権利が付与される
@override@JsonKey() final  int discountEntitlementOffsetDay;
/// 割引カウントダウン表示の境界時間（時間単位）
/// この時間以内になったら割引期限のカウントダウンを表示する
@override@JsonKey() final  int discountCountdownBoundaryHour;
/// プレミアム機能紹介パターンの識別子
/// A/Bテスト用のパターン識別子（'default', 'A', 'B'等）
@override@JsonKey() final  String premiumIntroductionPattern;
/// プレミアム紹介画面でApp Storeレビューカードを表示するか
/// trueの場合、プレミアム機能紹介時にレビュー促進カードも表示
@override@JsonKey() final  bool premiumIntroductionShowsAppStoreReviewCard;
/// 特別オファー対象ユーザー作成日時の基準オフセット値（分単位）
/// ユーザー登録からこの分数経過したユーザーが特別オファーの対象となる
@override@JsonKey() final  int specialOfferingUserCreationDateTimeOffset;
/// 特別オファー開始の基準オフセット値（分単位）
/// 特別オファーの表示開始タイミングを制御する
@override@JsonKey() final  int specialOfferingUserCreationDateTimeOffsetSince;
/// 特別オファー終了の基準オフセット値（分単位）
/// 特別オファーの表示終了タイミングを制御する
@override@JsonKey() final  int specialOfferingUserCreationDateTimeOffsetUntil;
/// 特別オファー2で代替テキストを使用するかどうか
/// trueの場合、特別オファー2画面で異なるテキスト表現を使用する
@override@JsonKey() final  bool specialOffering2UseAlternativeText;

/// Create a copy of RemoteConfigParameter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteConfigParameterCopyWith<_RemoteConfigParameter> get copyWith => __$RemoteConfigParameterCopyWithImpl<_RemoteConfigParameter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RemoteConfigParameterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteConfigParameter&&(identical(other.isPaywallFirst, isPaywallFirst) || other.isPaywallFirst == isPaywallFirst)&&(identical(other.skipInitialSetting, skipInitialSetting) || other.skipInitialSetting == skipInitialSetting)&&(identical(other.trialDeadlineDateOffsetDay, trialDeadlineDateOffsetDay) || other.trialDeadlineDateOffsetDay == trialDeadlineDateOffsetDay)&&(identical(other.discountEntitlementOffsetDay, discountEntitlementOffsetDay) || other.discountEntitlementOffsetDay == discountEntitlementOffsetDay)&&(identical(other.discountCountdownBoundaryHour, discountCountdownBoundaryHour) || other.discountCountdownBoundaryHour == discountCountdownBoundaryHour)&&(identical(other.premiumIntroductionPattern, premiumIntroductionPattern) || other.premiumIntroductionPattern == premiumIntroductionPattern)&&(identical(other.premiumIntroductionShowsAppStoreReviewCard, premiumIntroductionShowsAppStoreReviewCard) || other.premiumIntroductionShowsAppStoreReviewCard == premiumIntroductionShowsAppStoreReviewCard)&&(identical(other.specialOfferingUserCreationDateTimeOffset, specialOfferingUserCreationDateTimeOffset) || other.specialOfferingUserCreationDateTimeOffset == specialOfferingUserCreationDateTimeOffset)&&(identical(other.specialOfferingUserCreationDateTimeOffsetSince, specialOfferingUserCreationDateTimeOffsetSince) || other.specialOfferingUserCreationDateTimeOffsetSince == specialOfferingUserCreationDateTimeOffsetSince)&&(identical(other.specialOfferingUserCreationDateTimeOffsetUntil, specialOfferingUserCreationDateTimeOffsetUntil) || other.specialOfferingUserCreationDateTimeOffsetUntil == specialOfferingUserCreationDateTimeOffsetUntil)&&(identical(other.specialOffering2UseAlternativeText, specialOffering2UseAlternativeText) || other.specialOffering2UseAlternativeText == specialOffering2UseAlternativeText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPaywallFirst,skipInitialSetting,trialDeadlineDateOffsetDay,discountEntitlementOffsetDay,discountCountdownBoundaryHour,premiumIntroductionPattern,premiumIntroductionShowsAppStoreReviewCard,specialOfferingUserCreationDateTimeOffset,specialOfferingUserCreationDateTimeOffsetSince,specialOfferingUserCreationDateTimeOffsetUntil,specialOffering2UseAlternativeText);

@override
String toString() {
  return 'RemoteConfigParameter(isPaywallFirst: $isPaywallFirst, skipInitialSetting: $skipInitialSetting, trialDeadlineDateOffsetDay: $trialDeadlineDateOffsetDay, discountEntitlementOffsetDay: $discountEntitlementOffsetDay, discountCountdownBoundaryHour: $discountCountdownBoundaryHour, premiumIntroductionPattern: $premiumIntroductionPattern, premiumIntroductionShowsAppStoreReviewCard: $premiumIntroductionShowsAppStoreReviewCard, specialOfferingUserCreationDateTimeOffset: $specialOfferingUserCreationDateTimeOffset, specialOfferingUserCreationDateTimeOffsetSince: $specialOfferingUserCreationDateTimeOffsetSince, specialOfferingUserCreationDateTimeOffsetUntil: $specialOfferingUserCreationDateTimeOffsetUntil, specialOffering2UseAlternativeText: $specialOffering2UseAlternativeText)';
}


}

/// @nodoc
abstract mixin class _$RemoteConfigParameterCopyWith<$Res> implements $RemoteConfigParameterCopyWith<$Res> {
  factory _$RemoteConfigParameterCopyWith(_RemoteConfigParameter value, $Res Function(_RemoteConfigParameter) _then) = __$RemoteConfigParameterCopyWithImpl;
@override @useResult
$Res call({
 bool isPaywallFirst, bool skipInitialSetting, int trialDeadlineDateOffsetDay, int discountEntitlementOffsetDay, int discountCountdownBoundaryHour, String premiumIntroductionPattern, bool premiumIntroductionShowsAppStoreReviewCard, int specialOfferingUserCreationDateTimeOffset, int specialOfferingUserCreationDateTimeOffsetSince, int specialOfferingUserCreationDateTimeOffsetUntil, bool specialOffering2UseAlternativeText
});




}
/// @nodoc
class __$RemoteConfigParameterCopyWithImpl<$Res>
    implements _$RemoteConfigParameterCopyWith<$Res> {
  __$RemoteConfigParameterCopyWithImpl(this._self, this._then);

  final _RemoteConfigParameter _self;
  final $Res Function(_RemoteConfigParameter) _then;

/// Create a copy of RemoteConfigParameter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPaywallFirst = null,Object? skipInitialSetting = null,Object? trialDeadlineDateOffsetDay = null,Object? discountEntitlementOffsetDay = null,Object? discountCountdownBoundaryHour = null,Object? premiumIntroductionPattern = null,Object? premiumIntroductionShowsAppStoreReviewCard = null,Object? specialOfferingUserCreationDateTimeOffset = null,Object? specialOfferingUserCreationDateTimeOffsetSince = null,Object? specialOfferingUserCreationDateTimeOffsetUntil = null,Object? specialOffering2UseAlternativeText = null,}) {
  return _then(_RemoteConfigParameter(
isPaywallFirst: null == isPaywallFirst ? _self.isPaywallFirst : isPaywallFirst // ignore: cast_nullable_to_non_nullable
as bool,skipInitialSetting: null == skipInitialSetting ? _self.skipInitialSetting : skipInitialSetting // ignore: cast_nullable_to_non_nullable
as bool,trialDeadlineDateOffsetDay: null == trialDeadlineDateOffsetDay ? _self.trialDeadlineDateOffsetDay : trialDeadlineDateOffsetDay // ignore: cast_nullable_to_non_nullable
as int,discountEntitlementOffsetDay: null == discountEntitlementOffsetDay ? _self.discountEntitlementOffsetDay : discountEntitlementOffsetDay // ignore: cast_nullable_to_non_nullable
as int,discountCountdownBoundaryHour: null == discountCountdownBoundaryHour ? _self.discountCountdownBoundaryHour : discountCountdownBoundaryHour // ignore: cast_nullable_to_non_nullable
as int,premiumIntroductionPattern: null == premiumIntroductionPattern ? _self.premiumIntroductionPattern : premiumIntroductionPattern // ignore: cast_nullable_to_non_nullable
as String,premiumIntroductionShowsAppStoreReviewCard: null == premiumIntroductionShowsAppStoreReviewCard ? _self.premiumIntroductionShowsAppStoreReviewCard : premiumIntroductionShowsAppStoreReviewCard // ignore: cast_nullable_to_non_nullable
as bool,specialOfferingUserCreationDateTimeOffset: null == specialOfferingUserCreationDateTimeOffset ? _self.specialOfferingUserCreationDateTimeOffset : specialOfferingUserCreationDateTimeOffset // ignore: cast_nullable_to_non_nullable
as int,specialOfferingUserCreationDateTimeOffsetSince: null == specialOfferingUserCreationDateTimeOffsetSince ? _self.specialOfferingUserCreationDateTimeOffsetSince : specialOfferingUserCreationDateTimeOffsetSince // ignore: cast_nullable_to_non_nullable
as int,specialOfferingUserCreationDateTimeOffsetUntil: null == specialOfferingUserCreationDateTimeOffsetUntil ? _self.specialOfferingUserCreationDateTimeOffsetUntil : specialOfferingUserCreationDateTimeOffsetUntil // ignore: cast_nullable_to_non_nullable
as int,specialOffering2UseAlternativeText: null == specialOffering2UseAlternativeText ? _self.specialOffering2UseAlternativeText : specialOffering2UseAlternativeText // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
