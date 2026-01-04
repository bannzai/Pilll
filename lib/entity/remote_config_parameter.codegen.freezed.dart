// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_parameter.codegen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RemoteConfigParameter _$RemoteConfigParameterFromJson(
    Map<String, dynamic> json) {
  return _RemoteConfigParameter.fromJson(json);
}

/// @nodoc
mixin _$RemoteConfigParameter {
  /// ペイウォール画面を最初に表示するかどうか
  /// trueの場合、アプリ起動時にプレミアム機能の課金画面を先に表示する
  bool get isPaywallFirst => throw _privateConstructorUsedError;

  /// 初期設定画面をスキップするかどうか
  /// trueの場合、新規ユーザーでも初期設定をバイパスしてメイン画面へ遷移
  bool get skipInitialSetting => throw _privateConstructorUsedError;

  /// トライアル期限日の基準日からのオフセット日数
  /// ユーザー登録日からこの日数後にトライアル期限が設定される
  int get trialDeadlineDateOffsetDay => throw _privateConstructorUsedError;

  /// 割引プラン権利付与の基準日からのオフセット日数
  /// ユーザー登録日からこの日数後に割引プランの権利が付与される
  int get discountEntitlementOffsetDay => throw _privateConstructorUsedError;

  /// 割引カウントダウン表示の境界時間（時間単位）
  /// この時間以内になったら割引期限のカウントダウンを表示する
  int get discountCountdownBoundaryHour => throw _privateConstructorUsedError;

  /// プレミアム機能紹介パターンの識別子
  /// A/Bテスト用のパターン識別子（'default', 'A', 'B'等）
  String get premiumIntroductionPattern => throw _privateConstructorUsedError;

  /// プレミアム紹介画面でApp Storeレビューカードを表示するか
  /// trueの場合、プレミアム機能紹介時にレビュー促進カードも表示
  bool get premiumIntroductionShowsAppStoreReviewCard =>
      throw _privateConstructorUsedError;

  /// 特別オファー対象ユーザー作成日時の基準オフセット値（分単位）
  /// ユーザー登録からこの分数経過したユーザーが特別オファーの対象となる
  int get specialOfferingUserCreationDateTimeOffset =>
      throw _privateConstructorUsedError;

  /// 特別オファー開始の基準オフセット値（分単位）
  /// 特別オファーの表示開始タイミングを制御する
  int get specialOfferingUserCreationDateTimeOffsetSince =>
      throw _privateConstructorUsedError;

  /// 特別オファー終了の基準オフセット値（分単位）
  /// 特別オファーの表示終了タイミングを制御する
  int get specialOfferingUserCreationDateTimeOffsetUntil =>
      throw _privateConstructorUsedError;

  /// 特別オファー2で代替テキストを使用するかどうか
  /// trueの場合、特別オファー2画面で異なるテキスト表現を使用する
  bool get specialOffering2UseAlternativeText =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RemoteConfigParameterCopyWith<RemoteConfigParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteConfigParameterCopyWith<$Res> {
  factory $RemoteConfigParameterCopyWith(RemoteConfigParameter value,
          $Res Function(RemoteConfigParameter) then) =
      _$RemoteConfigParameterCopyWithImpl<$Res, RemoteConfigParameter>;
  @useResult
  $Res call(
      {bool isPaywallFirst,
      bool skipInitialSetting,
      int trialDeadlineDateOffsetDay,
      int discountEntitlementOffsetDay,
      int discountCountdownBoundaryHour,
      String premiumIntroductionPattern,
      bool premiumIntroductionShowsAppStoreReviewCard,
      int specialOfferingUserCreationDateTimeOffset,
      int specialOfferingUserCreationDateTimeOffsetSince,
      int specialOfferingUserCreationDateTimeOffsetUntil,
      bool specialOffering2UseAlternativeText});
}

/// @nodoc
class _$RemoteConfigParameterCopyWithImpl<$Res,
        $Val extends RemoteConfigParameter>
    implements $RemoteConfigParameterCopyWith<$Res> {
  _$RemoteConfigParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPaywallFirst = null,
    Object? skipInitialSetting = null,
    Object? trialDeadlineDateOffsetDay = null,
    Object? discountEntitlementOffsetDay = null,
    Object? discountCountdownBoundaryHour = null,
    Object? premiumIntroductionPattern = null,
    Object? premiumIntroductionShowsAppStoreReviewCard = null,
    Object? specialOfferingUserCreationDateTimeOffset = null,
    Object? specialOfferingUserCreationDateTimeOffsetSince = null,
    Object? specialOfferingUserCreationDateTimeOffsetUntil = null,
    Object? specialOffering2UseAlternativeText = null,
  }) {
    return _then(_value.copyWith(
      isPaywallFirst: null == isPaywallFirst
          ? _value.isPaywallFirst
          : isPaywallFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      skipInitialSetting: null == skipInitialSetting
          ? _value.skipInitialSetting
          : skipInitialSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDeadlineDateOffsetDay: null == trialDeadlineDateOffsetDay
          ? _value.trialDeadlineDateOffsetDay
          : trialDeadlineDateOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountEntitlementOffsetDay: null == discountEntitlementOffsetDay
          ? _value.discountEntitlementOffsetDay
          : discountEntitlementOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountCountdownBoundaryHour: null == discountCountdownBoundaryHour
          ? _value.discountCountdownBoundaryHour
          : discountCountdownBoundaryHour // ignore: cast_nullable_to_non_nullable
              as int,
      premiumIntroductionPattern: null == premiumIntroductionPattern
          ? _value.premiumIntroductionPattern
          : premiumIntroductionPattern // ignore: cast_nullable_to_non_nullable
              as String,
      premiumIntroductionShowsAppStoreReviewCard: null ==
              premiumIntroductionShowsAppStoreReviewCard
          ? _value.premiumIntroductionShowsAppStoreReviewCard
          : premiumIntroductionShowsAppStoreReviewCard // ignore: cast_nullable_to_non_nullable
              as bool,
      specialOfferingUserCreationDateTimeOffset: null ==
              specialOfferingUserCreationDateTimeOffset
          ? _value.specialOfferingUserCreationDateTimeOffset
          : specialOfferingUserCreationDateTimeOffset // ignore: cast_nullable_to_non_nullable
              as int,
      specialOfferingUserCreationDateTimeOffsetSince: null ==
              specialOfferingUserCreationDateTimeOffsetSince
          ? _value.specialOfferingUserCreationDateTimeOffsetSince
          : specialOfferingUserCreationDateTimeOffsetSince // ignore: cast_nullable_to_non_nullable
              as int,
      specialOfferingUserCreationDateTimeOffsetUntil: null ==
              specialOfferingUserCreationDateTimeOffsetUntil
          ? _value.specialOfferingUserCreationDateTimeOffsetUntil
          : specialOfferingUserCreationDateTimeOffsetUntil // ignore: cast_nullable_to_non_nullable
              as int,
      specialOffering2UseAlternativeText: null ==
              specialOffering2UseAlternativeText
          ? _value.specialOffering2UseAlternativeText
          : specialOffering2UseAlternativeText // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RemoteConfigParameterImplCopyWith<$Res>
    implements $RemoteConfigParameterCopyWith<$Res> {
  factory _$$RemoteConfigParameterImplCopyWith(
          _$RemoteConfigParameterImpl value,
          $Res Function(_$RemoteConfigParameterImpl) then) =
      __$$RemoteConfigParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isPaywallFirst,
      bool skipInitialSetting,
      int trialDeadlineDateOffsetDay,
      int discountEntitlementOffsetDay,
      int discountCountdownBoundaryHour,
      String premiumIntroductionPattern,
      bool premiumIntroductionShowsAppStoreReviewCard,
      int specialOfferingUserCreationDateTimeOffset,
      int specialOfferingUserCreationDateTimeOffsetSince,
      int specialOfferingUserCreationDateTimeOffsetUntil,
      bool specialOffering2UseAlternativeText});
}

/// @nodoc
class __$$RemoteConfigParameterImplCopyWithImpl<$Res>
    extends _$RemoteConfigParameterCopyWithImpl<$Res,
        _$RemoteConfigParameterImpl>
    implements _$$RemoteConfigParameterImplCopyWith<$Res> {
  __$$RemoteConfigParameterImplCopyWithImpl(_$RemoteConfigParameterImpl _value,
      $Res Function(_$RemoteConfigParameterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPaywallFirst = null,
    Object? skipInitialSetting = null,
    Object? trialDeadlineDateOffsetDay = null,
    Object? discountEntitlementOffsetDay = null,
    Object? discountCountdownBoundaryHour = null,
    Object? premiumIntroductionPattern = null,
    Object? premiumIntroductionShowsAppStoreReviewCard = null,
    Object? specialOfferingUserCreationDateTimeOffset = null,
    Object? specialOfferingUserCreationDateTimeOffsetSince = null,
    Object? specialOfferingUserCreationDateTimeOffsetUntil = null,
    Object? specialOffering2UseAlternativeText = null,
  }) {
    return _then(_$RemoteConfigParameterImpl(
      isPaywallFirst: null == isPaywallFirst
          ? _value.isPaywallFirst
          : isPaywallFirst // ignore: cast_nullable_to_non_nullable
              as bool,
      skipInitialSetting: null == skipInitialSetting
          ? _value.skipInitialSetting
          : skipInitialSetting // ignore: cast_nullable_to_non_nullable
              as bool,
      trialDeadlineDateOffsetDay: null == trialDeadlineDateOffsetDay
          ? _value.trialDeadlineDateOffsetDay
          : trialDeadlineDateOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountEntitlementOffsetDay: null == discountEntitlementOffsetDay
          ? _value.discountEntitlementOffsetDay
          : discountEntitlementOffsetDay // ignore: cast_nullable_to_non_nullable
              as int,
      discountCountdownBoundaryHour: null == discountCountdownBoundaryHour
          ? _value.discountCountdownBoundaryHour
          : discountCountdownBoundaryHour // ignore: cast_nullable_to_non_nullable
              as int,
      premiumIntroductionPattern: null == premiumIntroductionPattern
          ? _value.premiumIntroductionPattern
          : premiumIntroductionPattern // ignore: cast_nullable_to_non_nullable
              as String,
      premiumIntroductionShowsAppStoreReviewCard: null ==
              premiumIntroductionShowsAppStoreReviewCard
          ? _value.premiumIntroductionShowsAppStoreReviewCard
          : premiumIntroductionShowsAppStoreReviewCard // ignore: cast_nullable_to_non_nullable
              as bool,
      specialOfferingUserCreationDateTimeOffset: null ==
              specialOfferingUserCreationDateTimeOffset
          ? _value.specialOfferingUserCreationDateTimeOffset
          : specialOfferingUserCreationDateTimeOffset // ignore: cast_nullable_to_non_nullable
              as int,
      specialOfferingUserCreationDateTimeOffsetSince: null ==
              specialOfferingUserCreationDateTimeOffsetSince
          ? _value.specialOfferingUserCreationDateTimeOffsetSince
          : specialOfferingUserCreationDateTimeOffsetSince // ignore: cast_nullable_to_non_nullable
              as int,
      specialOfferingUserCreationDateTimeOffsetUntil: null ==
              specialOfferingUserCreationDateTimeOffsetUntil
          ? _value.specialOfferingUserCreationDateTimeOffsetUntil
          : specialOfferingUserCreationDateTimeOffsetUntil // ignore: cast_nullable_to_non_nullable
              as int,
      specialOffering2UseAlternativeText: null ==
              specialOffering2UseAlternativeText
          ? _value.specialOffering2UseAlternativeText
          : specialOffering2UseAlternativeText // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RemoteConfigParameterImpl extends _RemoteConfigParameter {
  _$RemoteConfigParameterImpl(
      {this.isPaywallFirst = RemoteConfigParameterDefaultValues.isPaywallFirst,
      this.skipInitialSetting =
          RemoteConfigParameterDefaultValues.skipInitialSetting,
      this.trialDeadlineDateOffsetDay =
          RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay,
      this.discountEntitlementOffsetDay =
          RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay,
      this.discountCountdownBoundaryHour =
          RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour,
      this.premiumIntroductionPattern =
          RemoteConfigParameterDefaultValues.premiumIntroductionPattern,
      this.premiumIntroductionShowsAppStoreReviewCard =
          RemoteConfigParameterDefaultValues
              .premiumIntroductionShowsAppStoreReviewCard,
      this.specialOfferingUserCreationDateTimeOffset =
          RemoteConfigParameterDefaultValues
              .specialOfferingUserCreationDateTimeOffset,
      this.specialOfferingUserCreationDateTimeOffsetSince =
          RemoteConfigParameterDefaultValues
              .specialOfferingUserCreationDateTimeOffsetSince,
      this.specialOfferingUserCreationDateTimeOffsetUntil =
          RemoteConfigParameterDefaultValues
              .specialOfferingUserCreationDateTimeOffsetUntil,
      this.specialOffering2UseAlternativeText =
          RemoteConfigParameterDefaultValues
              .specialOffering2UseAlternativeText})
      : super._();

  factory _$RemoteConfigParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$RemoteConfigParameterImplFromJson(json);

  /// ペイウォール画面を最初に表示するかどうか
  /// trueの場合、アプリ起動時にプレミアム機能の課金画面を先に表示する
  @override
  @JsonKey()
  final bool isPaywallFirst;

  /// 初期設定画面をスキップするかどうか
  /// trueの場合、新規ユーザーでも初期設定をバイパスしてメイン画面へ遷移
  @override
  @JsonKey()
  final bool skipInitialSetting;

  /// トライアル期限日の基準日からのオフセット日数
  /// ユーザー登録日からこの日数後にトライアル期限が設定される
  @override
  @JsonKey()
  final int trialDeadlineDateOffsetDay;

  /// 割引プラン権利付与の基準日からのオフセット日数
  /// ユーザー登録日からこの日数後に割引プランの権利が付与される
  @override
  @JsonKey()
  final int discountEntitlementOffsetDay;

  /// 割引カウントダウン表示の境界時間（時間単位）
  /// この時間以内になったら割引期限のカウントダウンを表示する
  @override
  @JsonKey()
  final int discountCountdownBoundaryHour;

  /// プレミアム機能紹介パターンの識別子
  /// A/Bテスト用のパターン識別子（'default', 'A', 'B'等）
  @override
  @JsonKey()
  final String premiumIntroductionPattern;

  /// プレミアム紹介画面でApp Storeレビューカードを表示するか
  /// trueの場合、プレミアム機能紹介時にレビュー促進カードも表示
  @override
  @JsonKey()
  final bool premiumIntroductionShowsAppStoreReviewCard;

  /// 特別オファー対象ユーザー作成日時の基準オフセット値（分単位）
  /// ユーザー登録からこの分数経過したユーザーが特別オファーの対象となる
  @override
  @JsonKey()
  final int specialOfferingUserCreationDateTimeOffset;

  /// 特別オファー開始の基準オフセット値（分単位）
  /// 特別オファーの表示開始タイミングを制御する
  @override
  @JsonKey()
  final int specialOfferingUserCreationDateTimeOffsetSince;

  /// 特別オファー終了の基準オフセット値（分単位）
  /// 特別オファーの表示終了タイミングを制御する
  @override
  @JsonKey()
  final int specialOfferingUserCreationDateTimeOffsetUntil;

  /// 特別オファー2で代替テキストを使用するかどうか
  /// trueの場合、特別オファー2画面で異なるテキスト表現を使用する
  @override
  @JsonKey()
  final bool specialOffering2UseAlternativeText;

  @override
  String toString() {
    return 'RemoteConfigParameter(isPaywallFirst: $isPaywallFirst, skipInitialSetting: $skipInitialSetting, trialDeadlineDateOffsetDay: $trialDeadlineDateOffsetDay, discountEntitlementOffsetDay: $discountEntitlementOffsetDay, discountCountdownBoundaryHour: $discountCountdownBoundaryHour, premiumIntroductionPattern: $premiumIntroductionPattern, premiumIntroductionShowsAppStoreReviewCard: $premiumIntroductionShowsAppStoreReviewCard, specialOfferingUserCreationDateTimeOffset: $specialOfferingUserCreationDateTimeOffset, specialOfferingUserCreationDateTimeOffsetSince: $specialOfferingUserCreationDateTimeOffsetSince, specialOfferingUserCreationDateTimeOffsetUntil: $specialOfferingUserCreationDateTimeOffsetUntil, specialOffering2UseAlternativeText: $specialOffering2UseAlternativeText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteConfigParameterImpl &&
            (identical(other.isPaywallFirst, isPaywallFirst) ||
                other.isPaywallFirst == isPaywallFirst) &&
            (identical(other.skipInitialSetting, skipInitialSetting) ||
                other.skipInitialSetting == skipInitialSetting) &&
            (identical(other.trialDeadlineDateOffsetDay, trialDeadlineDateOffsetDay) ||
                other.trialDeadlineDateOffsetDay ==
                    trialDeadlineDateOffsetDay) &&
            (identical(other.discountEntitlementOffsetDay, discountEntitlementOffsetDay) ||
                other.discountEntitlementOffsetDay ==
                    discountEntitlementOffsetDay) &&
            (identical(other.discountCountdownBoundaryHour, discountCountdownBoundaryHour) ||
                other.discountCountdownBoundaryHour ==
                    discountCountdownBoundaryHour) &&
            (identical(other.premiumIntroductionPattern, premiumIntroductionPattern) ||
                other.premiumIntroductionPattern ==
                    premiumIntroductionPattern) &&
            (identical(other.premiumIntroductionShowsAppStoreReviewCard, premiumIntroductionShowsAppStoreReviewCard) ||
                other.premiumIntroductionShowsAppStoreReviewCard ==
                    premiumIntroductionShowsAppStoreReviewCard) &&
            (identical(other.specialOfferingUserCreationDateTimeOffset, specialOfferingUserCreationDateTimeOffset) ||
                other.specialOfferingUserCreationDateTimeOffset ==
                    specialOfferingUserCreationDateTimeOffset) &&
            (identical(other.specialOfferingUserCreationDateTimeOffsetSince,
                    specialOfferingUserCreationDateTimeOffsetSince) ||
                other.specialOfferingUserCreationDateTimeOffsetSince ==
                    specialOfferingUserCreationDateTimeOffsetSince) &&
            (identical(other.specialOfferingUserCreationDateTimeOffsetUntil,
                    specialOfferingUserCreationDateTimeOffsetUntil) ||
                other.specialOfferingUserCreationDateTimeOffsetUntil ==
                    specialOfferingUserCreationDateTimeOffsetUntil) &&
            (identical(other.specialOffering2UseAlternativeText, specialOffering2UseAlternativeText) ||
                other.specialOffering2UseAlternativeText == specialOffering2UseAlternativeText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isPaywallFirst,
      skipInitialSetting,
      trialDeadlineDateOffsetDay,
      discountEntitlementOffsetDay,
      discountCountdownBoundaryHour,
      premiumIntroductionPattern,
      premiumIntroductionShowsAppStoreReviewCard,
      specialOfferingUserCreationDateTimeOffset,
      specialOfferingUserCreationDateTimeOffsetSince,
      specialOfferingUserCreationDateTimeOffsetUntil,
      specialOffering2UseAlternativeText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl>
      get copyWith => __$$RemoteConfigParameterImplCopyWithImpl<
          _$RemoteConfigParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RemoteConfigParameterImplToJson(
      this,
    );
  }
}

abstract class _RemoteConfigParameter extends RemoteConfigParameter {
  factory _RemoteConfigParameter(
          {final bool isPaywallFirst,
          final bool skipInitialSetting,
          final int trialDeadlineDateOffsetDay,
          final int discountEntitlementOffsetDay,
          final int discountCountdownBoundaryHour,
          final String premiumIntroductionPattern,
          final bool premiumIntroductionShowsAppStoreReviewCard,
          final int specialOfferingUserCreationDateTimeOffset,
          final int specialOfferingUserCreationDateTimeOffsetSince,
          final int specialOfferingUserCreationDateTimeOffsetUntil,
          final bool specialOffering2UseAlternativeText}) =
      _$RemoteConfigParameterImpl;
  _RemoteConfigParameter._() : super._();

  factory _RemoteConfigParameter.fromJson(Map<String, dynamic> json) =
      _$RemoteConfigParameterImpl.fromJson;

  @override

  /// ペイウォール画面を最初に表示するかどうか
  /// trueの場合、アプリ起動時にプレミアム機能の課金画面を先に表示する
  bool get isPaywallFirst;
  @override

  /// 初期設定画面をスキップするかどうか
  /// trueの場合、新規ユーザーでも初期設定をバイパスしてメイン画面へ遷移
  bool get skipInitialSetting;
  @override

  /// トライアル期限日の基準日からのオフセット日数
  /// ユーザー登録日からこの日数後にトライアル期限が設定される
  int get trialDeadlineDateOffsetDay;
  @override

  /// 割引プラン権利付与の基準日からのオフセット日数
  /// ユーザー登録日からこの日数後に割引プランの権利が付与される
  int get discountEntitlementOffsetDay;
  @override

  /// 割引カウントダウン表示の境界時間（時間単位）
  /// この時間以内になったら割引期限のカウントダウンを表示する
  int get discountCountdownBoundaryHour;
  @override

  /// プレミアム機能紹介パターンの識別子
  /// A/Bテスト用のパターン識別子（'default', 'A', 'B'等）
  String get premiumIntroductionPattern;
  @override

  /// プレミアム紹介画面でApp Storeレビューカードを表示するか
  /// trueの場合、プレミアム機能紹介時にレビュー促進カードも表示
  bool get premiumIntroductionShowsAppStoreReviewCard;
  @override

  /// 特別オファー対象ユーザー作成日時の基準オフセット値（分単位）
  /// ユーザー登録からこの分数経過したユーザーが特別オファーの対象となる
  int get specialOfferingUserCreationDateTimeOffset;
  @override

  /// 特別オファー開始の基準オフセット値（分単位）
  /// 特別オファーの表示開始タイミングを制御する
  int get specialOfferingUserCreationDateTimeOffsetSince;
  @override

  /// 特別オファー終了の基準オフセット値（分単位）
  /// 特別オファーの表示終了タイミングを制御する
  int get specialOfferingUserCreationDateTimeOffsetUntil;
  @override

  /// 特別オファー2で代替テキストを使用するかどうか
  /// trueの場合、特別オファー2画面で異なるテキスト表現を使用する
  bool get specialOffering2UseAlternativeText;
  @override
  @JsonKey(ignore: true)
  _$$RemoteConfigParameterImplCopyWith<_$RemoteConfigParameterImpl>
      get copyWith => throw _privateConstructorUsedError;
}
