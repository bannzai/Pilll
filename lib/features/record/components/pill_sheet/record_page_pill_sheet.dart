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
          textOfPillNumber: textOfPillNumber(
            premiumAndTrial: premiumAndTrial,
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            setting: setting,
            pillNumberInPillSheet: pillNumberInPillSheet,
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
                await revertTakePill(pillSheetGroup: pillSheetGroup, pageIndex: pageIndex, pillNumberInPillSheet: pillNumberInPillSheet);
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
              showErrorAlert(context, exception);
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
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      return null;
    }
    if (activedPillSheet.activeRestDuration != null) {
      return null;
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return null;
    }
    var diff = min(pillSheet.todayPillNumber, pillSheet.typeInfo.totalCount) - pillNumberInPillSheet;
    if (diff < 0) {
      // User tapped future pill number
      return null;
    }
    if (activedPillSheet.todayPillIsAlreadyTaken) {
      return null;
    }

    final takenDate = pillSheet.displayPillTakeDate(pillNumberInPillSheet);

    final updatedPillSheetGroup = await takePill(
      takenDate: takenDate,
      pillSheetGroup: pillSheetGroup,
      activedPillSheet: activedPillSheet,
      isQuickRecord: false,
    );
    await registerReminderLocalNotification();
    if (updatedPillSheetGroup == null) {
      return null;
    }
    return updatedPillSheetGroup;
  }

  static Widget textOfPillNumber({
    required int pillNumberInPillSheet,
    required int pageIndex,
    required PillSheetGroup pillSheetGroup,
    required PillSheet pillSheet,
    required PremiumAndTrial premiumAndTrial,
    required Setting setting,
  }) {
    final containedMenstruationDuration = RecordPagePillSheet.isContainedMenstruationDuration(
      pillNumberInPillSheet: pillNumberInPillSheet,
      pillSheetGroup: pillSheetGroup,
      setting: setting,
      pageIndex: pageIndex,
    );
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

  /*
    pillNumberInPillSheet の値によって二つの動きをする
    setting.pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount の場合は単純にこの式の結果を用いる
    setting.pillNumberForFromMenstruation > pillSheet.typeInfo.totalCount の場合はページ数も考慮して
      pillSheet.begin < pillNumberForFromMenstruation < pillSheet.typeInfo.totalCount の場合の結果を用いる

    - 想定される使い方は各ピルシートごとに同じ生理の期間開始を設定したい(1つ目の仕様)
    - ヤーズフレックスのようにどこか1枚だけ生理の開始期間を設定したい(2つ目の仕様)

    なので後者の計算式で下のようになっても許容をすることにする

    28錠タイプが4枚ある場合で46番ごとに生理期間がくる設定をしていると生理期間の始まりが
      1枚目: なし
      2枚目: 18番から
      3枚目: なし
      4枚目: 8番から
  */
  static bool isContainedMenstruationDuration({
    required int pillNumberInPillSheet,
    required PillSheetGroup pillSheetGroup,
    required int pageIndex,
    required Setting setting,
  }) {
    if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
      return false;
    }

    final pillSheetTotalCount = pillSheetGroup.pillSheets[pageIndex].typeInfo.totalCount;
    if (setting.pillNumberForFromMenstruation < pillSheetTotalCount) {
      final left = setting.pillNumberForFromMenstruation;
      final right = setting.pillNumberForFromMenstruation + setting.durationMenstruation - 1;
      return left <= pillNumberInPillSheet && pillNumberInPillSheet <= right;
    }
    final passedCount = summarizedPillCountWithPillSheetTypesToIndex(
        pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(), toIndex: pageIndex);
    final pillNumberInPillSheetGroup = passedCount + pillNumberInPillSheet;

    final menstruationRangeList = List.generate(pillSheetGroup.pillSheets.length, (index) {
      final begin = setting.pillNumberForFromMenstruation * (index + 1);
      final end = begin + setting.durationMenstruation - 1;

      return (begin, end);
    });

    final isContainedMenstruationDuration =
        menstruationRangeList.where((element) => element.$1 <= pillNumberInPillSheetGroup && pillNumberInPillSheetGroup <= element.$2).isNotEmpty;
    return isContainedMenstruationDuration;
  }

  bool _isDone({
    required int pillNumberInPillSheet,
  }) {
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("pill sheet not found");
    }
    if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activedPillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        if (pillNumberInPillSheet > pillSheet.lastTakenPillNumber) {
          return false;
        }
      }
      return true;
    }

    return pillNumberInPillSheet <= activedPillSheet.lastTakenPillNumber;
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
  if (pillSheetGroup.activedPillSheet?.activeRestDuration != null) {
    return false;
  }
  final activedPillSheet = pillSheetGroup.activedPillSheet;
  if (activedPillSheet == null) {
    throw const FormatException("pill sheet not found");
  }
  if (activedPillSheet.groupIndex < pillSheet.groupIndex) {
    return false;
  }
  if (activedPillSheet.id != pillSheet.id) {
    if (pillSheet.isBegan) {
      if (pillNumberInPillSheet > pillSheet.lastTakenPillNumber) {
        return true;
      }
    }
    return false;
  }

  return pillNumberInPillSheet > activedPillSheet.lastTakenPillNumber && pillNumberInPillSheet <= activedPillSheet.todayPillNumber;
}
