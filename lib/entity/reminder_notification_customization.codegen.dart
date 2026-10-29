import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/emoji/emoji.dart';

part 'reminder_notification_customization.codegen.g.dart';
part 'reminder_notification_customization.codegen.freezed.dart';

/// ピル服用リマインダー通知のカスタマイゼーション設定を管理するEntity
///
/// ユーザーが通知の表示内容や文言をカスタマイズするための設定情報を保持します。
/// Settingエンティティの一部としてFirestoreに保存され、
/// 実際の通知生成時にLocalNotificationServiceで参照されます。
///
/// バージョン管理機能を持ち、機能追加時の後方互換性を保証します。
@freezed
class ReminderNotificationCustomization with _$ReminderNotificationCustomization {
  @JsonSerializable(explicitToJson: true)
  const factory ReminderNotificationCustomization({
    /// 設定のバージョン番号
    ///
    /// 新機能追加時の後方互換性を保つためのバージョン管理に使用されます。
    /// 現在の最新バージョンは'v2'です。
    @Default('v2') String version,

    /// 通知タイトルの冒頭に表示される文字
    ///
    /// 通知のタイトル部分に表示される絵文字や文字を設定します。
    /// デフォルトは💊絵文字が設定されています。
    @Default(pillEmoji) String word,

    /// 通知に日付表示を含めるかどうかの制御フラグ
    ///
    /// trueの場合、通知タイトルに日付（例: 8/14 (水)）を表示しません。
    /// falseの場合、通知タイトルに日付を表示します。
    @Default(false) bool isInVisibleReminderDate,

    /// 通知にピル番号表示を含めるかどうかの制御フラグ
    ///
    /// trueの場合、通知タイトルにピル番号（例: 15番目）を表示しません。
    /// falseの場合、通知タイトルにピル番号を表示します。
    @Default(false) bool isInVisiblePillNumber,

    /// 通知に説明文を含めるかどうかの制御フラグ
    ///
    /// trueの場合、通知の説明文（メッセージ本文）を表示しません。
    /// falseの場合、dailyTakenMessageまたはmissedTakenMessageが表示されます。
    @Default(false) bool isInVisibleDescription,

    // BEGIN: From v2
    /// 日々の服用時に表示するメッセージ
    ///
    /// v2で追加された機能です。通常の服用リマインダー時に表示される
    /// カスタマイズ可能なメッセージです。
    @Default('') String dailyTakenMessage,

    /// 飲み忘れ時に表示するメッセージ
    ///
    /// v2で追加された機能です。複数日の飲み忘れが検出された場合に
    /// 表示されるメッセージです。表示には [resolvedMissedTakenMessage] を使います。
    /// 既定の文言はロケールごとに変わるため entity には埋めず、空文字で「未設定」を表します。
    @Default('') String missedTakenMessage,
    // END: From v2
  }) = _ReminderNotificationCustomization;
  const ReminderNotificationCustomization._();

  /// 通知と設定画面に表示する飲み忘れ時のメッセージ
  ///
  /// [missedTakenMessage] が未設定 (空文字) の時は、端末のロケールの既定文言を返します。
  /// 保存済みの値がある時はその値を返します。
  String get resolvedMissedTakenMessage => missedTakenMessage.isEmpty ? L.defaultMissedTakenMessage : missedTakenMessage;

  factory ReminderNotificationCustomization.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ReminderNotificationCustomizationFromJson(json);
}
