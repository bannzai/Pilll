// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  /// ユーザーID（FirebaseのUID）
  String? get id => throw _privateConstructorUsedError;

  /// ユーザー設定情報（Settingエンティティのネストオブジェクト）
  @JsonKey(name: 'settings')
  Setting? get setting => throw _privateConstructorUsedError;

  /// ユーザー作成時のユーザーID（履歴管理・デバッグ用）
  String? get userIDWhenCreateUser => throw _privateConstructorUsedError;

  /// 匿名ユーザーID（匿名ユーザー統合用）
  String? get anonymousUserID => throw _privateConstructorUsedError;

  /// 統合されたユーザードキュメントIDのリスト
  List<String> get userDocumentIDSets => throw _privateConstructorUsedError;

  /// 統合された匿名ユーザーIDのリスト
  List<String> get anonymousUserIDSets => throw _privateConstructorUsedError;

  /// 統合されたFirebaseCurrentUserIDのリスト
  List<String> get firebaseCurrentUserIDSets => throw _privateConstructorUsedError;

  /// プレミアム会員フラグ（サブスクリプション有効状態）
  bool get isPremium => throw _privateConstructorUsedError;

  /// 解約理由を聞くかどうかのフラグ
  bool get shouldAskCancelReason => throw _privateConstructorUsedError;

  /// アナリティクスのデバッグ機能有効フラグ
  bool get analyticsDebugIsEnabled => throw _privateConstructorUsedError;

  /// トライアル開始日（初回トライアル開始時にセット）
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get beginTrialDate => throw _privateConstructorUsedError;

  /// トライアル期限日（トライアル期間の終了日時）
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get trialDeadlineDate => throw _privateConstructorUsedError;

  /// 割引プラン利用期限日（トライアル終了後の割引期間終了日時）
  /// 初期設定未完了または古いバージョンのアプリではnullの場合がある
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get discountEntitlementDeadlineDate => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) = _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'settings') Setting? setting,
      String? userIDWhenCreateUser,
      String? anonymousUserID,
      List<String> userDocumentIDSets,
      List<String> anonymousUserIDSets,
      List<String> firebaseCurrentUserIDSets,
      bool isPremium,
      bool shouldAskCancelReason,
      bool analyticsDebugIsEnabled,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
      DateTime? discountEntitlementDeadlineDate});

  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? setting = freezed,
    Object? userIDWhenCreateUser = freezed,
    Object? anonymousUserID = freezed,
    Object? userDocumentIDSets = null,
    Object? anonymousUserIDSets = null,
    Object? firebaseCurrentUserIDSets = null,
    Object? isPremium = null,
    Object? shouldAskCancelReason = null,
    Object? analyticsDebugIsEnabled = null,
    Object? beginTrialDate = freezed,
    Object? trialDeadlineDate = freezed,
    Object? discountEntitlementDeadlineDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      setting: freezed == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      userIDWhenCreateUser: freezed == userIDWhenCreateUser
          ? _value.userIDWhenCreateUser
          : userIDWhenCreateUser // ignore: cast_nullable_to_non_nullable
              as String?,
      anonymousUserID: freezed == anonymousUserID
          ? _value.anonymousUserID
          : anonymousUserID // ignore: cast_nullable_to_non_nullable
              as String?,
      userDocumentIDSets: null == userDocumentIDSets
          ? _value.userDocumentIDSets
          : userDocumentIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      anonymousUserIDSets: null == anonymousUserIDSets
          ? _value.anonymousUserIDSets
          : anonymousUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      firebaseCurrentUserIDSets: null == firebaseCurrentUserIDSets
          ? _value.firebaseCurrentUserIDSets
          : firebaseCurrentUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldAskCancelReason: null == shouldAskCancelReason
          ? _value.shouldAskCancelReason
          : shouldAskCancelReason // ignore: cast_nullable_to_non_nullable
              as bool,
      analyticsDebugIsEnabled: null == analyticsDebugIsEnabled
          ? _value.analyticsDebugIsEnabled
          : analyticsDebugIsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      beginTrialDate: freezed == beginTrialDate
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trialDeadlineDate: freezed == trialDeadlineDate
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEntitlementDeadlineDate: freezed == discountEntitlementDeadlineDate
          ? _value.discountEntitlementDeadlineDate
          : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SettingCopyWith<$Res>? get setting {
    if (_value.setting == null) {
      return null;
    }

    return $SettingCopyWith<$Res>(_value.setting!, (value) {
      return _then(_value.copyWith(setting: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(_$UserImpl value, $Res Function(_$UserImpl) then) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'settings') Setting? setting,
      String? userIDWhenCreateUser,
      String? anonymousUserID,
      List<String> userDocumentIDSets,
      List<String> anonymousUserIDSets,
      List<String> firebaseCurrentUserIDSets,
      bool isPremium,
      bool shouldAskCancelReason,
      bool analyticsDebugIsEnabled,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
      DateTime? discountEntitlementDeadlineDate});

  @override
  $SettingCopyWith<$Res>? get setting;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$UserImpl> implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then) : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? setting = freezed,
    Object? userIDWhenCreateUser = freezed,
    Object? anonymousUserID = freezed,
    Object? userDocumentIDSets = null,
    Object? anonymousUserIDSets = null,
    Object? firebaseCurrentUserIDSets = null,
    Object? isPremium = null,
    Object? shouldAskCancelReason = null,
    Object? analyticsDebugIsEnabled = null,
    Object? beginTrialDate = freezed,
    Object? trialDeadlineDate = freezed,
    Object? discountEntitlementDeadlineDate = freezed,
  }) {
    return _then(_$UserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      setting: freezed == setting
          ? _value.setting
          : setting // ignore: cast_nullable_to_non_nullable
              as Setting?,
      userIDWhenCreateUser: freezed == userIDWhenCreateUser
          ? _value.userIDWhenCreateUser
          : userIDWhenCreateUser // ignore: cast_nullable_to_non_nullable
              as String?,
      anonymousUserID: freezed == anonymousUserID
          ? _value.anonymousUserID
          : anonymousUserID // ignore: cast_nullable_to_non_nullable
              as String?,
      userDocumentIDSets: null == userDocumentIDSets
          ? _value._userDocumentIDSets
          : userDocumentIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      anonymousUserIDSets: null == anonymousUserIDSets
          ? _value._anonymousUserIDSets
          : anonymousUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      firebaseCurrentUserIDSets: null == firebaseCurrentUserIDSets
          ? _value._firebaseCurrentUserIDSets
          : firebaseCurrentUserIDSets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldAskCancelReason: null == shouldAskCancelReason
          ? _value.shouldAskCancelReason
          : shouldAskCancelReason // ignore: cast_nullable_to_non_nullable
              as bool,
      analyticsDebugIsEnabled: null == analyticsDebugIsEnabled
          ? _value.analyticsDebugIsEnabled
          : analyticsDebugIsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      beginTrialDate: freezed == beginTrialDate
          ? _value.beginTrialDate
          : beginTrialDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      trialDeadlineDate: freezed == trialDeadlineDate
          ? _value.trialDeadlineDate
          : trialDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountEntitlementDeadlineDate: freezed == discountEntitlementDeadlineDate
          ? _value.discountEntitlementDeadlineDate
          : discountEntitlementDeadlineDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$UserImpl extends _User {
  const _$UserImpl(
      {this.id,
      @JsonKey(name: 'settings') this.setting,
      this.userIDWhenCreateUser,
      this.anonymousUserID,
      final List<String> userDocumentIDSets = const [],
      final List<String> anonymousUserIDSets = const [],
      final List<String> firebaseCurrentUserIDSets = const [],
      this.isPremium = false,
      this.shouldAskCancelReason = false,
      this.analyticsDebugIsEnabled = false,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) this.trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
      this.discountEntitlementDeadlineDate})
      : _userDocumentIDSets = userDocumentIDSets,
        _anonymousUserIDSets = anonymousUserIDSets,
        _firebaseCurrentUserIDSets = firebaseCurrentUserIDSets,
        super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) => _$$UserImplFromJson(json);

  /// ユーザーID（FirebaseのUID）
  @override
  final String? id;

  /// ユーザー設定情報（Settingエンティティのネストオブジェクト）
  @override
  @JsonKey(name: 'settings')
  final Setting? setting;

  /// ユーザー作成時のユーザーID（履歴管理・デバッグ用）
  @override
  final String? userIDWhenCreateUser;

  /// 匿名ユーザーID（匿名ユーザー統合用）
  @override
  final String? anonymousUserID;

  /// 統合されたユーザードキュメントIDのリスト
  final List<String> _userDocumentIDSets;

  /// 統合されたユーザードキュメントIDのリスト
  @override
  @JsonKey()
  List<String> get userDocumentIDSets {
    if (_userDocumentIDSets is EqualUnmodifiableListView) return _userDocumentIDSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userDocumentIDSets);
  }

  /// 統合された匿名ユーザーIDのリスト
  final List<String> _anonymousUserIDSets;

  /// 統合された匿名ユーザーIDのリスト
  @override
  @JsonKey()
  List<String> get anonymousUserIDSets {
    if (_anonymousUserIDSets is EqualUnmodifiableListView) return _anonymousUserIDSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_anonymousUserIDSets);
  }

  /// 統合されたFirebaseCurrentUserIDのリスト
  final List<String> _firebaseCurrentUserIDSets;

  /// 統合されたFirebaseCurrentUserIDのリスト
  @override
  @JsonKey()
  List<String> get firebaseCurrentUserIDSets {
    if (_firebaseCurrentUserIDSets is EqualUnmodifiableListView) return _firebaseCurrentUserIDSets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_firebaseCurrentUserIDSets);
  }

  /// プレミアム会員フラグ（サブスクリプション有効状態）
  @override
  @JsonKey()
  final bool isPremium;

  /// 解約理由を聞くかどうかのフラグ
  @override
  @JsonKey()
  final bool shouldAskCancelReason;

  /// アナリティクスのデバッグ機能有効フラグ
  @override
  @JsonKey()
  final bool analyticsDebugIsEnabled;

  /// トライアル開始日（初回トライアル開始時にセット）
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? beginTrialDate;

  /// トライアル期限日（トライアル期間の終了日時）
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? trialDeadlineDate;

  /// 割引プラン利用期限日（トライアル終了後の割引期間終了日時）
  /// 初期設定未完了または古いバージョンのアプリではnullの場合がある
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  final DateTime? discountEntitlementDeadlineDate;

  @override
  String toString() {
    return 'User(id: $id, setting: $setting, userIDWhenCreateUser: $userIDWhenCreateUser, anonymousUserID: $anonymousUserID, userDocumentIDSets: $userDocumentIDSets, anonymousUserIDSets: $anonymousUserIDSets, firebaseCurrentUserIDSets: $firebaseCurrentUserIDSets, isPremium: $isPremium, shouldAskCancelReason: $shouldAskCancelReason, analyticsDebugIsEnabled: $analyticsDebugIsEnabled, beginTrialDate: $beginTrialDate, trialDeadlineDate: $trialDeadlineDate, discountEntitlementDeadlineDate: $discountEntitlementDeadlineDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.setting, setting) || other.setting == setting) &&
            (identical(other.userIDWhenCreateUser, userIDWhenCreateUser) || other.userIDWhenCreateUser == userIDWhenCreateUser) &&
            (identical(other.anonymousUserID, anonymousUserID) || other.anonymousUserID == anonymousUserID) &&
            const DeepCollectionEquality().equals(other._userDocumentIDSets, _userDocumentIDSets) &&
            const DeepCollectionEquality().equals(other._anonymousUserIDSets, _anonymousUserIDSets) &&
            const DeepCollectionEquality().equals(other._firebaseCurrentUserIDSets, _firebaseCurrentUserIDSets) &&
            (identical(other.isPremium, isPremium) || other.isPremium == isPremium) &&
            (identical(other.shouldAskCancelReason, shouldAskCancelReason) || other.shouldAskCancelReason == shouldAskCancelReason) &&
            (identical(other.analyticsDebugIsEnabled, analyticsDebugIsEnabled) || other.analyticsDebugIsEnabled == analyticsDebugIsEnabled) &&
            (identical(other.beginTrialDate, beginTrialDate) || other.beginTrialDate == beginTrialDate) &&
            (identical(other.trialDeadlineDate, trialDeadlineDate) || other.trialDeadlineDate == trialDeadlineDate) &&
            (identical(other.discountEntitlementDeadlineDate, discountEntitlementDeadlineDate) ||
                other.discountEntitlementDeadlineDate == discountEntitlementDeadlineDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      setting,
      userIDWhenCreateUser,
      anonymousUserID,
      const DeepCollectionEquality().hash(_userDocumentIDSets),
      const DeepCollectionEquality().hash(_anonymousUserIDSets),
      const DeepCollectionEquality().hash(_firebaseCurrentUserIDSets),
      isPremium,
      shouldAskCancelReason,
      analyticsDebugIsEnabled,
      beginTrialDate,
      trialDeadlineDate,
      discountEntitlementDeadlineDate);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith => __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User(
      {final String? id,
      @JsonKey(name: 'settings') final Setting? setting,
      final String? userIDWhenCreateUser,
      final String? anonymousUserID,
      final List<String> userDocumentIDSets,
      final List<String> anonymousUserIDSets,
      final List<String> firebaseCurrentUserIDSets,
      final bool isPremium,
      final bool shouldAskCancelReason,
      final bool analyticsDebugIsEnabled,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final DateTime? beginTrialDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp) final DateTime? trialDeadlineDate,
      @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
      final DateTime? discountEntitlementDeadlineDate}) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  /// ユーザーID（FirebaseのUID）
  @override
  String? get id;

  /// ユーザー設定情報（Settingエンティティのネストオブジェクト）
  @override
  @JsonKey(name: 'settings')
  Setting? get setting;

  /// ユーザー作成時のユーザーID（履歴管理・デバッグ用）
  @override
  String? get userIDWhenCreateUser;

  /// 匿名ユーザーID（匿名ユーザー統合用）
  @override
  String? get anonymousUserID;

  /// 統合されたユーザードキュメントIDのリスト
  @override
  List<String> get userDocumentIDSets;

  /// 統合された匿名ユーザーIDのリスト
  @override
  List<String> get anonymousUserIDSets;

  /// 統合されたFirebaseCurrentUserIDのリスト
  @override
  List<String> get firebaseCurrentUserIDSets;

  /// プレミアム会員フラグ（サブスクリプション有効状態）
  @override
  bool get isPremium;

  /// 解約理由を聞くかどうかのフラグ
  @override
  bool get shouldAskCancelReason;

  /// アナリティクスのデバッグ機能有効フラグ
  @override
  bool get analyticsDebugIsEnabled;

  /// トライアル開始日（初回トライアル開始時にセット）
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get beginTrialDate;

  /// トライアル期限日（トライアル期間の終了日時）
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get trialDeadlineDate;

  /// 割引プラン利用期限日（トライアル終了後の割引期間終了日時）
  /// 初期設定未完了または古いバージョンのアプリではnullの場合がある
  @override
  @JsonKey(fromJson: TimestampConverter.timestampToDateTime, toJson: TimestampConverter.dateTimeToTimestamp)
  DateTime? get discountEntitlementDeadlineDate;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith => throw _privateConstructorUsedError;
}
