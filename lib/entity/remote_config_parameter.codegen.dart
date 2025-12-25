import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_parameter.codegen.freezed.dart';
part 'remote_config_parameter.codegen.g.dart';

/// Firebase Remote Configで使用するパラメータキーの定義
///
/// Remote Configで管理する各種フィーチャーフラグや設定値のキー名を
/// 定数として定義し、文字列のタイプミスを防ぐ。
abstract class RemoteConfigKeys {
  /// ペイウォールを最初に表示するかどうかのフラグキー
  static const isPaywallFirst = 'isPaywallFirst';

  /// 初期設定画面をスキップするかどうかのフラグキー
  static const skipInitialSetting = 'skipInitialSetting';

  /// トライアル期限日の基準日からのオフセット日数キー
  static const trialDeadlineDateOffsetDay = 'trialDeadlineDateOffsetDay';

  /// 割引プラン権利付与の基準日からのオフセット日数キー
  static const discountEntitlementOffsetDay = 'discountEntitlementOffsetDay';

  /// 割引カウントダウン表示の境界時間（時間単位）キー
  static const discountCountdownBoundaryHour = 'discountCountdownBoundaryHour';

  /// アプリのリリースバージョン文字列キー
  static const releasedVersion = 'releasedVersion';

  /// プレミアム機能紹介パターンの識別子キー
  static const premiumIntroductionPattern = 'premiumIntroductionPattern';

  /// プレミアム紹介でApp Storeレビューカードを表示するかのフラグキー
  static const premiumIntroductionShowsAppStoreReviewCard = 'premiumIntroductionShowsAppStoreReviewCard';

  /// 特別オファー対象ユーザー作成日時の基準オフセット値キー
  static const specialOfferingUserCreationDateTimeOffset = 'specialOfferingUserCreationDateTimeOffset';

  /// 特別オファー開始の基準オフセット値キー
  static const specialOfferingUserCreationDateTimeOffsetSince = 'specialOfferingUserCreationDateTimeOffsetSince';

  /// 特別オファー終了の基準オフセット値キー
  static const specialOfferingUserCreationDateTimeOffsetUntil = 'specialOfferingUserCreationDateTimeOffsetUntil';

  /// 特別オファー2で代替テキストを使用するかのフラグキー
  static const specialOffering2UseAlternativeText = 'specialOffering2UseAlternativeText';
}

/// Remote Configパラメータのデフォルト値定義
///
/// Firebase Remote Configから値が取得できない場合や
/// 初期化時に使用するデフォルト値を定数として管理。
/// setupRemoteConfig()とremoteConfigParameterProvider()で参照される。
abstract class RemoteConfigParameterDefaultValues {
  /// ペイウォールを最初に表示しない（デフォルト）
  static const isPaywallFirst = false;

  /// 初期設定をスキップしない（デフォルト）
  static const skipInitialSetting = false;

  /// トライアル期限を45日後に設定（デフォルト）
  static const trialDeadlineDateOffsetDay = 45;

  /// 割引権利を2日後に付与（デフォルト）
  static const discountEntitlementOffsetDay = 2;

  /// 割引カウントダウンを48時間で表示（デフォルト）
  static const discountCountdownBoundaryHour = 48;

  /// デフォルトのリリースバージョン
  static const releasedVersion = '202407.29.133308';
  // default(A) or B or C ...
  /// プレミアム紹介パターンのデフォルト値（A/Bテスト用）
  static const premiumIntroductionPattern = 'default';

  /// プレミアム紹介でApp Storeレビューカードを表示しない（デフォルト）
  static const premiumIntroductionShowsAppStoreReviewCard = false;

  /// 特別オファー対象ユーザー作成日時の基準値（分単位）
  static const specialOfferingUserCreationDateTimeOffset = 40000;

  /// 特別オファー開始の基準値（分単位）
  static const specialOfferingUserCreationDateTimeOffsetSince = 390;

