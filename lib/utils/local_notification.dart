import 'dart:async';

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:riverpod/riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// Reminder Notification
const iOSRecordPillActionIdentifier = "RECORD_PILL";
const iOSQuickRecordPillCategoryIdentifier = "PILL_REMINDER";
const androidReminderNotificationChannelID = "androidReminderNotificationChannelID";
const androidCalendarScheduleNotificationChannelID = "androidCalendarScheduleNotificationChannelID";
const androidReminderNotificationActionIdentifier = "androidReminderNotificationActionIdentifier";
const androidReminderNotificationGroupKey = "androidReminderNotificationGroupKey";

// General Android Notification Setting
// Doc: https://developer.android.com/reference/androidx/core/app/NotificationCompat#CATEGORY_REMINDER()
const androidNotificationCategoryCalendarSchedule = "androidNotificationCategoryCalendarSchedule";

// Notification ID offset
const scheduleNotificationIdentifierOffset = 100000;
const reminderNotificationIdentifierOffset = 1000000000;

// NOTE: It can not be use Future.wait(processes) when register notification.
class LocalNotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }

  Future<void> initialize() async {
    await plugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings(
          "@mipmap/ic_notification",
        ),
        iOS: DarwinInitializationSettings(
          notificationCategories: [
            DarwinNotificationCategory(
              iOSQuickRecordPillCategoryIdentifier,
              actions: [
                DarwinNotificationAction.plain(iOSRecordPillActionIdentifier, "飲んだ"),
              ],
            ),
          ],
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelNotification({required int localNotificationID}) async {
    await plugin.cancel(localNotificationID);
  }

  Future<void> test() async {
    await plugin.zonedSchedule(
      Random().nextInt(1000000),
      'test title',
      'test body',
      tz.TZDateTime.from(now().add(const Duration(minutes: 1)), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          androidReminderNotificationChannelID,
          "服用通知",
          channelShowBadge: true,
          setAsGroupSummary: true,
          groupKey: androidReminderNotificationGroupKey,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
          presentBadge: true,
          sound: "becho.caf",
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<List<PendingNotificationRequest>> pendingReminderNotifications() async {
    final pendingNotifications = await plugin.pendingNotificationRequests();
    return pendingNotifications.where((element) => element.id - reminderNotificationIdentifierOffset > 0).toList();
  }
}

// 必要な状態が全て揃ったら(AsyncData)の時のみ値を返す。そうじゃない場合はnullを返す
final registerReminderLocalNotificationProvider = Provider(
  (ref) => RegisterReminderLocalNotification(ref),
);

// Reminder
// 最新の状態を元に更新すれば良いので、更新処理に必要な状態はプロパティで持つ。このプロパティは通常ref.watchにより常に最新に保たれる
// また、状態をcallの引数として受け取らないことで通常はSingle Stateであるものに対して間違った値を受け取れないようにする
// 以下のように行わずに、手続的に必要な箇所でcallを呼ぶ。なぜなら不意にローカル通知の解除や登録が走ってしまうのはアンコントローラブルだから
// - 各アクションと並行して処理を行わない
// - アクションの結果を受け取ってローカル通知の登録の更新をしない
// - 変更を検知してcallを呼ぶ親Widgetを用意して、変更があれば毎回登録しなおす
// NOTE:
// 現状はテストケースが増えること以外は問題点では無いのでこの方式で行くが、他の方法としてiOSはNotification Service App Extensionを使用した方法がある(Silence Push Notifications)
// Doc: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_usernotifications_filtering#3737535
// Androidの方では元々Kotlinの方で通知のイベントを受け取り出す内容を分けていたので多分同様のことができる(よく調べてない)
// iOSのSilence Push NotificationsやAndroidのKotlin側で受け取り出す方法を使う利点と使わない利点をメモする
// 利点:
// * その時点の状態を元に通知のコンテンツを決定する。という方式を取るためLocal Notificationのスケジュールがシンプルに「毎日 9:00に通知」となる。受け取った通知を元にSwift/Kotlinの方で出すコンテンツを分ける(非表示にもできる)
// * その時点の状態を元に通知のコンテンツを決定する。という方式を取るため、現状の「特定のLocal Notificationに対する変更があった場合にLocal Notificationを更新する」と言ったことを考えなくて良い
// * その時点の状態を元に通知のコンテンツを決定する。という方式を取るため、テストケースがシンプルになる
// 難しい点:
// * Swift/Kotlinのコードが増える。なのでライブリロードも効きづらい
// * iOSのApp Extension側でFlutterのコードを呼ぶ術はない(たぶん)。現状問題ではないがこういう制限がある
//   * これに関連して、SSoTが崩れる心配がある。Keychainを共有してないのもあり、UserDefaultsで書き込み通知の表示に必要なコンテンツを保存する必要がある
// * iOSのApp Extensionでは別途申請が必要になる。これ自体も手間だが、dev版アプリの審査も通す必要があるのが(手間が2回発生するのを避けてる。やればいいだけ)
//   * Thank you for your interest in the Notification Service Extension Filtering entitlement. This entitlement is intended for certain types of apps — such as messaging apps or location sharing apps — that use notification service extensions to receive push notifications without delivering notifications to the user. If your app needs this entitlement in order to properly function on iOS 13.3 or later, provide the following information.
//   * やれば良いだけだと思ったが、App Store URL等を入力しないとダメだからdev版のアプリ通らない可能性が高い
class RegisterReminderLocalNotification {
  final Ref ref;

  RegisterReminderLocalNotification(this.ref);

  static const int registerDays = 10;

  // UseCase:
  // - ピルシート追加
  // - 服用記録
  // - 服用キャンセル
  // - ピルをタップして服用
  // - ピルをタップして服用キャンセル
  // - クイックレコード
  // - 通知の文言を変えた時
  // - 休薬期間の通知のON/OFF
  // - 休薬終了後
  // - 初期設定完了後
  // - FIXME: サインイン → HomePageで通知を登録しなおしているが、必要なエンティティの読み込みよりも先に行われる時がある。だが、ニッチなケースなので一回無視。何かアクションが起きたら登録しなおされるし
  // - 番号変更後
  // - リマインダーの通知がOFF->ONになった時
  // - 連番モードで服用日数の表示を変更した時
  // - ピルシートの表示を変更した時
  // - 久しぶりにアプリを開いたが、通知がスケジュールされていない時
  // - トライアル終了後/プレミアム加入後 → これは服用は続けられているので何もしない。有料機能をしばらく使えてもヨシとする
  // NOTE: 本日分の服用記録がある場合は、本日分の通知はスケジュールしないようになっている
  // 10日間分の通知をスケジュールする
  Future<void> call() async {
    analytics.logEvent(name: "call_register_reminder_notification");
    final cancelReminderLocalNotification = CancelReminderLocalNotification();
    // エンティティの変更があった場合にref.readで最新の状態を取得するために、Future.microtaskで更新を待ってから処理を始める
    // hour,minute,番号を基準にIDを決定しているので、時間変更や番号変更時にそれまで登録されていたIDを特定するのが不可能なので全てキャンセルする
    await (Future.microtask(() => null), cancelReminderLocalNotification()).wait;
    analytics.logEvent(name: "cancel_reminder_notification");

    final pillSheetGroup = ref.read(latestPillSheetGroupProvider).asData?.valueOrNull;
    final activePillSheet = ref.read(activePillSheetProvider).asData?.valueOrNull;
    final premiumOrTrial = ref.read(premiumAndTrialProvider).asData?.valueOrNull?.premiumOrTrial;
    final setting = ref.read(settingProvider).asData?.valueOrNull;
    final user = ref.read(userProvider).asData?.valueOrNull;
    if (pillSheetGroup == null || activePillSheet == null || premiumOrTrial == null || setting == null || user == null) {
      return;
    }
    if (!user.useLocalNotificationForReminder) {
      return;
    }

    await run(
      pillSheetGroup: pillSheetGroup,
      activePillSheet: activePillSheet,
      premiumOrTrial: premiumOrTrial,
      setting: setting,
    );
  }

  static Future<void> run({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
    required bool premiumOrTrial,
    required Setting setting,
  }) async {
    analytics.logEvent(name: "run_register_reminder_notification", parameters: {
      "todayPillNumber": activePillSheet.todayPillNumber,
      "todayPillIsAlreadyTaken": activePillSheet.todayPillIsAlreadyTaken,
      "lastTakenPillNumber": activePillSheet.lastTakenPillNumber,
      "reminderTimes": setting.reminderTimes.toString(),
    });
    final tzNow = tz.TZDateTime.now(tz.local);
    final List<Future<void>> futures = [];

    debugPrint("tzNow:$tzNow, tz.local:${tz.local}");

    for (final reminderTime in setting.reminderTimes) {
      // 新規ピルシートグループの作成後に通知のスケジュールができないため、多めに通知をスケジュールする
      // ユーザーの何かしらのアクションでどこかでスケジュールされるだろう
      for (final offset in List.generate(registerDays, (index) => index)) {
        // 本日服用済みの場合はスキップする
        if (offset == 0 && activePillSheet.todayPillIsAlreadyTaken) {
          continue;
        }

        final reminderDateTime =
            tzNow.date().add(Duration(days: offset)).add(Duration(hours: reminderTime.hour)).add(Duration(minutes: reminderTime.minute));
        if (reminderDateTime.isBefore(tzNow)) {
          continue;
        }
        debugPrint("==== reminderDate:$reminderDateTime ===");

        // 跨いでも1ピルシート分だけなので、今日の日付起点で考えて今処理しているループがactivePillSheetの次かどうかを判別し、処理中の「ピルシート中のピル番号」を計算して使用する
        final isOverActivePillSheet = activePillSheet.todayPillNumber + offset > activePillSheet.typeInfo.totalCount;
        final pillNumberInPillSheet = isOverActivePillSheet
            ? activePillSheet.todayPillNumber + offset - activePillSheet.typeInfo.totalCount
            : activePillSheet.todayPillNumber + offset;
        debugPrint(
            "activePillSheet.todayPillNumber: ${activePillSheet.todayPillNumber}, offset: $offset, activePillSheet.typeInfo.totalCount: ${activePillSheet.typeInfo.totalCount}, isOverActivePillSheet:$isOverActivePillSheet, pillNumberInPillSheet:$pillNumberInPillSheet");

        var pillSheetGroupIndex = activePillSheet.groupIndex;
        var pillSheeType = activePillSheet.pillSheetType;
        var pillSheetDisplayNumber = pillSheetGroup.displayPillNumber(
          premiumOrTrial: premiumOrTrial,
          pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
          pageIndex: activePillSheet.groupIndex,
          pillNumberInPillSheet: pillNumberInPillSheet,
        );

        // activePillSheetよりも未来のPillSheet
        if (isOverActivePillSheet) {
          final isLastPillSheet = (pillSheetGroup.pillSheets.length - 1) == activePillSheet.groupIndex;

          switch ((isLastPillSheet, premiumOrTrial, setting.isAutomaticallyCreatePillSheet)) {
            case (true, true, true):
              // 次のピルシートグループの処理。新しいシート自動作成の場合の先読み追加
              final nextPillSheetGroup = buildPillSheetGroup(
                setting: setting,
                pillSheetGroup: pillSheetGroup,
                pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
                displayNumberSetting: null,
                // 二度飲みかどうかは、考慮しなくて良いのでfalse
                takesTwicePerDay: false,
              );
              pillSheetDisplayNumber = nextPillSheetGroup.displayPillNumber(
                premiumOrTrial: premiumOrTrial,
                pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
                pageIndex: 0,
                pillNumberInPillSheet: pillNumberInPillSheet,
              );
              final nextPillSheetGroupFirstPillSheet = nextPillSheetGroup.pillSheets.first;
              pillSheetGroupIndex = nextPillSheetGroupFirstPillSheet.groupIndex;
              pillSheeType = nextPillSheetGroupFirstPillSheet.pillSheetType;
            case (false, _, _):
              // 次のピルシートを使用する場合
              final nextPillSheet = pillSheetGroup.pillSheets[activePillSheet.groupIndex + 1];
              pillSheetGroupIndex = nextPillSheet.groupIndex;
              pillSheeType = nextPillSheet.pillSheetType;
              pillSheetDisplayNumber = pillSheetGroup.displayPillNumber(
                premiumOrTrial: premiumOrTrial,
                pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
                pageIndex: nextPillSheet.groupIndex,
                pillNumberInPillSheet: pillNumberInPillSheet,
              );

            case (_, _, _):
              // 次のピルシートグループもピルシートも使用しない場合はループをスキップ
              continue;
          }
        }

        // 偽薬/休薬期間中の通知がOFFの場合はスキップする
        if (!setting.isOnNotifyInNotTakenDuration) {
          if (pillSheeType.dosingPeriod < pillNumberInPillSheet) {
            continue;
          }
        }

        // IDの計算には本来のピル番号を使用する。表示用の番号だと今後も設定によりズレる可能性があるため
        // また、_calcLocalNotificationIDの中で、本来のピル番号を使用していることを前提としている(2桁までを想定している)
        final notificationID = _calcLocalNotificationID(
          pillSheetGroupIndex: pillSheetGroupIndex,
          reminderTime: reminderTime,
          pillNumberInPillSheet: pillNumberInPillSheet,
        );

        if (premiumOrTrial) {
          final title = () {
            var result = setting.reminderNotificationCustomization.word;
            if (!setting.reminderNotificationCustomization.isInVisibleReminderDate) {
              result += " ";
              result += "${reminderDateTime.month}/${reminderDateTime.day} (${WeekdayFunctions.weekdayFromDate(reminderDateTime).weekdayString()})";
            }

            if (!setting.reminderNotificationCustomization.isInVisiblePillNumber) {
              result += " ";
              result += pillSheetDisplayNumber;
              result += switch (setting.pillSheetAppearanceMode) {
                PillSheetAppearanceMode.number || PillSheetAppearanceMode.sequential => "番",
                PillSheetAppearanceMode.date => "日目",
              };
            }

            if (Environment.isDevelopment) {
              result += " Local";
            }
            return result;
          }();
          debugPrint("title:$title");

          futures.add(
            Future(() async {
              try {
                await localNotificationService.plugin.zonedSchedule(
                  notificationID,
                  title,
                  '',
                  reminderDateTime,
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      androidReminderNotificationChannelID,
                      "服用通知",
                      channelShowBadge: true,
                      setAsGroupSummary: true,
                      groupKey: androidReminderNotificationGroupKey,
                      category: AndroidNotificationCategory.alarm,
                      actions: [
                        AndroidNotificationAction(
                          androidReminderNotificationActionIdentifier,
                          "飲んだ",
                        )
                      ],
                    ),
                    iOS: DarwinNotificationDetails(
                      categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
                      presentBadge: true,
                      sound: "becho.caf",
                      presentSound: true,
                    ),
                  ),
                  androidAllowWhileIdle: true,
                  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
                );
              } catch (e, st) {
                // NOTE: エラーが発生しても他の通知のスケジュールを続ける
                debugPrint("[bannzai] notificationID:$notificationID error:$e, stackTrace:$st");
              }
            }),
          );
        } else {
          var title = "💊の時間です";
          if (Environment.isDevelopment) {
            title += " (Local)";
          }
          futures.add(
            Future(() async {
              try {
                await localNotificationService.plugin.zonedSchedule(
                  notificationID,
                  title,
                  '',
                  reminderDateTime,
                  const NotificationDetails(
                    android: AndroidNotificationDetails(
                      androidReminderNotificationChannelID,
                      "服用通知",
                      channelShowBadge: true,
                      setAsGroupSummary: true,
                      groupKey: androidReminderNotificationGroupKey,
                      category: AndroidNotificationCategory.alarm,
                    ),
                    iOS: DarwinNotificationDetails(
                      categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
                      presentBadge: true,
                      sound: "becho.caf",
                      presentSound: true,
                    ),
                  ),
                  uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
                );
              } catch (e, st) {
                // NOTE: エラーが発生しても他の通知のスケジュールを続ける
                debugPrint("[bannzai] notificationID:$notificationID error:$e, stackTrace:$st");
              }
            }),
          );
        }
      }
    }

    await Future.wait(futures);

    debugPrint("end scheduleRemiderNotification: ${setting.reminderTimes}, futures.length:${futures.length}");
  }

  // reminder time id is 10{groupIndex:2}{hour:2}{minute:2}{pillNumberInPillSheet:2}
  // for example return value 1002223014 means,  `10` is prefix, gropuIndex: `02` is third pillSheet,`22` is hour, `30` is minute, `14` is pill number into pill sheet
  // 1000000000 = reminderNotificationIdentifierOffset
  // 10000000 = pillSheetGroupIndex
  // 100000 = reminderTime.hour
  // 1000 = reminderTime.minute
  // 10 = pillNumberInPillSheet
  static int _calcLocalNotificationID({
    required int pillSheetGroupIndex,
    required ReminderTime reminderTime,
    required int pillNumberInPillSheet,
  }) {
    final groupIndex = pillSheetGroupIndex * 10000000;
    final hour = reminderTime.hour * 100000;
    final minute = reminderTime.minute * 1000;
    return reminderNotificationIdentifierOffset + groupIndex + hour + minute + pillNumberInPillSheet;
  }
}

final cancelReminderLocalNotificationProvider = Provider((ref) => CancelReminderLocalNotification());

class CancelReminderLocalNotification {
  // Usecase
  // - ピルシートグループを削除された時
  // - 通知をOFFにした時
  // - 退会
  // これら以外はRegisterReminderLocalNotificationで登録し直す。なおRegisterReminderLocalNotification の内部でこの関数を読んでいる
  Future<void> call() async {
    final pendingNotifications = await localNotificationService.pendingReminderNotifications();
    await Future.wait(pendingNotifications.map((p) => localNotificationService.cancelNotification(localNotificationID: p.id)));
  }
}

// Schedule
extension ScheduleLocalNotificationService on LocalNotificationService {
  Future<void> scheduleCalendarScheduleNotification({
    required Schedule schedule,
  }) async {
    final localNotification = schedule.localNotification;
    if (localNotification != null) {
      final remindDate = tz.TZDateTime.from(localNotification.remindDateTime, tz.local);
      debugPrint("$remindDate");
      await plugin.zonedSchedule(
        localNotification.localNotificationID,
        "本日の予定です",
        schedule.title,
        remindDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            androidCalendarScheduleNotificationChannelID,
            "カレンダーの予定",
            groupKey: null,
            category: AndroidNotificationCategory.alarm,
          ),
          iOS: DarwinNotificationDetails(
            sound: "becho.caf",
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}

final localNotificationService = LocalNotificationService()..initialize();
