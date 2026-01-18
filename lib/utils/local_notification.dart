import 'dart:async';
import 'dart:io';

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/entrypoint.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/alarm_kit_service.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:riverpod/riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';

// Reminder Notification
const actionIdentifier = 'RECORD_PILL';
const iOSQuickRecordPillCategoryIdentifier = 'PILL_REMINDER';
const androidReminderNotificationChannelID = 'androidReminderNotificationChannelID';
const androidCalendarScheduleNotificationChannelID = 'androidCalendarScheduleNotificationChannelID';
const androidReminderNotificationGroupKey = 'androidReminderNotificationGroupKey';

// General Android Notification Setting
// Doc: https://developer.android.com/reference/androidx/core/app/NotificationCompat#CATEGORY_REMINDER()
const androidNotificationCategoryCalendarSchedule = 'androidNotificationCategoryCalendarSchedule';

// Notification ID offset
const fallbackNotificationIdentifier = 1;
const newPillSheetNotificationIdentifier = 2;
const scheduleNotificationIdentifierOffset = 100000;
const reminderNotificationIdentifierOffset = 1000000000;

// NOTE: It can not be use Future.wait(processes) when register notification.
class LocalNotificationService {
  final plugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(await FlutterTimezone.getLocalTimezone()));
  }

  Future<void> initialize() async {
    await plugin.initialize(
      InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_notification'),
        iOS: DarwinInitializationSettings(
          notificationCategories: [
            DarwinNotificationCategory(iOSQuickRecordPillCategoryIdentifier, actions: [DarwinNotificationAction.plain(actionIdentifier, L.taken)]),
          ],
          // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
          // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
          defaultPresentAlert: false,
          defaultPresentBadge: true,
          defaultPresentSound: true,
          defaultPresentBanner: true,
          defaultPresentList: true,
        ),
      ),
      onDidReceiveBackgroundNotificationResponse: Platform.isAndroid ? handleNotificationAction : null,
    );
  }

  Future<void> requestiOSPermission() async {
    plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
    );
  }

  Future<bool?> requestPermissionWithCriticalAlert() async {
    return await plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      sound: true,
      badge: true,
      alert: true,
      provisional: true,
      critical: true,
    );
  }

  // iOSでは 以下の二つを実行しているだけなので今のところエラーは発生しない
  // center.removePendingNotificationRequests(withIdentifiers: ids), center.removeDeliveredNotifications(withIdentifiers: ids)
  Future<void> cancelNotification({required int localNotificationID}) async {
    await plugin.cancel(localNotificationID);
  }

  Future<void> test() async {
    await plugin.zonedSchedule(
      Random().nextInt(1000000),
      'test title',
      'test body',
      tz.TZDateTime.from(now().add(const Duration(minutes: 1)), tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidReminderNotificationChannelID,
          L.takePillReminderChannelName,
          channelShowBadge: true,
          setAsGroupSummary: true,
          groupKey: androidReminderNotificationGroupKey,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: const DarwinNotificationDetails(
          categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
          sound: 'becho.caf',
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  Future<void> testCriticalAlert({required double volume}) async {
    await plugin.zonedSchedule(
      Random().nextInt(1000000),
      '通知のテスト',
      'これは通知のテストです',
      tz.TZDateTime.from(now().add(const Duration(seconds: 2)), tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidReminderNotificationChannelID,
          L.takePillReminderChannelName,
          channelShowBadge: true,
          setAsGroupSummary: true,
          groupKey: androidReminderNotificationGroupKey,
          category: AndroidNotificationCategory.reminder,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
          criticalSoundVolume: volume,
          sound: null,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // iOSではgetPendingNotificationRequestsWithCompletionHandlerを実行しているだけなのでおそらくエラーは発生しない
  Future<List<PendingNotificationRequest>> pendingReminderNotifications() async {
    final pendingNotifications = await plugin.pendingNotificationRequests();
    return pendingNotifications.where((element) => element.id - reminderNotificationIdentifierOffset > 0).toList();
  }

  // iOSではgetPendingNotificationRequestsWithCompletionHandlerを実行しているだけなのでおそらくエラーは発生しない
  Future<List<PendingNotificationRequest>> pendingNewPillSheetNotifications() async {
    final pendingNotifications = await plugin.pendingNotificationRequests();
    return pendingNotifications.where((element) => element.id == newPillSheetNotificationIdentifier).toList();
  }
}

// 必要な状態が全て揃ったら(AsyncData)の時のみ値を返す。そうじゃない場合はnullを返す
final registerReminderLocalNotificationProvider = Provider((ref) => RegisterReminderLocalNotification(ref));

// Reminder
// 最新の状態を元に更新すれば良いので、更新処理に必要な状態はプロパティで持つ。このプロパティは通常ref.watchにより常に最新に保たれる
// また、状態をcallの引数として受け取らないことで通常はSingle Stateであるものに対して間違った値を受け取れないようにする
// 以下のように行わずに、手続的に必要な箇所でcallを呼ぶ。なぜなら不意にローカル通知の解除や登録が走ってしまうのはアンコントローラブルだから
// - 各アクションと並行して処理を行わない
// - アクションの結果を受け取ってローカル通知の登録の更新をしない
// - 変更を検知してcallを呼ぶ親Widgetを用意して、変更があれば毎回登録しなおす → クイックレコードの場合なども考慮に入れる必要がある。それらの処理でWidgetが起動しているかどうか定かでは無いのでやらない
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
// * iOSのApp Extensionでは別途申請が必要になる。これ自体も手間だが、dev版アプリの審査も通す必要があるのが(手間が2回発生するのを避けてる。やればいいだけ)
//   * Thank you for your interest in the Notification Service Extension Filtering entitlement. This entitlement is intended for certain types of apps — such as messaging apps or location sharing apps — that use notification service extensions to receive push notifications without delivering notifications to the user. If your app needs this entitlement in order to properly function on iOS 13.3 or later, provide the following information.
//   * やれば良いだけだと思ったが、App Store URL等を入力しないとダメだからdev版のアプリ通らない可能性が高い
//   * 追記: そもそもリモートの通知で絵しかこれは使えないかも: This entitlement allows a notification service extension to receive remote notifications without displaying the notification to the user. To apply for this entitlement, see Request Notification Service Entitlement.
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
  // - 服用お休み終了
  // - 休薬期間の通知のON/OFF
  // - 休薬終了後
  // - 初期設定完了後
  // - NOTE: サインイン → HomePageで通知を登録しなおしているが、必要なエンティティの読み込みよりも先に行われる時がある。だが、ニッチなケースなので一回無視。何かアクションが起きたら登録しなおされるし
  // - 番号変更後
  // - リマインダーの通知がOFF->ONになった時
  // - 連番モードで服用日数の表示を変更した時
  // - ピルシートの表示を変更した時
  // - 久しぶりにアプリを開いたが、通知がスケジュールされていない時
  // - トライアル終了後/プレミアム加入後 → これは服用は続けられているので何もしない。有料機能をしばらく使えてもヨシとする
  // - CriticalAlertの設定が変更された時
  // NOTE: 本日分の服用記録がある場合は、本日分の通知はスケジュールしないようになっている
  // 10日間分の通知をスケジュールする
  // ちなみに64個までのリミットがある
  //   * `There is a limit imposed by iOS where it will only keep 64 notifications that will fire the soonest.`
  //   * ref: https://pub.dev/packages/flutter_local_notifications#-caveats-and-limitations
  Future<void> call() async {
    analytics.debug(name: 'call_register_reminder_notification');
    final cancelReminderLocalNotification = CancelReminderLocalNotification();
    // エンティティの変更があった場合にref.readで最新の状態を取得するために、Future.microtaskで更新を待ってから処理を始める
    // hour,minute,番号を基準にIDを決定しているので、時間変更や番号変更時にそれまで登録されていたIDを特定するのが不可能なので全てキャンセルする
    await (Future.microtask(() => null), cancelReminderLocalNotification()).wait;
    analytics.debug(name: 'cancel_reminder_notification');

    final pillSheetGroup = ref.read(latestPillSheetGroupProvider).asData?.valueOrNull;
    final activePillSheet = ref.read(activePillSheetProvider).asData?.valueOrNull;
    final premiumOrTrial = ref.read(userProvider).asData?.valueOrNull?.premiumOrTrial;
    final setting = ref.read(settingProvider).asData?.valueOrNull;
    final user = ref.read(userProvider).asData?.valueOrNull;
    if (pillSheetGroup == null || activePillSheet == null || premiumOrTrial == null || setting == null || user == null) {
      return;
    }

    await run(pillSheetGroup: pillSheetGroup, activePillSheet: activePillSheet, premiumOrTrial: premiumOrTrial, setting: setting);
  }

  static Future<void> run({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
    required bool premiumOrTrial,
    required Setting setting,
  }) async {
    if (!setting.isOnReminder) {
      return;
    }
    if (pillSheetGroup.lastActiveRestDuration != null) {
      return;
    }

    // AlarmKit使用判定
    final useAlarmKit = setting.useAlarmKit && await AlarmKitService.isAvailable();

    analytics.debug(
      name: 'run_register_reminder_notification',
      parameters: {
        'todayPillNumber': activePillSheet.todayPillNumber,
        'todayPillIsAlreadyTaken': activePillSheet.todayPillIsAlreadyTaken,
        'lastTakenPillNumber': activePillSheet.lastTakenOrZeroPillNumber,
        'reminderTimes': setting.reminderTimes.toString(),
        'useAlarmKit': useAlarmKit,
      },
    );
    final tzNow = tz.TZDateTime.now(tz.local);
    final List<Future<void>> futures = [];

    final badgeNumber = activePillSheet.todayPillNumber - activePillSheet.lastTakenOrZeroPillNumber;
    final todayPillAllTaken = switch (activePillSheet) {
      PillSheetV1 v1 => v1.todayPillIsAlreadyTaken,
      PillSheetV2 v2 => v2.todayPillAllTaken,
    };

    for (final reminderTime in setting.reminderTimes) {
      // 新規ピルシートグループの作成後に通知のスケジュールができないため、多めに通知をスケジュールする
      // ユーザーの何かしらのアクションでどこかでスケジュールされるだろう
      for (final dayOffset in List.generate(registerDays, (index) => index)) {
        // 本日服用済みの場合はスキップする
        if (dayOffset == 0 && todayPillAllTaken) {
          analytics.debug(
            name: 'rrrn_skip_already_taken',
            parameters: {
              'dayOffset': dayOffset,
              'todayPillAllTaken': todayPillAllTaken,
              'reminderTimeHour': reminderTime.hour,
              'reminderTimeMinute': reminderTime.minute,
            },
          );
          continue;
        }

        final reminderDateTime = tzNow.date().addDays(dayOffset).add(Duration(hours: reminderTime.hour)).add(Duration(minutes: reminderTime.minute));
        if (reminderDateTime.isBefore(tzNow)) {
          analytics.debug(
            name: 'rrrn_is_before_now',
            parameters: {
              'dayOffset': dayOffset,
              'tzNow': tzNow,
              'reminderDateTime': reminderDateTime,
              'reminderTimeHour': reminderTime.hour,
              'reminderTimeMinute': reminderTime.minute,
            },
          );
          continue;
        }

        // 跨いでも1ピルシート分だけなので、今日の日付起点で考えて今処理しているループがactivePillSheetの次かどうかを判別し、処理中の「ピルシート中のピル番号」を計算して使用する
        final isOverActivePillSheet = activePillSheet.todayPillNumber + dayOffset > activePillSheet.typeInfo.totalCount;
        final pillNumberInPillSheet = isOverActivePillSheet
            ? activePillSheet.todayPillNumber + dayOffset - activePillSheet.typeInfo.totalCount
            : activePillSheet.todayPillNumber + dayOffset;

        var pillSheetGroupIndex = activePillSheet.groupIndex;
        var pillSheeType = activePillSheet.pillSheetType;
        var pillSheetDisplayNumber = pillSheetGroup.displayPillNumberWithoutDate(
          pageIndex: activePillSheet.groupIndex,
          pillNumberInPillSheet: pillNumberInPillSheet,
        );

        // activePillSheetよりも未来のPillSheet
        if (isOverActivePillSheet) {
          final isLastPillSheet = (pillSheetGroup.pillSheets.length - 1) == activePillSheet.groupIndex;

          switch ((isLastPillSheet, premiumOrTrial, setting.isAutomaticallyCreatePillSheet)) {
            case (true, true, true):
              // 次のピルシートグループの処理。新しいシート自動作成の場合の先読み追加
              // 現在のアクティブなピルシートからpillTakenCountを取得（v1の場合は1）
              final currentPillTakenCount = switch (activePillSheet) {
                PillSheetV1() => 1,
                PillSheetV2 v2 => v2.pills.first.takenCount,
              };
              final nextPillSheetGroup = buildPillSheetGroup(
                setting: setting,
                pillSheetGroup: pillSheetGroup,
                pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
                displayNumberSetting: null,
                pillTakenCount: currentPillTakenCount,
              );
              pillSheetDisplayNumber = nextPillSheetGroup.displayPillNumberWithoutDate(pageIndex: 0, pillNumberInPillSheet: pillNumberInPillSheet);
              final nextPillSheetGroupFirstPillSheet = nextPillSheetGroup.pillSheets.first;
              pillSheetGroupIndex = nextPillSheetGroupFirstPillSheet.groupIndex;
              pillSheeType = nextPillSheetGroupFirstPillSheet.pillSheetType;
            case (false, _, _):
              // 次のピルシートを使用する場合
              final nextPillSheet = pillSheetGroup.pillSheets[activePillSheet.groupIndex + 1];
              pillSheetGroupIndex = nextPillSheet.groupIndex;
              pillSheeType = nextPillSheet.pillSheetType;
              pillSheetDisplayNumber = pillSheetGroup.displayPillNumberWithoutDate(
                pageIndex: nextPillSheet.groupIndex,
                pillNumberInPillSheet: pillNumberInPillSheet,
              );

            case (_, _, _):
              // 次のピルシートグループもピルシートも使用しない場合はループをスキップ
              analytics.debug(
                name: 'rrrn_is_over_active_ps_none',
                parameters: {
                  'dayOffset': dayOffset,
                  'isLastPillSheet': isLastPillSheet,
                  'premiumOrTrial': premiumOrTrial,
                  'isAutomaticallyCreatePillSheet': setting.isAutomaticallyCreatePillSheet,
                  'reminderTimeHour': reminderTime.hour,
                  'reminderTimeMinute': reminderTime.minute,
                },
              );
              continue;
          }
        }

        // 偽薬/休薬期間中の通知がOFFの場合はスキップする
        if (!setting.isOnNotifyInNotTakenDuration) {
          if (pillSheeType.dosingPeriod < pillNumberInPillSheet) {
            analytics.debug(
              name: 'rrrn_is_skip_in_dosing',
              parameters: {
                'dayOffset': dayOffset,
                'dosingPeriod': pillSheeType.dosingPeriod,
                'pillNumberInPillSheet': pillNumberInPillSheet,
                'isOnNotifyInNotTakenDuration': setting.isOnNotifyInNotTakenDuration,
                'reminderTimeHour': reminderTime.hour,
                'reminderTimeMinute': reminderTime.minute,
              },
            );
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
              result += ' ';
              result += '${reminderDateTime.month}/${reminderDateTime.day} (${WeekdayFunctions.weekdayFromDate(reminderDateTime).weekdayString()})';
            }

            if (!setting.reminderNotificationCustomization.isInVisiblePillNumber) {
              result += ' ';
              result += pillSheetDisplayNumber;
              result += L.number;
            }

            if (Environment.isDevelopment) {
              result += ' Local';
            }
            // NOTE: 0文字以上じゃないと通知が表示されない。フロントでバリデーションをかけていてもここだけは残す
            if (result.isEmpty) {
              return L.notification;
            }
            return result;
          }();

          final message = () {
            if (setting.reminderNotificationCustomization.isInVisibleDescription) {
              return '';
            }
            // 最後に飲んだ日付が数日前の場合は常にmissedTakenMessage
            if (activePillSheet.todayPillNumber - activePillSheet.lastTakenOrZeroPillNumber > 1) {
              return setting.reminderNotificationCustomization.missedTakenMessage;
            }
            // 本日分の服用記録がない場合で今日のループ(dayOffset==0)の時
            if (dayOffset == 0 && !todayPillAllTaken) {
              return setting.reminderNotificationCustomization.dailyTakenMessage;
            }
            // 本日分の服用記録がある場合で、次の日のループ(dayOffset==1)の時
            if (dayOffset == 1) {
              return setting.reminderNotificationCustomization.dailyTakenMessage;
            }
            // 休薬期間の通知をONにしているユーザーで、跨いだときはdailyTakenMessageを設定。
            // アプリを開いたときでなければRegisterReminderLocalNotificationで通知を登録しないため、この処理がないと複数飲み忘れの通知文言になる
            if (activePillSheet.pillSheetHasRestOrFakeDuration && isOverActivePillSheet && pillNumberInPillSheet == 1) {
              return setting.reminderNotificationCustomization.dailyTakenMessage;
            }
            return setting.reminderNotificationCustomization.missedTakenMessage;
          }();

          futures.add(
            Future(() async {
              try {
                // 常に Local Notification を実行
                await localNotificationService.plugin.zonedSchedule(
                  notificationID,
                  title,
                  message,
                  reminderDateTime,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      androidReminderNotificationChannelID,
                      L.takePillReminderChannelName,
                      channelShowBadge: true,
                      setAsGroupSummary: true,
                      groupKey: androidReminderNotificationGroupKey,
                      category: AndroidNotificationCategory.reminder,
                      // NOTE: [Android:CriticalAlert] AndroidでもCriticalAlertを使用する場合は、Priority.highを使用すれば良さそう
                      importance: Importance.defaultImportance,
                      priority: Priority.defaultPriority,
                      actions: [AndroidNotificationAction(actionIdentifier, L.taken)],
                    ),
                    iOS: DarwinNotificationDetails(
                      categoryIdentifier: iOSQuickRecordPillCategoryIdentifier,
                      sound: setting.useCriticalAlert ? null : 'becho.caf',
                      criticalSoundVolume: setting.useCriticalAlert ? setting.criticalAlertVolume : null,
                      presentBadge: true,
                      presentSound: true,
                      // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
                      // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
                      presentAlert: false,
                      presentBanner: true,
                      presentList: true,
                      badgeNumber: badgeNumber + dayOffset,
                      interruptionLevel: setting.useCriticalAlert ? InterruptionLevel.critical : InterruptionLevel.active,
                    ),
                  ),
                  androidScheduleMode: AndroidScheduleMode.alarmClock,
                );

                analytics.debug(
                  name: 'rrrn_premium',
                  parameters: {
                    'dayOffset': dayOffset,
                    'notificationID': notificationID,
                    'reminderTimeHour': reminderTime.hour,
                    'reminderTimeMinute': reminderTime.minute,
                  },
                );

                // useAlarmKit の場合は AlarmKit も追加で実行
                // AlarmKitでエラーが発生しても無視したいので、スケジュール登録の後に実行する
                if (useAlarmKit) {
                  await AlarmKitService.scheduleMedicationReminder(
                    localNotificationID: notificationID.toString(),
                    title: title,
                    reminderDateTime: reminderDateTime,
                  );

                  analytics.debug(
                    name: 'rrrn_premium_alarmkit',
                    parameters: {
                      'dayOffset': dayOffset,
                      'notificationID': notificationID,
                      'reminderTimeHour': reminderTime.hour,
                      'reminderTimeMinute': reminderTime.minute,
                    },
                  );
                }
              } catch (e, st) {
                // NOTE: エラーが発生しても他の通知のスケジュールを続ける
                errorLogger.recordError(e, st);
                analytics.debug(
                  name: 'rrrn_e_premium',
                  parameters: {
                    'dayOffset': dayOffset,
                    'notificationID': notificationID,
                    'reminderTimeHour': reminderTime.hour,
                    'reminderTimeMinute': reminderTime.minute,
                  },
                );
              }
            }),
          );
        } else {
          final title = L.takePillReminder;
          futures.add(
            Future(() async {
              try {
                // 常に Local Notification を実行
                await localNotificationService.plugin.zonedSchedule(
                  notificationID,
                  title,
                  '',
                  reminderDateTime,
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      androidReminderNotificationChannelID,
                      L.takePillReminderChannelName,
                      channelShowBadge: true,
                      setAsGroupSummary: true,
                      groupKey: androidReminderNotificationGroupKey,
                      category: AndroidNotificationCategory.reminder,
                      // NOTE: [Android:CriticalAlert] AndroidでもCriticalAlertを使用する場合は、Priority.highを使用すれば良さそう
                      importance: Importance.defaultImportance,
                      priority: Priority.defaultPriority,
                    ),
                    iOS: DarwinNotificationDetails(
                      sound: setting.useCriticalAlert ? null : 'becho.caf',
                      criticalSoundVolume: setting.useCriticalAlert ? setting.criticalAlertVolume : null,
                      presentBadge: true,
                      presentSound: true,
                      // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
                      // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
                      presentAlert: false,
                      presentBanner: true,
                      presentList: true,
                      badgeNumber: badgeNumber + dayOffset,
                      interruptionLevel: setting.useCriticalAlert ? InterruptionLevel.critical : InterruptionLevel.active,
                    ),
                  ),
                  androidScheduleMode: AndroidScheduleMode.alarmClock,
                );

                analytics.debug(
                  name: 'rrrn_non_premium',
                  parameters: {
                    'dayOffset': dayOffset,
                    'notificationID': notificationID,
                    'reminderTimeHour': reminderTime.hour,
                    'reminderTimeMinute': reminderTime.minute,
                  },
                );

                // useAlarmKit の場合は AlarmKit も追加で実行
                // AlarmKitでエラーが発生しても無視したいので、スケジュール登録の後に実行する
                if (useAlarmKit) {
                  await AlarmKitService.scheduleMedicationReminder(
                    localNotificationID: notificationID.toString(),
                    title: title,
                    reminderDateTime: reminderDateTime,
                  );

                  analytics.debug(
                    name: 'rrrn_non_premium_alarmkit',
                    parameters: {
                      'dayOffset': dayOffset,
                      'notificationID': notificationID,
                      'reminderTimeHour': reminderTime.hour,
                      'reminderTimeMinute': reminderTime.minute,
                    },
                  );
                }
              } catch (e, st) {
                // NOTE: エラーが発生しても他の通知のスケジュールを続ける
                errorLogger.recordError(e, st);

                analytics.debug(
                  name: 'rrrn_e_non_premium',
                  parameters: {
                    'dayOffset': dayOffset,
                    'notificationID': notificationID,
                    'reminderTimeHour': reminderTime.hour,
                    'reminderTimeMinute': reminderTime.minute,
                  },
                );
              }
            }),
          );
        }
      }
    }

    analytics.debug(name: 'rrrn_e_before_run', parameters: {'notificationCount': futures.length});
    await Future.wait(futures);
    analytics.debug(name: 'rrrn_e_end_run', parameters: {'notificationCount': futures.length});

    try {
      // NOTE: 本来であれば各ユースケース毎に通知を登録するが、99%のケースで同じ通知を登録するのでここで登録してしまう
      final newPillSheetNotification = NewPillSheetNotification();
      await newPillSheetNotification.call(pillSheetGroup: pillSheetGroup, setting: setting);
    } catch (e, st) {
      // 通知の登録に失敗しても、服用記録には影響がないのでエラーログだけ残す
      errorLogger.recordError(e, st);
    }
  }

  // reminder time id is 10{groupIndex:2}{hour:2}{minute:2}{pillNumberInPillSheet:2}
  // for example return value 1002223014 means,  `10` is prefix, gropuIndex: `02` is third pillSheet,`22` is hour, `30` is minute, `14` is pill number into pill sheet
  // 1000000000 = reminderNotificationIdentifierOffset
  //   10000000 = pillSheetGroupIndex
  //     100000 = reminderTime.hour
  //       1000 = reminderTime.minute
  //         10 = pillNumberInPillSheet
  static int _calcLocalNotificationID({required int pillSheetGroupIndex, required ReminderTime reminderTime, required int pillNumberInPillSheet}) {
    final groupIndex = pillSheetGroupIndex * 10000000;
    final hour = reminderTime.hour * 100000;
    final minute = reminderTime.minute * 1000;
    return reminderNotificationIdentifierOffset + groupIndex + hour + minute + pillNumberInPillSheet;
  }
}

