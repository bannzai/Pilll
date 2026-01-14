import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/native/widget.dart';
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
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

// ここを編集する時は historical_pill_sheet_group/component/pill_sheet.dart も編集する
class RecordPagePillSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final User user;

  List<PillSheetType> get pillSheetTypes => pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const RecordPagePillSheet({
    super.key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.setting,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekdayDate = pillSheet.beginDate.addDays(summarizedRestDuration(restDurations: pillSheet.restDurations, upperDate: today()));
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
      final activePillSheet = pillSheetGroup.activePillSheet;
      // activePillSheetでないピルシートは全てdisabled
      final isNotActive = activePillSheet == null || activePillSheet.groupIndex != pillSheet.groupIndex;
      final isDisabled = switch (pillSheet) {
        PillSheetV1() => isNotActive,
        PillSheetV2 v2 => isNotActive || v2.isPillDisabled(pillNumberInPillSheet: pillNumberInPillSheet),
      };
      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          pillNumber: PillNumber(
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            setting: setting,
            pillNumberInPillSheet: pillNumberInPillSheet,
            user: user,
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
            remainingPillTakenCount: _remainingPillTakenCount(
              pillNumberInPillSheet: pillNumberInPillSheet,
              pillSheet: pillSheet,
            ),
            isDisabled: isDisabled,
          ),
          isDisabled: isDisabled,
          onTap: () async {
            try {
              analytics.logEvent(name: 'pill_mark_tapped', parameters: {
                'last_taken_pill_number': pillSheet.lastTakenOrZeroPillNumber,
                'today_pill_number': pillSheet.todayPillNumber,
                'pillNumberInPillSheet': pillNumberInPillSheet,
              });

              if (pillSheet.todayPillNumber < pillNumberInPillSheet) {
                return;
              }

              // v2の場合は全錠服用済みかどうかで判定
              final isFullyTaken = switch (pillSheet) {
                PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber >= pillNumberInPillSheet,
                PillSheetV2 v2 => () {
                    final pillIndex = pillNumberInPillSheet - 1;
                    if (pillIndex < 0 || pillIndex >= v2.pills.length) return false;
                    final pill = v2.pills[pillIndex];
                    return pill.pillTakens.length >= pill.takenCount;
                  }(),
              };

              if (isFullyTaken) {
                await revertTakePill(
                  pillSheetGroup: pillSheetGroup,
                  pageIndex: pageIndex,
                  targetRevertPillNumberIntoPillSheet: pillNumberInPillSheet,
                );

                syncActivePillSheetValue(pillSheetGroup: pillSheetGroup);
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
    // v2の場合はlastCompletedPillNumberで判定
    final lastCompleted = switch (pillSheet) {
      PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
      PillSheetV2() => pillSheet.lastCompletedPillNumber,
    };
    if (pillNumberInPillSheet <= lastCompleted) {
      return null;
    }
    if (pillSheetGroup.lastActiveRestDuration != null) {
      return null;
    }
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
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
    // v2の場合はtodayPillAllTakenで判定
    final isAlreadyTaken = switch (activePillSheet) {
      PillSheetV1() => activePillSheet.todayPillIsAlreadyTaken,
      PillSheetV2() => activePillSheet.todayPillAllTaken,
    };
    if (isAlreadyTaken) {
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
      throw const FormatException('pill sheet not found');
    }
    if (activePillSheet.groupIndex < pillSheet.groupIndex) {
      return false;
    }
    if (activePillSheet.id != pillSheet.id) {
      if (pillSheet.isBegan) {
        // v2の場合はlastCompletedPillNumberで判定
        final lastCompleted = switch (pillSheet) {
          PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
          PillSheetV2 v2 => v2.lastCompletedPillNumber,
        };
        if (pillNumberInPillSheet > lastCompleted) {
          return false;
        }
      }
      return true;
    }

    return switch (activePillSheet) {
      PillSheetV1() => pillNumberInPillSheet <= activePillSheet.lastTakenOrZeroPillNumber,
      PillSheetV2 v2 => pillNumberInPillSheet <= v2.lastCompletedPillNumber,
    };
  }

  /// 残り服用数を計算する（2錠飲み対応）
  /// v1の場合はnull（数字表示なし）
  /// v2の場合は残り服用数を返す（全錠服用済みならnull）
  int? _remainingPillTakenCount({
    required int pillNumberInPillSheet,
    required PillSheet pillSheet,
  }) {
    return switch (pillSheet) {
      PillSheetV1() => null,
      PillSheetV2 v2 => () {
          final pillIndex = pillNumberInPillSheet - 1;
          if (pillIndex < 0 || pillIndex >= v2.pills.length) {
            return null;
          }
          final pill = v2.pills[pillIndex];
          final takenCount = pill.pillTakens.length;
          final remaining = pill.takenCount - takenCount;
          return remaining > 0 ? remaining : null;
        }(),
    };
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
  // v2の場合はlastCompletedPillNumberで判定
  final lastCompleted = switch (pillSheet) {
    PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
    PillSheetV2 v2 => v2.lastCompletedPillNumber,
  };
  if (pillNumberInPillSheet <= lastCompleted) {
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
  if (pillSheetGroup.lastActiveRestDuration != null) {
    return false;
  }
  final activePillSheet = pillSheetGroup.activePillSheet;
  if (activePillSheet == null) {
    throw const FormatException('pill sheet not found');
  }
  if (activePillSheet.groupIndex < pillSheet.groupIndex) {
    return false;
  }
  if (activePillSheet.id != pillSheet.id) {
    if (pillSheet.isBegan) {
      // v2の場合はlastCompletedPillNumberで判定
      final lastCompleted = switch (pillSheet) {
        PillSheetV1() => pillSheet.lastTakenOrZeroPillNumber,
        PillSheetV2 v2 => v2.lastCompletedPillNumber,
      };
      if (pillNumberInPillSheet > lastCompleted) {
        return true;
      }
    }
    return false;
  }

  // v2の場合はlastCompletedPillNumberで判定
  final lastCompleted = switch (activePillSheet) {
    PillSheetV1() => activePillSheet.lastTakenOrZeroPillNumber,
    PillSheetV2 v2 => v2.lastCompletedPillNumber,
  };
  return pillNumberInPillSheet > lastCompleted && pillNumberInPillSheet <= activePillSheet.todayPillNumber;
}

class PillNumber extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final User user;
  final int pageIndex;
  final int pillNumberInPillSheet;

  const PillNumber(
      {super.key,
      required this.pillSheetGroup,
      required this.pillSheet,
      required this.setting,
      required this.user,
      required this.pageIndex,
      required this.pillNumberInPillSheet});

  @override
  Widget build(BuildContext context) {
    final menstruationDateRanges = pillSheetGroup.menstruationDateRanges(setting: setting);

    final containedMenstruationDuration =
        menstruationDateRanges.where((e) => e.inRange(pillSheet.displayPillTakeDate(pillNumberInPillSheet))).isNotEmpty;

    final text = pillSheetGroup.displayPillNumberOrDate(
      premiumOrTrial: user.premiumOrTrial,
      pageIndex: pageIndex,
      pillNumberInPillSheet: pillNumberInPillSheet,
    );

    if (user.premiumOrTrial && containedMenstruationDuration) {
      return MenstruationPillNumber(text: text);
    } else {
      return PlainPillNumber(text: text);
    }
  }
}
