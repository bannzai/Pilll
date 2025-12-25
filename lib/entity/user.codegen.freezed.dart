// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

/// ユーザーID（FirebaseのUID）
 String? get id;/// ユーザー設定情報（Settingエンティティのネストオブジェクト）
@JsonKey(name: 'settings') Setting? get setting;/// ユーザー作成時のユーザーID（履歴管理・デバッグ用）
 String? get userIDWhenCreateUser;/// 匿名ユーザーID（匿名ユーザー統合用）
 String? get anonymousUserID;/// 統合されたユーザードキュメントIDのリスト
 List<String> get userDocumentIDSets;/// 統合された匿名ユーザーIDのリスト
 List<String> get anonymousUserIDSets;/// 統合されたFirebaseCurrentUserIDのリスト
 List<String> get firebaseCurrentUserIDSets;/// プレミアム会員フラグ（サブスクリプション有効状態）
 bool get isPremium;/// 解約理由を聞くかどうかのフラグ
 bool get shouldAskCancelReason;/// アナリティクスのデバッグ機能有効フラグ
 bool get analyticsDebugIsEnabled;/// トライアル開始日（初回トライアル開始時にセット）
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get beginTrialDate;/// トライアル期限日（トライアル期間の終了日時）
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get trialDeadlineDate;/// 割引プラン利用期限日（トライアル終了後の割引期間終了日時）
/// 初期設定未完了または古いバージョンのアプリではnullの場合がある
@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? get discountEntitlementDeadlineDate;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.userIDWhenCreateUser, userIDWhenCreateUser) || other.userIDWhenCreateUser == userIDWhenCreateUser)&&(identical(other.anonymousUserID, anonymousUserID) || other.anonymousUserID == anonymousUserID)&&const DeepCollectionEquality().equals(other.userDocumentIDSets, userDocumentIDSets)&&const DeepCollectionEquality().equals(other.anonymousUserIDSets, anonymousUserIDSets)&&const DeepCollectionEquality().equals(other.firebaseCurrentUserIDSets, firebaseCurrentUserIDSets)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.shouldAskCancelReason, shouldAskCancelReason) || other.shouldAskCancelReason == shouldAskCancelReason)&&(identical(other.analyticsDebugIsEnabled, analyticsDebugIsEnabled) || other.analyticsDebugIsEnabled == analyticsDebugIsEnabled)&&(identical(other.beginTrialDate, beginTrialDate) || other.beginTrialDate == beginTrialDate)&&(identical(other.trialDeadlineDate, trialDeadlineDate) || other.trialDeadlineDate == trialDeadlineDate)&&(identical(other.discountEntitlementDeadlineDate, discountEntitlementDeadlineDate) || other.discountEntitlementDeadlineDate == discountEntitlementDeadlineDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,setting,userIDWhenCreateUser,anonymousUserID,const DeepCollectionEquality().hash(userDocumentIDSets),const DeepCollectionEquality().hash(anonymousUserIDSets),const DeepCollectionEquality().hash(firebaseCurrentUserIDSets),isPremium,shouldAskCancelReason,analyticsDebugIsEnabled,beginTrialDate,trialDeadlineDate,discountEntitlementDeadlineDate);

@override
String toString() {
  return 'User(id: $id, setting: $setting, userIDWhenCreateUser: $userIDWhenCreateUser, anonymousUserID: $anonymousUserID, userDocumentIDSets: $userDocumentIDSets, anonymousUserIDSets: $anonymousUserIDSets, firebaseCurrentUserIDSets: $firebaseCurrentUserIDSets, isPremium: $isPremium, shouldAskCancelReason: $shouldAskCancelReason, analyticsDebugIsEnabled: $analyticsDebugIsEnabled, beginTrialDate: $beginTrialDate, trialDeadlineDate: $trialDeadlineDate, discountEntitlementDeadlineDate: $discountEntitlementDeadlineDate)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String? id,@JsonKey(name: 'settings') Setting? setting, String? userIDWhenCreateUser, String? anonymousUserID, List<String> userDocumentIDSets, List<String> anonymousUserIDSets, List<String> firebaseCurrentUserIDSets, bool isPremium, bool shouldAskCancelReason, bool analyticsDebugIsEnabled,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beginTrialDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? trialDeadlineDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? discountEntitlementDeadlineDate
});


