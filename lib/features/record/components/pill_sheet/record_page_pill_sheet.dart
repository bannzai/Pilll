import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_weekday_line.dart';
import 'package:pilll/features/release_note/release_note.dart';
import 'package:pilll/features/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/features/record/util/request_in_app_review.dart';
import 'package:pilll/provider/revert_take_pill.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

// ここを編集する時は historical_pill_sheet_group/component/pill_sheet.dart も編集する
class RecordPagePillSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;

  List<PillSheetType> get pillSheetTypes => pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const RecordPagePillSheet({
    Key? key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.setting,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekdayDate =
        pillSheet.beginingDate.add(Duration(days: summarizedRestDuration(restDurations: pillSheet.restDurations, upperDate: today())));
    final takePill = ref.watch(takePillProvider);
    final revertTakePill = ref.watch(revertTakePillProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return PillSheetViewLayout(
      weekdayLines: PillSheetViewWeekdayLine(
        firstWeekday: WeekdayFunctions.weekdayFromDate(weekdayDate),
      ),
      pillMarkLines: List.generate(
        pillSheet.pillSheetType.numberOfLineInPillSheet,
        (index) {
          return PillMarkLine(
            pillMarks: _pillMarks(
              context,
              takePill: takePill,
              revertTakePill: revertTakePill,
              registerReminderLocalNotification: registerReminderLocalNotification,
              lineIndex: index,
              pageIndex: pillSheet.groupIndex,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _pillMarks(
    BuildContext context, {
    required TakePill takePill,
    required RevertTakePill revertTakePill,
    required RegisterReminderLocalNotification registerReminderLocalNotification,
    required int lineIndex,
    required int pageIndex,
  }) {
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length > pillSheet.pillSheetType.totalCount) {
      int diff = pillSheet.pillSheetType.totalCount - lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }

    return List.generate(Weekday.values.length, (columnIndex) {
      if (columnIndex >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }

      final pillNumberInPillSheet = PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(columnIndex, lineIndex);
      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          pillNumber: PillNumber(
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            setting: setting,
            pillNumberInPillSheet: pillNumberInPillSheet,
            premiumAndTrial: premiumAndTrial,
            pageIndex: pageIndex,
          ),
          pillMark: PillMark(
            showsRippleAnimation: shouldPillMarkAnimation(
              pillNumberInPillSheet: pillNumberInPillSheet,
              pillSheet: pillSheet,
              pillSheetGroup: pillSheetGroup,
            ),
            showsCheckmark: _isDone(
              pillNumberInPillSheet: pillNumberInPillSheet,
            ),
            pillMarkType: pillMarkFor(
              pillNumberInPillSheet: pillNumberInPillSheet,
              pillSheet: pillSheet,
            ),
          ),
          onTap: () async {
            try {
              analytics.logEvent(name: "pill_mark_tapped", parameters: {
                "last_taken_pill_number": pillSheet.lastTakenPillNumber,
                "today_pill_number": pillSheet.todayPillNumber,
              });

              if (pillSheet.todayPillNumber < pillNumberInPillSheet) {
                return;
              }

              if (pillSheet.lastTakenPillNumber >= pillNumberInPillSheet) {
                await revertTakePill(
                    pillSheetGroup: pillSheetGroup, pageIndex: pageIndex, targetRevertPillNumberIntoPillSheet: pillNumberInPillSheet);
                await registerReminderLocalNotification();
              } else {
                // NOTE: batch.commit でリモートのDBに書き込む時間がかかるので事前にバッジを0にする
                FlutterAppBadger.removeBadge();
                requestInAppReview();
                showReleaseNotePreDialog(context);

                await _takeWithPillNumber(
                  takePill,
                  registerReminderLocalNotification,
                  pillSheetGroup: pillSheetGroup,
                  pillNumberInPillSheet: pillNumberInPillSheet,
                  pillSheet: pillSheet,
                );
              }
            } catch (exception, stack) {
              errorLogger.recordError(exception, stack);
              if (context.mounted) showErrorAlert(context, exception);
            }
          },
        ),
      );
    });
  }

  Future<PillSheetGroup?> _takeWithPillNumber(
    TakePill takePill,
    RegisterReminderLocalNotification registerReminderLocalNotification, {
    required int pillNumberInPillSheet,
    required PillSheetGroup pillSheetGroup,
    required PillSheet pillSheet,
  }) async {
    if (pillNumberInPillSheet <= pillSheet.lastTakenPillNumber) {
      return null;
    }
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      return null;
    }
    if (activePillSheet.activeRestDuration != null) {
      return null;
    }
    if (activePillSheet.groupIndex < pillSheet.groupIndex) {
      return null;
    }
    var diff = min(pillSheet.todayPillNumber, pillSheet.typeInfo.totalCount) - pillNumberInPillSheet;
    if (diff < 0) {
      // User tapped future pill number
      return null;
    }
    if (activePillSheet.todayPillIsAlreadyTaken) {
      return null;
    }

    final takenDate = pillSheet.displayPillTakeDate(pillNumberInPillSheet);
    final updatedPillSheetGroup = await takePill(
      takenDate: takenDate,
      pillSheetGroup: pillSheetGroup,
      activePillSheet: activePillSheet,
      isQuickRecord: false,
    );
    await registerReminderLocalNotification();
    if (updatedPillSheetGroup == null) {
      return null;
    }
    return updatedPillSheetGroup;
  }

  bool _isDone({
    required int pillNumberInPillSheet,
  }) {
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw const FormatException("pill sheet not found");
    }
    if (activePillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activePillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        if (pillNumberInPillSheet > pillSheet.lastTakenPillNumber) {
          return false;
        }
      }
      return true;
    }

    return pillNumberInPillSheet <= activePillSheet.lastTakenPillNumber;
  }
}

PillMarkType pillMarkFor({
  required int pillNumberInPillSheet,
  required PillSheet pillSheet,
}) {
  if (pillNumberInPillSheet > pillSheet.typeInfo.dosingPeriod) {
    return (pillSheet.pillSheetType == PillSheetType.pillsheet_21 || pillSheet.pillSheetType == PillSheetType.pillsheet_24_rest_4)
        ? PillMarkType.rest
        : PillMarkType.fake;
  }
  if (pillNumberInPillSheet <= pillSheet.lastTakenPillNumber) {
    return PillMarkType.done;
  }
  if (pillNumberInPillSheet < pillSheet.todayPillNumber) {
    return PillMarkType.normal;
  }
  return PillMarkType.normal;
}

bool shouldPillMarkAnimation({
  required int pillNumberInPillSheet,
  required PillSheet pillSheet,
  required PillSheetGroup pillSheetGroup,
}) {
  if (pillSheetGroup.activePillSheet?.activeRestDuration != null) {
    return false;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    throw const FormatException("pill sheet not found");
  }
  if (activePillSheet.groupIndex < pillSheet.groupIndex) {
    return false;
  }
  if (activePillSheet.id != pillSheet.id) {
    if (pillSheet.isBegan) {
      if (pillNumberInPillSheet > pillSheet.lastTakenPillNumber) {
        return true;
      }
    }
    return false;
  }

  return pillNumberInPillSheet > activePillSheet.lastTakenPillNumber && pillNumberInPillSheet <= activePillSheet.todayPillNumber;
}

class PillNumber extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;
  final int pageIndex;
  final int pillNumberInPillSheet;

  const PillNumber(
      {super.key,
      required this.pillSheetGroup,
      required this.pillSheet,
      required this.setting,
      required this.premiumAndTrial,
      required this.pageIndex,
      required this.pillNumberInPillSheet});

  @override
  Widget build(BuildContext context) {
    final menstruationDateRanges = pillSheetGroup.menstruationDateRanges(setting: setting);

    final containedMenstruationDuration =
        menstruationDateRanges.where((e) => e.inRange(pillSheet.displayPillTakeDate(pillNumberInPillSheet))).isNotEmpty;

    final text = pillSheetGroup.displayPillNumber(
      premiumOrTrial: premiumAndTrial.premiumOrTrial,
      pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
      pageIndex: pageIndex,
      pillNumberInPillSheet: pillNumberInPillSheet,
    );

    if (premiumAndTrial.premiumOrTrial && containedMenstruationDuration) {
      return MenstruationPillNumber(text: text);
    } else {
      return PlainPillNumber(text: text);
    }
  }
}
