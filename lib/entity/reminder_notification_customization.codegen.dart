import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/emoji/emoji.dart';

part 'reminder_notification_customization.codegen.g.dart';
part 'reminder_notification_customization.codegen.freezed.dart';

/// 飲み忘れ時のメッセージの既定値 (日本語)
///
/// v2 の追加時からこの文字列を既定値として Firestore に保存してきたため、ロケールに関わらず値を変えない。
/// 保存値がこの文字列と一致するものは未編集とみなし、表示時にロケールの既定文言 (L.defaultMissedTakenMessage) に置き換える
const reminderNotificationCustomizationJapaneseDefaultMissedTakenMessage = '飲み忘れていませんか？\n服用記録がない日が複数あります$thinkingFaceEmoji';

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
    /// 表示されるメッセージです。表示には missedTakenMessageForDisplay を使います。
    @Default(reminderNotificationCustomizationJapaneseDefaultMissedTakenMessage) String missedTakenMessage,
    // END: From v2
  }) = _ReminderNotificationCustomization;
  const ReminderNotificationCustomization._();

  /// 通知と通知文言カスタマイズ画面に表示する飲み忘れ時のメッセージ
  ///
  /// 保存値が日本語の既定値のまま (未編集) ならロケールの既定文言を返し、それ以外は保存値を返す。
  /// 保存値そのものは書き換えない
  String get missedTakenMessageForDisplay =>
      missedTakenMessage == reminderNotificationCustomizationJapaneseDefaultMissedTakenMessage ? L.defaultMissedTakenMessage : missedTakenMessage;

  factory ReminderNotificationCustomization.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ReminderNotificationCustomizationFromJson(json);
}