$SettingCopyWith<$Res>? get setting;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? setting = freezed,Object? userIDWhenCreateUser = freezed,Object? anonymousUserID = freezed,Object? userDocumentIDSets = null,Object? anonymousUserIDSets = null,Object? firebaseCurrentUserIDSets = null,Object? isPremium = null,Object? shouldAskCancelReason = null,Object? analyticsDebugIsEnabled = null,Object? beginTrialDate = freezed,Object? trialDeadlineDate = freezed,Object? discountEntitlementDeadlineDate = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,setting: freezed == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as Setting?,userIDWhenCreateUser: freezed == userIDWhenCreateUser ? _self.userIDWhenCreateUser : userIDWhenCreateUser // ignore: cast_nullable_to_non_nullable
as String?,anonymousUserID: freezed == anonymousUserID ? _self.anonymousUserID : anonymousUserID // ignore: cast_nullable_to_non_nullable
as String?,userDocumentIDSets: null == userDocumentIDSets ? _self.userDocumentIDSets : userDocumentIDSets // ignore: cast_nullable_to_non_nullable
as List<String>,anonymousUserIDSets: null == anonymousUserIDSets ? _self.anonymousUserIDSets : anonymousUserIDSets // ignore: cast_nullable_to_non_nullable
as List<String>,firebaseCurrentUserIDSets: null == firebaseCurrentUserIDSets ? _self.firebaseCurrentUserIDSets : firebaseCurrentUserIDSets // ignore: cast_nullable_to_non_nullable
as List<String>,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,shouldAskCancelReason: null == shouldAskCancelReason ? _self.shouldAskCancelReason : shouldAskCancelReason // ignore: cast_nullable_to_non_nullable
as bool,analyticsDebugIsEnabled: null == analyticsDebugIsEnabled ? _self.analyticsDebugIsEnabled : analyticsDebugIsEnabled // ignore: cast_nullable_to_non_nullable
as bool,beginTrialDate: freezed == beginTrialDate ? _self.beginTrialDate : beginTrialDate // ignore: cast_nullable_to_non_nullable
as DateTime?,trialDeadlineDate: freezed == trialDeadlineDate ? _self.trialDeadlineDate : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
as DateTime?,discountEntitlementDeadlineDate: freezed == discountEntitlementDeadlineDate ? _self.discountEntitlementDeadlineDate : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingCopyWith<$Res>? get setting {
    if (_self.setting == null) {
    return null;
  }

  return $SettingCopyWith<$Res>(_self.setting!, (value) {
    return _then(_self.copyWith(setting: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'settings')  Setting? setting,  String? userIDWhenCreateUser,  String? anonymousUserID,  List<String> userDocumentIDSets,  List<String> anonymousUserIDSets,  List<String> firebaseCurrentUserIDSets,  bool isPremium,  bool shouldAskCancelReason,  bool analyticsDebugIsEnabled, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beginTrialDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? trialDeadlineDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? discountEntitlementDeadlineDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.setting,_that.userIDWhenCreateUser,_that.anonymousUserID,_that.userDocumentIDSets,_that.anonymousUserIDSets,_that.firebaseCurrentUserIDSets,_that.isPremium,_that.shouldAskCancelReason,_that.analyticsDebugIsEnabled,_that.beginTrialDate,_that.trialDeadlineDate,_that.discountEntitlementDeadlineDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id, @JsonKey(name: 'settings')  Setting? setting,  String? userIDWhenCreateUser,  String? anonymousUserID,  List<String> userDocumentIDSets,  List<String> anonymousUserIDSets,  List<String> firebaseCurrentUserIDSets,  bool isPremium,  bool shouldAskCancelReason,  bool analyticsDebugIsEnabled, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beginTrialDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? trialDeadlineDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? discountEntitlementDeadlineDate)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.setting,_that.userIDWhenCreateUser,_that.anonymousUserID,_that.userDocumentIDSets,_that.anonymousUserIDSets,_that.firebaseCurrentUserIDSets,_that.isPremium,_that.shouldAskCancelReason,_that.analyticsDebugIsEnabled,_that.beginTrialDate,_that.trialDeadlineDate,_that.discountEntitlementDeadlineDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id, @JsonKey(name: 'settings')  Setting? setting,  String? userIDWhenCreateUser,  String? anonymousUserID,  List<String> userDocumentIDSets,  List<String> anonymousUserIDSets,  List<String> firebaseCurrentUserIDSets,  bool isPremium,  bool shouldAskCancelReason,  bool analyticsDebugIsEnabled, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? beginTrialDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? trialDeadlineDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)  DateTime? discountEntitlementDeadlineDate)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.setting,_that.userIDWhenCreateUser,_that.anonymousUserID,_that.userDocumentIDSets,_that.anonymousUserIDSets,_that.firebaseCurrentUserIDSets,_that.isPremium,_that.shouldAskCancelReason,_that.analyticsDebugIsEnabled,_that.beginTrialDate,_that.trialDeadlineDate,_that.discountEntitlementDeadlineDate);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _User extends User {
  const _User({this.id, @JsonKey(name: 'settings') this.setting, this.userIDWhenCreateUser, this.anonymousUserID, final  List<String> userDocumentIDSets = const [], final  List<String> anonymousUserIDSets = const [], final  List<String> firebaseCurrentUserIDSets = const [], this.isPremium = false, this.shouldAskCancelReason = false, this.analyticsDebugIsEnabled = false, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.beginTrialDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.trialDeadlineDate, @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.discountEntitlementDeadlineDate}): _userDocumentIDSets = userDocumentIDSets,_anonymousUserIDSets = anonymousUserIDSets,_firebaseCurrentUserIDSets = firebaseCurrentUserIDSets,super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

/// ユーザーID（FirebaseのUID）
@override final  String? id;
/// ユーザー設定情報（Settingエンティティのネストオブジェクト）
@override@JsonKey(name: 'settings') final  Setting? setting;
/// ユーザー作成時のユーザーID（履歴管理・デバッグ用）
@override final  String? userIDWhenCreateUser;
/// 匿名ユーザーID（匿名ユーザー統合用）
@override final  String? anonymousUserID;
/// 統合されたユーザードキュメントIDのリスト
 final  List<String> _userDocumentIDSets;
/// 統合されたユーザードキュメントIDのリスト
@override@JsonKey() List<String> get userDocumentIDSets {
  if (_userDocumentIDSets is EqualUnmodifiableListView) return _userDocumentIDSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userDocumentIDSets);
}