final cancelReminderLocalNotificationProvider = Provider((ref) => CancelReminderLocalNotification());

class CancelReminderLocalNotification {
  // Usecase
  // - 服用お休み開始
  // - ピルシートグループを削除された時
  // - 通知をOFFにした時
  // - 退会
  // これら以外はRegisterReminderLocalNotificationで登録し直す。なおRegisterReminderLocalNotification の内部でこの関数を読んでいる
  Future<void> call() async {
    // Local Notification解除
    final pendingNotifications = await localNotificationService.pendingReminderNotifications();
    analytics.debug(
      name: 'cancel_reminder_local_notification',
      parameters: {'length': pendingNotifications.length, 'ids': pendingNotifications.map((e) => e.id).toList().toString()},
    );
    await Future.wait(pendingNotifications.map((p) => localNotificationService.cancelNotification(localNotificationID: p.id)));

    // AlarmKit解除
    if (await AlarmKitService.isAvailable()) {
      try {
        await AlarmKitService.cancelAllMedicationReminders();

        analytics.debug(name: 'cancel_alarm_kit_reminders_completed');
      } catch (e, st) {
        // AlarmKit解除でエラーが発生してもアプリの動作に影響しないようにログのみ記録
        analytics.debug(name: 'cancel_alarm_kit_reminders_error', parameters: {'error': e.toString()});
        errorLogger.recordError(e, st);
      }
    }
  }
}

