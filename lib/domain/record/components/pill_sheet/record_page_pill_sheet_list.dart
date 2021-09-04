import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_view.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordPagePillSheetList extends HookWidget {
  const RecordPagePillSheetList({
    Key? key,
    required this.state,
    required this.store,
    required this.setting,
  }) : super(key: key);

  final RecordPageState state;
  final RecordPageStore store;
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = state.pillSheetGroup;
    if (pillSheetGroup == null) {
      return Container();
    }
    return Container(
      height: PillSheetView.calcHeight(
          pillSheetGroup.pillSheets.first.pillSheetType.numberOfLineInPillSheet,
          false),
      child: PageView(
        clipBehavior: Clip.none,
        controller: PageController(
            viewportFraction:
                (PillSheetView.width + 20) / MediaQuery.of(context).size.width),
        scrollDirection: Axis.horizontal,
        children: pillSheetGroup.pillSheets
            .map((pillSheet) {
              return [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _PillSheetContent(
                    pillSheet: pillSheet,
                    pillSheetGroup: pillSheetGroup,
                    store: store,
                    state: state,
                    setting: setting,
                  ),
                ),
              ];
            })
            .expand((element) => element)
            .toList(),
      ),
    );
  }
}

class _PillSheetContent extends StatelessWidget {
  const _PillSheetContent({
    Key? key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.store,
    required this.state,
    required this.setting,
  }) : super(key: key);

  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final RecordPageStore store;
  final RecordPageState state;
  final Setting setting;

  @override
  Widget build(BuildContext context) {
    return PillSheetView(
      firstWeekday: WeekdayFunctions.weekdayFromDate(pillSheet.beginingDate),
      pillSheetType: pillSheet.pillSheetType,
      doneStateBuilder: (number) =>
          store.isDone(pillNumberIntoPillSheet: number, pillSheet: pillSheet),
      pillMarkTypeBuilder: (number) => store.markFor(
        pillNumberIntoPillSheet: number,
        pillSheet: pillSheet,
      ),
      enabledMarkAnimation: (number) => store.shouldPillMarkAnimation(
        pillNumberIntoPillSheet: number,
        pillSheet: pillSheet,
      ),
      markSelected: (number) {
        analytics.logEvent(name: "pill_mark_tapped", parameters: {
          "number": number,
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });

        effectAfterTaken(
          context: context,
          taken: store.takenWithPillNumber(
              pillNumberIntoPillSheet: number, pillSheet: pillSheet),
          store: store,
        );
      },
      premiumMarkBuilder: () {
        if (!(state.isPremium || state.isTrial)) {
          return null;
        }
        if (state.appearanceMode != PillSheetAppearanceMode.date) {
          return null;
        }
        final pillSheet = state.pillSheetGroup?.activedPillSheet;
        if (pillSheet == null) {
          return null;
        }
        return (pillMarkNumber) {
          final date =
              pillSheet.beginingDate.add(Duration(days: pillMarkNumber - 1));
          return PremiumPillMarkModel(
            date: date,
            pillNumberForMenstruationBegin:
                setting.pillNumberForFromMenstruation,
            menstruationDuration: setting.durationMenstruation,
            maxPillNumber: pillSheet.pillSheetType.totalCount,
          );
        };
      }(),
    );
  }
}
