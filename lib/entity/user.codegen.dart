import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/utils/datetime/day.dart';

part 'user.codegen.g.dart';
part 'user.codegen.freezed.dart';

/// ユーザーが見つからない場合にスローされる例外クラス
/// Firestoreからのユーザー取得処理でドキュメントが存在しない場合に使用
class UserNotFound implements Exception {
  @override
  String toString() {
    return 'user not found';
  }
}

/// ユーザーが既に存在する場合にスローされる例外クラス
/// ユーザー作成時に同一IDのドキュメントが既に存在する場合に使用
class UserAlreadyExists implements Exception {
  @override
  String toString() {
    return 'user already exists';
  }
}

/// Firestoreのprivateサブコレクション用フィールドキーを定義するextension
/// 機密情報や個人情報を含むフィールドのキー名を統一管理
/// プッシュ通知、認証、課金情報などのセキュリティが重要なデータのフィールド名を定数化
extension UserPrivateFirestoreFieldKeys on String {
  /// FCMトークン（Firebase Cloud Messaging用プッシュ通知トークン）
  static const fcmToken = 'fcmToken';

  /// APNSトークン（Apple Push Notification Service用プッシュ通知トークン）
  static const apnsToken = 'apnsToken';

  /// Apple Sign-Inで取得したメールアドレス
  static const appleEmail = 'appleEmail';

  /// Apple IDとの連携状態フラグ
  static const isLinkedApple = 'isLinkedApple';

  /// Google Sign-Inで取得したメールアドレス
  static const googleEmail = 'googleEmail';

  /// Google IDとの連携状態フラグ
  static const isLinkedGoogle = 'isLinkedGoogle';

  /// 最新のプレミアムプラン識別子（RevenueCatから取得）
  static const latestPremiumPlanIdentifier = 'latestPremiumPlanIdentifier';

  /// 初回購入日（RevenueCatから取得）
  static const originalPurchaseDate = 'originalPurchaseDate';

  /// アクティブなサブスクリプション情報
  static const activeSubscriptions = 'activeSubscriptions';

  /// エンタイトルメント識別子（RevenueCatの権限管理用）
  static const entitlementIdentifier = 'entitlementIdentifier';

  /// プレミアム機能に関するアンケート回答データ
  static const premiumFunctionSurvey = 'premiumFunctionSurvey';
}

/// Firestoreのpublicコレクション用フィールドキーを定義するextension
/// 一般的なユーザー情報やアプリ設定に関するフィールドのキー名を統一管理
/// 匿名ユーザーとの統合、設定情報、課金ステータスなどの公開データのフィールド名を定数化
extension UserFirestoreFieldKeys on String {
  /// ユーザードキュメントIDセット（履歴管理用）
  static const userDocumentIDSets = 'userDocumentIDSets';

  /// 匿名ユーザーIDセット（匿名ユーザー統合用）
  static const anonymousUserIDSets = 'anonymousUserIDSets';

  /// FirebaseCurrentUserIDセット（認証ユーザー管理用）
  static const firebaseCurrentUserIDSets = 'firebaseCurrentUserIDSets';

  /// ユーザー作成時のユーザーID
  static const userIDWhenCreateUser = 'userIDWhenCreateUser';

  /// 匿名ユーザーID
  static const anonymousUserID = 'anonymousUserID';

  /// アプリ設定情報（Settingエンティティのネストデータ）
  static const settings = 'settings';

  /// パッケージ情報（アプリバージョンなど）
  static const packageInfo = 'packageInfo';

  /// 匿名ユーザーかどうかのフラグ
  static const isAnonymous = 'isAnonymous';

  /// プレミアム会員フラグ
  static const isPremium = 'isPremium';

  /// 課金アプリID（iOS/Androidの識別用）
  static const purchaseAppID = 'purchaseAppID';

  /// トライアル開始日
  static const beginTrialDate = 'beginTrialDate';

  /// トライアル期限日
  static const trialDeadlineDate = 'trialDeadlineDate';

  /// 割引プラン利用期限日
  static const discountEntitlementDeadlineDate =
      'discountEntitlementDeadlineDate';

  /// 解約理由を聞くかどうかのフラグ
  static const shouldAskCancelReason = 'shouldAskCancelReason';

  // バックエンドと状態を同期するためにisTrialをDBにも保存する。trialDeadlineDateから計算する仕様の統一さよりも、ロジックの単純さを優先する。
  // アプリを開かないとトライアルが終了しなくなることについては許容する
  /// トライアル中フラグ（バックエンドとの同期用）
  static const isTrial = 'isTrial';