// Schedule
extension ScheduleLocalNotificationService on LocalNotificationService {
  Future<void> scheduleCalendarScheduleNotification({required Schedule schedule}) async {
    final localNotification = schedule.localNotification;
    if (localNotification != null) {
      final remindDate = tz.TZDateTime.from(localNotification.remindDateTime, tz.local);
      await plugin.zonedSchedule(
        localNotification.localNotificationID,
        L.todaySchedule,
        schedule.title,
        remindDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidCalendarScheduleNotificationChannelID,
            L.calendarSchedule,
            groupKey: null,
            category: AndroidNotificationCategory.reminder,
          ),
          iOS: const DarwinNotificationDetails(sound: 'becho.caf', interruptionLevel: InterruptionLevel.active),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );
    }
  }
}

final newPillSheetNotificationProvider = Provider((ref) => NewPillSheetNotification());

// 新しいピルシートの通知をスケジュールする
// PillSheetGroup.pillSheets毎にスケジュールする方法が直感的だが、ローカル通知のスケジュールができる数に上限もあるので枠を節約する意味でも一つ先のピルシートの通知をスケジュールする
// 2[0-9]日毎に1会通知をスケジュールするのでも十分
class NewPillSheetNotification {
  Future<void> call({required PillSheetGroup pillSheetGroup, required Setting setting}) async {
    final pendingNotifications = await localNotificationService.pendingNewPillSheetNotifications();
    await Future.wait(pendingNotifications.map((p) => localNotificationService.cancelNotification(localNotificationID: p.id)));

    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      return;
    }
    final reminderTime = setting.earlyReminderTime;
    if (reminderTime == null) {
      return;
    }

