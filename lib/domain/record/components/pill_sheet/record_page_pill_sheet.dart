import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_weekday_line.dart';
import 'package:pilll/domain/modal/release_note.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_state_notifier.dart';
import 'package:pilll/domain/record/util/request_in_app_review.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

class RecordPagePillSheet extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final Setting setting;
  final RecordPageStateNotifier store;
  final RecordPageState state;

  List<PillSheetType> get pillSheetTypes =>
      pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();

  const RecordPagePillSheet({
    Key? key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.setting,
    required this.store,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekdayDate = pillSheet.beginingDate.add(Duration(
        days: summarizedRestDuration(
            restDurations: pillSheet.restDurations, upperDate: today())));

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
    required int lineIndex,
    required int pageIndex,
  }) {
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length >
        pillSheet.pillSheetType.totalCount) {
      int diff = pillSheet.pillSheetType.totalCount -
          lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }
    return List.generate(Weekday.values.length, (columnIndex) {
      if (columnIndex >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }
      final pillNumberIntoPillSheet =
          PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(
              columnIndex, lineIndex);
      return Container(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          textOfPillNumber: textOfPillNumber(
            premiumAndTrial: state.premiumAndTrial,
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
            showsCheckmark: store.isDone(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
            ),
            pillMarkType: pillMarkFor(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pillSheet: pillSheet,
            ),
          ),
          onTap: () async {
            try {
              analytics.logEvent(name: "pill_mark_tapped", parameters: {
                "last_taken_pill_number": pillSheet.lastTakenPillNumber,
                "today_pill_number": pillSheet.todayPillNumber,
              });

              if (pillSheet.todayPillNumber < pillNumberIntoPillSheet) {
                return;
              }

              if (pillSheet.lastTakenPillNumber >= pillNumberIntoPillSheet) {
                await store.asyncAction.revertTaken(
                    pillSheetGroup: pillSheetGroup,
                    pageIndex: pageIndex,
                    pillNumberIntoPillSheet: pillNumberIntoPillSheet);
              } else {
                // NOTE: batch.commit でリモートのDBに書き込む時間がかかるので事前にバッジを0にする
                FlutterAppBadger.removeBadge();
                await store.asyncAction.takenWithPillNumber(
                  pillSheetGroup: pillSheetGroup,
                  pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                  pillSheet: pillSheet,
                );
                requestInAppReview();
                showReleaseNotePreDialog(context);
              }
            } catch (exception, stack) {
              errorLogger.recordError(exception, stack);
              showErrorAlert(context, message: exception.toString());
            }
          },
        ),
      );
    });
  }

  static Widget textOfPillNumber({
    required int pillNumberIntoPillSheet,
    required int pageIndex,
    required PillSheetGroup pillSheetGroup,
    required PillSheet pillSheet,
    required PremiumAndTrial premiumAndTrial,
    required Setting setting,
  }) {
    final isPremiumOrTrial =
        premiumAndTrial.isPremium || premiumAndTrial.isTrial;
    final containedMenstruationDuration =
        RecordPagePillSheet.isContainedMenstruationDuration(
      pillNumberIntoPillSheet: pillNumberIntoPillSheet,
      pillSheetGroup: pillSheetGroup,
      setting: setting,
      pageIndex: pageIndex,
    );
    if (isPremiumOrTrial &&
        setting.pillSheetAppearanceMode == PillSheetAppearanceMode.date) {
      final DateTime date =
          pillSheet.displayPillTakeDate(pillNumberIntoPillSheet);

      if (setting.pillNumberForFromMenstruation == 0 ||
          setting.durationMenstruation == 0) {
        return PlainPillDate(date: date);
      }

      if (containedMenstruationDuration) {
        return MenstruationPillDate(date: date);
      } else {
        return PlainPillDate(date: date);
      }
    } else if (setting.pillSheetAppearanceMode ==
        PillSheetAppearanceMode.sequential) {
      final pageOffset = summarizedPillCountWithPillSheetTypesToEndIndex(
        pillSheetTypes:
            pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
        endIndex: pageIndex,
      );
      if (setting.pillNumberForFromMenstruation == 0 ||
          setting.durationMenstruation == 0) {
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
          pageOffset: pageOffset,
          displayNumberSetting: pillSheetGroup.displayNumberSetting,
          pillNumberIntoPillSheet: pillNumberIntoPillSheet);
    } else {
      if (setting.pillNumberForFromMenstruation == 0 ||
          setting.durationMenstruation == 0) {
        return PlainPillNumber(
            pillNumberIntoPillSheet: pillNumberIntoPillSheet);
      }

      if (isPremiumOrTrial) {
        if (containedMenstruationDuration) {
          return MenstruationPillNumber(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet);
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
    final pillSheetTotalCount =
        pillSheetGroup.pillSheets[pageIndex].typeInfo.totalCount;
    if (setting.pillNumberForFromMenstruation < pillSheetTotalCount) {
      final left = setting.pillNumberForFromMenstruation;
      final right = setting.pillNumberForFromMenstruation +
          setting.durationMenstruation -
          1;
      return left <= pillNumberIntoPillSheet &&
          pillNumberIntoPillSheet <= right;
    }
    final passedCount = summarizedPillCountWithPillSheetTypesToEndIndex(
        pillSheetTypes:
            pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList(),
        endIndex: pageIndex);
    final serialiedPillNumber = passedCount + pillNumberIntoPillSheet;

    final menstruationRangeList =
        List.generate(pillSheetGroup.pillSheets.length, (index) {
      final begin = setting.pillNumberForFromMenstruation * (index + 1);
      final end = begin + setting.durationMenstruation - 1;
      return _MenstruationRange(begin, end);
    });

    final isContainedMenstruationDuration = menstruationRangeList
        .where((element) => element.contains(serialiedPillNumber))
        .isNotEmpty;
    return isContainedMenstruationDuration;
  }
}

class _MenstruationRange {
  final int begin;
  final int end;

  _MenstruationRange(this.begin, this.end);

  bool contains(int pillNumber) => begin <= pillNumber && pillNumber <= end;
}