/// 統合された匿名ユーザーIDのリスト
 final  List<String> _anonymousUserIDSets;
/// 統合された匿名ユーザーIDのリスト
@override@JsonKey() List<String> get anonymousUserIDSets {
  if (_anonymousUserIDSets is EqualUnmodifiableListView) return _anonymousUserIDSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_anonymousUserIDSets);
}

/// 統合されたFirebaseCurrentUserIDのリスト
 final  List<String> _firebaseCurrentUserIDSets;
/// 統合されたFirebaseCurrentUserIDのリスト
@override@JsonKey() List<String> get firebaseCurrentUserIDSets {
  if (_firebaseCurrentUserIDSets is EqualUnmodifiableListView) return _firebaseCurrentUserIDSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_firebaseCurrentUserIDSets);
}

/// プレミアム会員フラグ（サブスクリプション有効状態）
@override@JsonKey() final  bool isPremium;
/// 解約理由を聞くかどうかのフラグ
@override@JsonKey() final  bool shouldAskCancelReason;
/// アナリティクスのデバッグ機能有効フラグ
@override@JsonKey() final  bool analyticsDebugIsEnabled;
/// トライアル開始日（初回トライアル開始時にセット）
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? beginTrialDate;
/// トライアル期限日（トライアル期間の終了日時）
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? trialDeadlineDate;
/// 割引プラン利用期限日（トライアル終了後の割引期間終了日時）
/// 初期設定未完了または古いバージョンのアプリではnullの場合がある
@override@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final  DateTime? discountEntitlementDeadlineDate;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.setting, setting) || other.setting == setting)&&(identical(other.userIDWhenCreateUser, userIDWhenCreateUser) || other.userIDWhenCreateUser == userIDWhenCreateUser)&&(identical(other.anonymousUserID, anonymousUserID) || other.anonymousUserID == anonymousUserID)&&const DeepCollectionEquality().equals(other._userDocumentIDSets, _userDocumentIDSets)&&const DeepCollectionEquality().equals(other._anonymousUserIDSets, _anonymousUserIDSets)&&const DeepCollectionEquality().equals(other._firebaseCurrentUserIDSets, _firebaseCurrentUserIDSets)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&(identical(other.shouldAskCancelReason, shouldAskCancelReason) || other.shouldAskCancelReason == shouldAskCancelReason)&&(identical(other.analyticsDebugIsEnabled, analyticsDebugIsEnabled) || other.analyticsDebugIsEnabled == analyticsDebugIsEnabled)&&(identical(other.beginTrialDate, beginTrialDate) || other.beginTrialDate == beginTrialDate)&&(identical(other.trialDeadlineDate, trialDeadlineDate) || other.trialDeadlineDate == trialDeadlineDate)&&(identical(other.discountEntitlementDeadlineDate, discountEntitlementDeadlineDate) || other.discountEntitlementDeadlineDate == discountEntitlementDeadlineDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,setting,userIDWhenCreateUser,anonymousUserID,const DeepCollectionEquality().hash(_userDocumentIDSets),const DeepCollectionEquality().hash(_anonymousUserIDSets),const DeepCollectionEquality().hash(_firebaseCurrentUserIDSets),isPremium,shouldAskCancelReason,analyticsDebugIsEnabled,beginTrialDate,trialDeadlineDate,discountEntitlementDeadlineDate);

