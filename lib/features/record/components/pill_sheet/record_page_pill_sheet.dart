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

      final pillNumberIntoPillSheet = PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(columnIndex, lineIndex);
      final remainingPillTakenCount = () {
        if (pillSheet.todayPillsAreAlreadyTaken) {
          return null;
        }

        final pillIndexIntoPillSheet = pillNumberIntoPillSheet - 1;
        if (pillSheet.todayPillIndex < pillIndexIntoPillSheet) {
          return null;
        }
        if (pillSheet.pillTakenCount > 1) {
          return pillSheet.pillTakenCount - pillSheet.pills[pillIndexIntoPillSheet].pillTakens.length;
        } else {
          return null;
        }
      }();
      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          textOfPillNumber: textOfPillNumber(
            premiumAndTrial: premiumAndTrial,
            pillSheetGroup: pillSheetGroup,
            pillSheet: pillSheet,
            setting: setting,
            pillNumberIntoPillSheet: pillNumberIntoPillSheet,
            pageIndex: pageIndex,
          ),
          pillMark: PillMark(
            showsRippleAnimation: shouldPillMarkAnimation(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
              pillSheetGroup: pillSheetGroup,
            ),
            showsCheckmark: _isDone(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
            ),
            pillMarkType: pillMarkFor(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
            ),
            remainingPillTakenCount: remainingPillTakenCount,
          ),
          onTap: () async {
            try {
              analytics.logEvent(name: "pill_mark_tapped", parameters: {
                "last_taken_pill_number": pillSheet.lastCompletedPillNumber,
                "today_pill_number": pillSheet.todayPillNumber,
              });

              if (pillSheet.todayPillNumber < pillNumberIntoPillSheet) {
                return;
              }

              if (pillSheet.lastCompletedPillNumber >= pillNumberIntoPillSheet) {
                await revertTakePill(pillSheetGroup: pillSheetGroup, pageIndex: pageIndex, pillNumberIntoPillSheet: pillNumberIntoPillSheet);
              } else {
                // NOTE: batch.commit でリモートのDBに書き込む時間がかかるので事前にバッジを0にする
                FlutterAppBadger.removeBadge();
                requestInAppReview();
                showReleaseNotePreDialog(context);

                await _takeWithPillNumber(
                  takePill,
                  pillSheetGroup: pillSheetGroup,
                  pillNumberIntoPillSheet: pillNumberIntoPillSheet,
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
    TakePill takePill, {
    required int pillNumberIntoPillSheet,
    required PillSheetGroup pillSheetGroup,
    required PillSheet pillSheet,
  }) async {
    if (pillNumberIntoPillSheet <= pillSheet.lastCompletedPillNumber) {
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
    var diff = min(pillSheet.todayPillNumber, pillSheet.typeInfo.totalCount) - pillNumberIntoPillSheet;
    if (diff < 0) {
      // User tapped future pill number
      return null;
    }
    if (activedPillSheet.todayPillsAreAlreadyTaken) {
      return null;
    }

    final takenDate = pillSheet.pillTakenDateFromPillNumber(pillNumberIntoPillSheet);

    final updatedPillSheetGroup = await takePill(
      takenDate: takenDate,
      pillSheetGroup: pillSheetGroup,
      activedPillSheet: activedPillSheet,
      isQuickRecord: false,
    );
    if (updatedPillSheetGroup == null) {
      return null;
    }
    return updatedPillSheetGroup;
  }

  static Widget textOfPillNumber({
    required int pillNumberIntoPillSheet,
    required int pageIndex,
    required PillSheetGroup pillSheetGroup,
    required PillSheet pillSheet,
    required PremiumAndTrial premiumAndTrial,
    required Setting setting,
  }) {
    final isPremiumOrTrial = premiumAndTrial.isPremium || premiumAndTrial.isTrial;
    final containedMenstruationDuration = RecordPagePillSheet.isContainedMenstruationDuration(
      pillNumberIntoPillSheet: pillNumberIntoPillSheet,
      pillSheetGroup: pillSheetGroup,
      setting: setting,
      pageIndex: pageIndex,
    );
    if (isPremiumOrTrial && setting.pillSheetAppearanceMode == PillSheetAppearanceMode.date) {
      final DateTime date = pillSheet.pillTakenDateFromPillNumber(pillNumberIntoPillSheet);

      if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
        return PlainPillDate(date: date);
      }

      if (containedMenstruationDuration) {
        return MenstruationPillDate(date: date);
      } else {
        return PlainPillDate(date: date);
      }
    } else if (setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) {
      final pageOffset = summarizedPillCountWithPillSheetTypesToEndIndex(
        pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
        endIndex: pageIndex,
      );
      if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
        return SequentialPillNumber(
          pageOffset: pageOffset,
          displayNumberSetting: pillSheetGroup.displayNumberSetting,
          pillNumberIntoPillSheet: pillNumberIntoPillSheet,
        );
      }

      if (isPremiumOrTrial) {
        if (containedMenstruationDuration) {
          return MenstruationSequentialPillNumber(
            pageOffset: pageOffset,
            displayNumberSetting: pillSheetGroup.displayNumberSetting,
            pillNumberIntoPillSheet: pillNumberIntoPillSheet,
          );
        }
      }
      return SequentialPillNumber(
          pageOffset: pageOffset, displayNumberSetting: pillSheetGroup.displayNumberSetting, pillNumberIntoPillSheet: pillNumberIntoPillSheet);
    } else {
      if (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0) {
        return PlainPillNumber(pillNumberIntoPillSheet: pillNumberIntoPillSheet);
      }

      if (isPremiumOrTrial) {
        if (containedMenstruationDuration) {
          return MenstruationPillNumber(pillNumberIntoPillSheet: pillNumberIntoPillSheet);
        }
      }
      return PlainPillNumber(pillNumberIntoPillSheet: pillNumberIntoPillSheet);
    }
  }

  /*
    pillNumberIntoPillSheet の値によって二つの動きをする
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
    required int pillNumberIntoPillSheet,
    required PillSheetGroup pillSheetGroup,
    required int pageIndex,
    required Setting setting,
  }) {
    final pillSheetTotalCount = pillSheetGroup.pillSheets[pageIndex].typeInfo.totalCount;
    if (setting.pillNumberForFromMenstruation < pillSheetTotalCount) {
      final left = setting.pillNumberForFromMenstruation;
      final right = setting.pillNumberForFromMenstruation + setting.durationMenstruation - 1;
      return left <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= right;
    }
    final passedCount = summarizedPillCountWithPillSheetTypesToEndIndex(
        pillSheetTypes: pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(), endIndex: pageIndex);
    final serialiedPillNumber = passedCount + pillNumberIntoPillSheet;

    final menstruationRangeList = List.generate(pillSheetGroup.pillSheets.length, (index) {
      final begin = setting.pillNumberForFromMenstruation * (index + 1);
      final end = begin + setting.durationMenstruation - 1;
      return _MenstruationRange(begin, end);
    });

    final isContainedMenstruationDuration = menstruationRangeList.where((element) => element.contains(serialiedPillNumber)).isNotEmpty;
    return isContainedMenstruationDuration;
  }

  bool _isDone({
    required int pillNumberIntoPillSheet,
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
        if (pillNumberIntoPillSheet > pillSheet.lastCompletedPillNumber) {
          return false;
        }
      }
      return true;
    }

    return pillNumberIntoPillSheet <= activedPillSheet.lastCompletedPillNumber;
  }
}

PillMarkType pillMarkFor({
  required int pillNumberIntoPillSheet,
  required PillSheet pillSheet,
}) {
  if (pillNumberIntoPillSheet > pillSheet.typeInfo.dosingPeriod) {
    return (pillSheet.pillSheetType == PillSheetType.pillsheet_21 || pillSheet.pillSheetType == PillSheetType.pillsheet_24_rest_4)
        ? PillMarkType.rest
        : PillMarkType.fake;
  }
  if (pillNumberIntoPillSheet <= pillSheet.lastCompletedPillNumber) {
    return PillMarkType.done;
  }
  if (pillNumberIntoPillSheet < pillSheet.todayPillNumber) {
    return PillMarkType.normal;
  }
  return PillMarkType.normal;
}

class _MenstruationRange {
  final int begin;
  final int end;

  _MenstruationRange(this.begin, this.end);

  bool contains(int pillNumber) => begin <= pillNumber && pillNumber <= end;
}

bool shouldPillMarkAnimation({
  required int pillNumberIntoPillSheet,
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
      if (pillNumberIntoPillSheet > pillSheet.lastCompletedPillNumber) {
        return true;
      }
    }
    return false;
  }

  return pillNumberIntoPillSheet > activedPillSheet.lastCompletedPillNumber && pillNumberIntoPillSheet <= activedPillSheet.todayPillNumber;
}