  // [Pill:TwoTaken] 2錠飲み機能 - 現在一部ユーザーにテスト解放中
  /// 2錠飲み機能有効フラグ
  static const isTwoPillsTakenEnabled = 'isTwoPillsTakenEnabled';
}

/// Pilllアプリのユーザー情報を管理するエンティティクラス
/// Firestoreの users コレクションのドキュメント構造を定義
/// 匿名ユーザーから正規ユーザーへの移行、プレミアム機能、トライアル機能を管理
/// 複数デバイス間でのユーザー統合機能を提供
/// Setting エンティティと1:1の関係でユーザー設定を保持
@freezed
class User with _$User {
  const User._();
  @JsonSerializable(explicitToJson: true)
  const factory User({
    /// ユーザーID（FirebaseのUID）
    String? id,

    /// ユーザー設定情報（Settingエンティティのネストオブジェクト）
    @JsonKey(name: 'settings') Setting? setting,

    /// ユーザー作成時のユーザーID（履歴管理・デバッグ用）
    String? userIDWhenCreateUser,

    /// 匿名ユーザーID（匿名ユーザー統合用）
    String? anonymousUserID,

    /// 統合されたユーザードキュメントIDのリスト
    @Default([]) List<String> userDocumentIDSets,

    /// 統合された匿名ユーザーIDのリスト
    @Default([]) List<String> anonymousUserIDSets,

    /// 統合されたFirebaseCurrentUserIDのリスト
    @Default([]) List<String> firebaseCurrentUserIDSets,

    /// プレミアム会員フラグ（サブスクリプション有効状態）
    @Default(false) bool isPremium,

    /// 解約理由を聞くかどうかのフラグ
    @Default(false) bool shouldAskCancelReason,

    /// アナリティクスのデバッグ機能有効フラグ
    @Default(false) bool analyticsDebugIsEnabled,

    /// トライアル開始日（初回トライアル開始時にセット）
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? beginTrialDate,

    /// トライアル期限日（トライアル期間の終了日時）
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? trialDeadlineDate,

    /// 割引プラン利用期限日（トライアル終了後の割引期間終了日時）
    /// 初期設定未完了または古いバージョンのアプリではnullの場合がある
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    // 初期設定が完了していない or 古いバージョンのアプリではトライアル終了後にバックエンドの定期実行でdiscountEntitlementDeadlineDateの値が入るがそれより前のデータ(=トライアル中) の場合はdiscountEntitlementDeadlineDateがnullになる
    DateTime? discountEntitlementDeadlineDate,

    // [Pill:TwoTaken] 2錠飲み機能 - 現在一部ユーザーにテスト解放中
    /// 2錠飲み機能が有効かどうか
    /// 運営がFirestoreで直接trueに変更して特定ユーザーに解放
    @Default(false) bool isTwoPillsTakenEnabled,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 割引プランの利用権限があるかどうかを判定するgetter
  /// nullの場合はトライアル中として権限ありと判定
  /// 有効期限が現在時刻より後の場合に権限ありと判定
  bool get hasDiscountEntitlement {
    final discountEntitlementDeadlineDate =
        this.discountEntitlementDeadlineDate;
    if (discountEntitlementDeadlineDate == null) {
      return true;
    } else {
      return now().isBefore(discountEntitlementDeadlineDate);
    }
  }

  /// トライアル期間中かどうかを判定するgetter
  /// trialDeadlineDateがnullの場合はトライアル未開始として判定
  /// 有効期限が現在時刻より後の場合にトライアル中として判定
  bool get isTrial {
    final trialDeadlineDate = this.trialDeadlineDate;
    if (trialDeadlineDate == null) {
      return false;
    } else {
      return now().isBefore(trialDeadlineDate);
    }
  }

  /// トライアルが既に開始されているかどうかを判定するgetter
  bool get trialIsAlreadyBegin => beginTrialDate != null;

  /// プレミアム会員またはトライアル中かどうかを判定するgetter
  /// WidgetとHomeWidgetの両方で参照される重要なプロパティ
  // NOTE: [SyncData:Widget] このプロパティはWidgetに同期されてる
  bool get premiumOrTrial => isPremium || isTrial;

  /// トライアル未開始かどうかを判定するgetter
  bool get isNotYetStartTrial => trialDeadlineDate == null;
}
