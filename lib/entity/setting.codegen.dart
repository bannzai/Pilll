import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/reminder_notification_customization.codegen.dart';

part 'setting.codegen.g.dart';
part 'setting.codegen.freezed.dart';

/// ピル服用リマインダーの時刻を管理するEntity
///
/// 時（hour）と分（minute）で構成される服用リマインダー時刻を表現します。
/// Settingエンティティの一部としてFirestoreに保存され、
/// LocalNotificationServiceでリマインダー通知の生成に使用されます。
/// 複数設定可能で、最大3件まで登録できます。
@freezed
class ReminderTime with _$ReminderTime {
  const ReminderTime._();
  @JsonSerializable(explicitToJson: true)
  const factory ReminderTime({
    /// 時刻の時（24時間形式）
    ///
    /// 0-23の範囲で指定します。
    /// リマインダー通知の生成時刻として使用されます。
    required int hour,

    /// 時刻の分
    ///
    /// 0-59の範囲で指定します。
    /// リマインダー通知の生成時刻として使用されます。
    required int minute,
  }) = _ReminderTime;

  factory ReminderTime.fromJson(Map<String, dynamic> json) => _$ReminderTimeFromJson(json);

  /// 現在日付を基準にしたDateTime型の時刻を生成する
  ///
  /// hour、minuteの値を使用して今日の該当時刻のDateTimeオブジェクトを作成します。
  /// リマインダー通知のスケジュール設定で使用されます。
  DateTime dateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(
      t.year,
      t.month,
      t.day,
      hour,
      minute,
      t.second,
      t.millisecond,
      t.microsecond,
    );
  }

  /// 設定可能な最大リマインダー時刻数
  ///
  /// ユーザーが設定できるリマインダー時刻の上限値です。
  static const int maximumCount = 3;

  /// 設定必須の最小リマインダー時刻数
  ///
  /// ユーザーが必ず設定する必要があるリマインダー時刻の下限値です。
  static const int minimumCount = 1;
}

/// Firestore操作で使用するSettingエンティティのフィールド名定数
///
/// Firestoreのクエリやドキュメント操作で使用するフィールド名を定義します。
/// 文字列の typo を防ぎ、フィールド名変更時のメンテナンス性を向上させます。
class SettingFirestoreFieldKeys {
  /// ピルシート外観モードのフィールド名
  ///
  /// Firestoreのsettingsコレクションでピルシート表示モードを
  /// 管理するためのフィールド名です。
  static const pillSheetAppearanceMode = 'pillSheetAppearanceMode';

  /// タイムゾーンデータベース名のフィールド名
  ///
  /// Firestoreのsettingsコレクションでユーザーのタイムゾーン設定を
  /// 管理するためのフィールド名です。
  static const timezoneDatabaseName = 'timezoneDatabaseName';
}