    Future<void> register(TZDateTime reminderDateTime) async {
      debugPrint('NewPillSheetNotification register time: $reminderDateTime');
      try {
        await localNotificationService.plugin.zonedSchedule(
          newPillSheetNotificationIdentifier,
          L.newPillSheetNotificationTitle,
          L.newPillSheetNotificationMessage,
          reminderDateTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidReminderNotificationChannelID,
              L.takePillReminderChannelName,
              channelShowBadge: true,
              setAsGroupSummary: true,
              groupKey: androidReminderNotificationGroupKey,
              category: AndroidNotificationCategory.reminder,
              // NOTE: [Android:CriticalAlert] AndroidでもCriticalAlertを使用する場合は、Priority.highを使用すれば良さそう
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
            ),
            iOS: DarwinNotificationDetails(
              sound: setting.useCriticalAlert ? null : 'becho.caf',
              criticalSoundVolume: setting.useCriticalAlert ? setting.criticalAlertVolume : null,
              presentBadge: true,
              presentSound: true,
              // Alertはdeprecatedなので、banner,listをtrueにしておけばよい。
              // https://developer.apple.com/documentation/usernotifications/unnotificationpresentationoptions/unnotificationpresentationoptionalert
              presentAlert: false,
              presentBanner: true,
              presentList: true,
              interruptionLevel: setting.useCriticalAlert ? InterruptionLevel.critical : InterruptionLevel.active,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
      } catch (e, st) {
        // NOTE: エラーが発生しても他の通知のスケジュールを続ける
        errorLogger.recordError(e, st);

        analytics.debug(
          name: 'npn_error',
          parameters: {'registerDateTime': reminderDateTime, 'reminderTimeHour': reminderTime.hour, 'reminderTimeMinute': reminderTime.minute},
        );
      }
    }

    for (final pillSheet in pillSheetGroup.pillSheets) {
      // 次のピルシートが存在する場合
      if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        final nextBeginDate = tz.TZDateTime.from(pillSheet.beginDate, tz.local);
        final reminderDateTime = nextBeginDate.date().add(Duration(hours: reminderTime.hour)).add(Duration(minutes: reminderTime.minute));
        await register(reminderDateTime);
        break;
      }

      // ピルシートグループが終了する場合
      if (pillSheet.groupIndex == pillSheetGroup.pillSheets.last.groupIndex) {
        final nextBeginDate = tz.TZDateTime.from(pillSheet.estimatedEndTakenDate.addDays(1), tz.local);
        final reminderDateTime = nextBeginDate.date().add(Duration(hours: reminderTime.hour)).add(Duration(minutes: reminderTime.minute));
        await register(reminderDateTime);
        break;
      }
    }
  }
}

var localNotificationService = LocalNotificationService();