@override
String toString() {
  return 'User(id: $id, setting: $setting, userIDWhenCreateUser: $userIDWhenCreateUser, anonymousUserID: $anonymousUserID, userDocumentIDSets: $userDocumentIDSets, anonymousUserIDSets: $anonymousUserIDSets, firebaseCurrentUserIDSets: $firebaseCurrentUserIDSets, isPremium: $isPremium, shouldAskCancelReason: $shouldAskCancelReason, analyticsDebugIsEnabled: $analyticsDebugIsEnabled, beginTrialDate: $beginTrialDate, trialDeadlineDate: $trialDeadlineDate, discountEntitlementDeadlineDate: $discountEntitlementDeadlineDate)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String? id,@JsonKey(name: 'settings') Setting? setting, String? userIDWhenCreateUser, String? anonymousUserID, List<String> userDocumentIDSets, List<String> anonymousUserIDSets, List<String> firebaseCurrentUserIDSets, bool isPremium, bool shouldAskCancelReason, bool analyticsDebugIsEnabled,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beginTrialDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? trialDeadlineDate,@JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? discountEntitlementDeadlineDate
});


@override $SettingCopyWith<$Res>? get setting;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? setting = freezed,Object? userIDWhenCreateUser = freezed,Object? anonymousUserID = freezed,Object? userDocumentIDSets = null,Object? anonymousUserIDSets = null,Object? firebaseCurrentUserIDSets = null,Object? isPremium = null,Object? shouldAskCancelReason = null,Object? analyticsDebugIsEnabled = null,Object? beginTrialDate = freezed,Object? trialDeadlineDate = freezed,Object? discountEntitlementDeadlineDate = freezed,}) {
  return _then(_User(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,setting: freezed == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as Setting?,userIDWhenCreateUser: freezed == userIDWhenCreateUser ? _self.userIDWhenCreateUser : userIDWhenCreateUser // ignore: cast_nullable_to_non_nullable
as String?,anonymousUserID: freezed == anonymousUserID ? _self.anonymousUserID : anonymousUserID // ignore: cast_nullable_to_non_nullable
as String?,userDocumentIDSets: null == userDocumentIDSets ? _self._userDocumentIDSets : userDocumentIDSets // ignore: cast_nullable_to_non_nullable
as List<String>,anonymousUserIDSets: null == anonymousUserIDSets ? _self._anonymousUserIDSets : anonymousUserIDSets // ignore: cast_nullable_to_non_nullable
as List<String>,firebaseCurrentUserIDSets: null == firebaseCurrentUserIDSets ? _self._firebaseCurrentUserIDSets : firebaseCurrentUserIDSets // ignore: cast_nullable_to_non_nullable
as List<String>,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,shouldAskCancelReason: null == shouldAskCancelReason ? _self.shouldAskCancelReason : shouldAskCancelReason // ignore: cast_nullable_to_non_nullable
as bool,analyticsDebugIsEnabled: null == analyticsDebugIsEnabled ? _self.analyticsDebugIsEnabled : analyticsDebugIsEnabled // ignore: cast_nullable_to_non_nullable
as bool,beginTrialDate: freezed == beginTrialDate ? _self.beginTrialDate : beginTrialDate // ignore: cast_nullable_to_non_nullable
as DateTime?,trialDeadlineDate: freezed == trialDeadlineDate ? _self.trialDeadlineDate : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
as DateTime?,discountEntitlementDeadlineDate: freezed == discountEntitlementDeadlineDate ? _self.discountEntitlementDeadlineDate : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SettingCopyWith<$Res>? get setting {
    if (_self.setting == null) {
    return null;
  }

  return $SettingCopyWith<$Res>(_self.setting!, (value) {
    return _then(_self.copyWith(setting: value));
  });
}
}

// dart format on