/// アプリの設定情報を管理するメインEntity
///
/// ユーザーの設定項目をFirestoreで永続化するためのデータ構造です。
/// ピルシートタイプ、服用リマインダー、通知設定、生理周期設定など
/// アプリの全体的な設定情報を一元管理します。
/// Riverpodの状態管理と連携してアプリ全体で使用されます。
@freezed
class Setting with _$Setting {
  const Setting._();
  @JsonSerializable(explicitToJson: true)
  const factory Setting({
    /// ユーザーが使用するピルシートタイプのリスト
    ///
    /// 複数のピルシートを管理する場合に使用します。
    /// PillSheetTypeのenumで定義された値を格納し、
    /// ピルシートUI表示やサイクル計算に使用されます。
    @Default([]) List<PillSheetType?> pillSheetTypes,

    /// 生理開始からの日数設定
    ///
    /// 生理開始日から何日目でピル服用を開始するかを定義します。
    /// 生理周期計算や次回生理日予測に使用される重要なパラメータです。
    required int pillNumberForFromMenstruation,

    /// 生理期間の日数
    ///
    /// ユーザーの平均的な生理期間を日数で定義します。
    /// 生理日記機能や生理予測機能で使用されます。
    required int durationMenstruation,

    /// 服用リマインダー時刻のリスト
    ///
    /// ReminderTimeオブジェクトのリストとして格納されます。
    /// 最大3件まで設定可能で、通知スケジューリングに使用されます。
    @Default([]) List<ReminderTime> reminderTimes,

    /// リマインダー通知の有効/無効フラグ
    ///
    /// trueの場合、設定されたreminderTimesに基づいて通知が送信されます。
    /// falseの場合、リマインダー通知は送信されません。
    required bool isOnReminder,

    /// 飲み忘れ期間中の通知有効フラグ
    ///
    /// trueの場合、飲み忘れが検出されたときに追加の通知を送信します。
    /// デフォルトはtrueで有効化されています。
    @Default(true) bool isOnNotifyInNotTakenDuration,

    /// ピルシート自動作成機能の有効フラグ
    ///
    /// trueの場合、現在のピルシートが終了したときに
    /// 新しいピルシートを自動的に作成します。デフォルトはfalseです。
    @Default(false) bool isAutomaticallyCreatePillSheet,

    /// リマインダー通知のカスタマイゼーション設定
    ///
    /// 通知タイトル、メッセージ、表示項目などのカスタマイズ設定です。
    /// デフォルトでReminderNotificationCustomizationの初期値が設定されます。
    @Default(ReminderNotificationCustomization()) ReminderNotificationCustomization reminderNotificationCustomization,

    /// 緊急アラート機能の有効フラグ
    ///
    /// trueの場合、重要な通知を緊急アラートとして送信します。
    /// iOSのCritical Alertなど、端末の音量設定を無視した通知に使用されます。
    @Default(false) bool useCriticalAlert,

    /// 緊急アラートの音量レベル
    ///
    /// 0.0-1.0の範囲で緊急アラート時の音量を指定します。
    /// デフォルトは0.5（50%）に設定されています。
    @Default(0.5) double criticalAlertVolume,

    /// AlarmKit機能の有効フラグ
    ///
    /// trueの場合、iOS 26+でAlarmKitを使用して服薬リマインダーを送信します。
    /// サイレントモード・フォーカスモード時でも確実に通知が表示されます。
    /// iOS 26未満やAndroidでは既存のlocal notificationが使用されます。
    @Default(false) bool useAlarmKit,

    /// ユーザーのタイムゾーンデータベース名
    ///
    /// timezone パッケージで使用されるタイムゾーン識別子です。
    /// nullの場合は端末のローカルタイムゾーンが使用されます。
    required String? timezoneDatabaseName,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);

  // NOTE: v3.9.6 で PillSheetType.pillsheet_24_rest_4 を含めた状態でのコード生成をしていなかった
  // 本来初期設定でpillsheet_24_rest_4を選択したユーザーの pillSheetTypes の値が null が入ってしまっている
  /// 後方互換性を保持したピルシートタイプリストを取得する
  ///
  /// pillSheetTypesにnullが含まれている場合、
  /// backportPillSheetTypes関数を通してpillsheet_24_rest_4で補完します。
  /// v3.9.6での不具合対応のための互換性メソッドです。
  List<PillSheetType> get pillSheetEnumTypes {
    return backportPillSheetTypes(pillSheetTypes);
  }

  /// 設定されたリマインダー時刻の中で最も早い時刻を取得する
  ///
  /// reminderTimesが空の場合はnullを返します。
  /// 複数のリマインダー時刻が設定されている場合、
  /// 時→分の順で比較し最も早い時刻を返します。
  /// デイリータスクのスケジューリングで使用されます。
  ReminderTime? get earlyReminderTime {
    if (reminderTimes.isEmpty) {
      return null;
    }
    return reminderTimes.reduce((value, element) {
      if (value.hour < element.hour) {
        return value;
      }
      if (value.hour == element.hour && value.minute < element.minute) {
        return value;
      }
      return element;
    });
  }
}

/// ピルシートタイプリストの後方互換性を保証する関数
///
/// List<PillSheetType?>からList<PillSheetType>に変換し、
/// null要素をPillSheetType.pillsheet_24_rest_4で置換します。
/// v3.9.6での不具合により発生したnull値への対処として実装されています。
List<PillSheetType> backportPillSheetTypes(
  List<PillSheetType?> pillSheetTypes,
) {
  return pillSheetTypes.map((e) => e ?? PillSheetType.pillsheet_24_rest_4).toList();
}
