import 'dart:math';

import 'package:collection/collection.dart';
import 'package:async_value_group/async_value_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/keyboard_toolbar.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:pilll/utils/local_notification.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/datetime/day.dart';

class SchedulePostPage extends HookConsumerWidget {
  final DateTime date;

  const SchedulePostPage({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueGroup.group2(ref.watch(userProvider), ref.watch(schedulesForDateProvider(date))).when(
      data: (data) => _SchedulePostPage(
        date: date,
        premiumAndTrial: data.t1,
        schedule: data.t2.firstOrNull ?? Schedule(title: "", localNotification: null, date: date, createdDateTime: DateTime.now()),
      ),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(refreshAppProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class _SchedulePostPage extends HookConsumerWidget {
  final DateTime date;
  final Schedule schedule;
  final User premiumAndTrial;

  const _SchedulePostPage({
    Key? key,
    required this.date,
    required this.schedule,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleID = schedule.id;
    final title = useState(schedule.title);
    final isOnRemind = useState(schedule.localNotification != null);
    final textEditingController = useTextEditingController(text: title.value);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    bool isInvalid() => !(date.date().isAfter(today())) || title.value.isEmpty;

    return Scaffold(
      backgroundColor: PilllColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(DateTimeFormatter.yearAndMonthAndDay(date),
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: TextColor.main,
            )),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 40,
                        maxHeight: 200,
                      ),
                      child: TextFormField(
                        onChanged: (text) {
                          title.value = text;
                        },
                        decoration: const InputDecoration(
                          hintText: "通院する",
                          border: OutlineInputBorder(),
                        ),
                        controller: textEditingController,
                        maxLines: null,
                        maxLength: 60,
                        keyboardType: TextInputType.multiline,
                        focusNode: focusNode,
                      ),
                    ),
                    SwitchListTile(
                      title: const Text("当日9:00に通知を受け取る",
                          style: TextStyle(
                            fontFamily: FontFamily.roboto,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          )),
                      activeColor: PilllColors.secondary,
                      onChanged: (bool value) {
                        analytics.logEvent(
                          name: "schedule_post_remind_toggle",
                        );
                        isOnRemind.value = value;
                      },
                      value: isOnRemind.value,
                      // NOTE: when configured subtitle, the space between elements becomes very narrow
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    if (date.date().isAfter(today())) ...[
                      PrimaryButton(
                        text: "保存",
                        onPressed: isInvalid()
                            ? null
                            : () async {
                                analytics.logEvent(name: "schedule_post_pressed");
                                final navigator = Navigator.of(context);

                                try {
                                  final localNotificationID = schedule.localNotification?.localNotificationID;
                                  if (localNotificationID != null) {
                                    await localNotificationService.cancelNotification(localNotificationID: localNotificationID);
                                  }

                                  final Schedule newSchedule;
                                  if (isOnRemind.value) {
                                    newSchedule = schedule.copyWith(
                                      title: title.value,
                                      localNotification: LocalNotification(
                                        localNotificationID: Random().nextInt(scheduleNotificationIdentifierOffset),
                                        remindDateTime: DateTime(date.year, date.month, date.day, 9),
                                      ),
                                    );
                                    await localNotificationService.scheduleCalendarScheduleNotification(schedule: newSchedule);
                                  } else {
                                    newSchedule = schedule.copyWith(
                                      title: title.value,
                                      localNotification: null,
                                    );
                                  }

                                  await ref.read(databaseProvider).schedulesReference().doc(newSchedule.id).set(
                                        newSchedule,
                                        SetOptions(merge: true),
                                      );
                                  navigator.pop();
                                } catch (error) {
                                  if (context.mounted) showErrorAlert(context, error);
                                }
                              },
                      ),
                      const SizedBox(height: 10),
                      if (scheduleID != null)
                        AppOutlinedButton(
                          text: "削除",
                          onPressed: () async {
                            analytics.logEvent(name: "schedule_delete_pressed");
                            showDiscardDialog(
                              context,
                              title: "予定を削除します",
                              message: "削除された予定は復元ができません",
                              actions: [
                                AlertButton(
                                  text: "キャンセル",
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                AlertButton(
                                  text: "削除する",
                                  onPressed: () async {
                                    final navigator = Navigator.of(context);
                                    try {
                                      final localNotificationID = schedule.localNotification?.localNotificationID;
                                      if (localNotificationID != null) {
                                        await localNotificationService.cancelNotification(localNotificationID: localNotificationID);
                                      }

                                      await ref.read(databaseProvider).schedulesReference().doc(scheduleID).delete();
                                      navigator.popUntil((route) => route.isFirst);
                                    } catch (error) {
                                      if (context.mounted) showErrorAlert(context, error);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            if (focusNode.hasPrimaryFocus) ...[
              KeyboardToolbar(
                doneButton: AlertButton(
                  text: '完了',
                  onPressed: () async {
                    analytics.logEvent(name: "schedule_post_toolbar_done");
                    focusNode.unfocus();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension SchedulePostPageRoute on SchedulePostPage {
  static Route<dynamic> route(DateTime date) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SchedulePostPage"),
      builder: (_) => SchedulePostPage(date: date),
      fullscreenDialog: true,
    );
  }
}