  /// 特別オファー終了の基準値（分単位）
  static const specialOfferingUserCreationDateTimeOffsetUntil = 400;

  /// 特別オファー2で代替テキストを使用する（デフォルト）
  static const specialOffering2UseAlternativeText = true;
}

// [RemoteConfigDefaultValues] でgrepした場所に全て設定する
/// Firebase Remote Configで管理するアプリ設定パラメータ
///
/// フィーチャーフラグや動的な設定値をRemote Configから取得し、
/// アプリの挙動を本番環境でリアルタイムに制御するためのエンティティ。
/// 課金システム、UI表示パターン、特別オファーの表示制御などに使用される。
@freezed
abstract class RemoteConfigParameter with _$RemoteConfigParameter {
  factory RemoteConfigParameter({
    /// ペイウォール画面を最初に表示するかどうか
    /// trueの場合、アプリ起動時にプレミアム機能の課金画面を先に表示する
    @Default(RemoteConfigParameterDefaultValues.isPaywallFirst) bool isPaywallFirst,

    /// 初期設定画面をスキップするかどうか
    /// trueの場合、新規ユーザーでも初期設定をバイパスしてメイン画面へ遷移
    @Default(RemoteConfigParameterDefaultValues.skipInitialSetting) bool skipInitialSetting,

    /// トライアル期限日の基準日からのオフセット日数
    /// ユーザー登録日からこの日数後にトライアル期限が設定される
    @Default(RemoteConfigParameterDefaultValues.trialDeadlineDateOffsetDay) int trialDeadlineDateOffsetDay,

    /// 割引プラン権利付与の基準日からのオフセット日数
    /// ユーザー登録日からこの日数後に割引プランの権利が付与される
    @Default(RemoteConfigParameterDefaultValues.discountEntitlementOffsetDay) int discountEntitlementOffsetDay,

    /// 割引カウントダウン表示の境界時間（時間単位）
    /// この時間以内になったら割引期限のカウントダウンを表示する
    @Default(RemoteConfigParameterDefaultValues.discountCountdownBoundaryHour) int discountCountdownBoundaryHour,

    /// プレミアム機能紹介パターンの識別子
    /// A/Bテスト用のパターン識別子（'default', 'A', 'B'等）
    @Default(RemoteConfigParameterDefaultValues.premiumIntroductionPattern) String premiumIntroductionPattern,

    /// プレミアム紹介画面でApp Storeレビューカードを表示するか
    /// trueの場合、プレミアム機能紹介時にレビュー促進カードも表示
    @Default(RemoteConfigParameterDefaultValues.premiumIntroductionShowsAppStoreReviewCard) bool premiumIntroductionShowsAppStoreReviewCard,

    /// 特別オファー対象ユーザー作成日時の基準オフセット値（分単位）
    /// ユーザー登録からこの分数経過したユーザーが特別オファーの対象となる
    @Default(RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffset) int specialOfferingUserCreationDateTimeOffset,

    /// 特別オファー開始の基準オフセット値（分単位）
    /// 特別オファーの表示開始タイミングを制御する
    @Default(RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetSince) int specialOfferingUserCreationDateTimeOffsetSince,

    /// 特別オファー終了の基準オフセット値（分単位）
    /// 特別オファーの表示終了タイミングを制御する
    @Default(RemoteConfigParameterDefaultValues.specialOfferingUserCreationDateTimeOffsetUntil) int specialOfferingUserCreationDateTimeOffsetUntil,

    /// 特別オファー2で代替テキストを使用するかどうか
    /// trueの場合、特別オファー2画面で異なるテキスト表現を使用する
    @Default(RemoteConfigParameterDefaultValues.specialOffering2UseAlternativeText) bool specialOffering2UseAlternativeText,
  }) = _RemoteConfigParameter;
  RemoteConfigParameter._();
  factory RemoteConfigParameter.fromJson(Map<String, dynamic> json) => _$RemoteConfigParameterFromJson(json);
}
