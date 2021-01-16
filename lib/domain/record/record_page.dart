import 'package:Pilll/analytics.dart';
import 'package:Pilll/components/molecules/indicator.dart';
import 'package:Pilll/components/organisms/pill/pill_sheet.dart';
import 'package:Pilll/domain/record/record_taken_information.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/weekday.dart';
import 'package:Pilll/error/error_alert.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/state/pill_sheet.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:Pilll/util/toolbar/picker_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';

class RecordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final state = useProvider(pillSheetStoreProvider.state);
    final store = useProvider(pillSheetStoreProvider);
    final currentPillSheet = state.entity;
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: PilllColors.white,
        toolbarHeight: 130,
        title: RecordTakenInformation(
          today: DateTime.now(),
          state: state,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                var selectedTodayPillNumber = currentPillSheet.todayPillNumber;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    PickerToolbar(
                      done: (() {
                        store.modifyBeginingDate(selectedTodayPillNumber);
                        Navigator.pop(context);
                      }),
                      cancel: (() {
                        Navigator.pop(context);
                      }),
                    ),
                    Container(
                      height: 200,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CupertinoPicker(
                          itemExtent: 40,
                          children: List.generate(
                              currentPillSheet.typeInfo.totalCount,
                              (index) => Text("${index + 1}")),
                          onSelectedItemChanged: (index) {
                            selectedTodayPillNumber = index + 1;
                          },
                          scrollController: FixedExtentScrollController(
                            initialItem: selectedTodayPillNumber - 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    hideIndicator();
    final state = useProvider(pillSheetStoreProvider.state);
    final currentPillSheet = state.entity;
    final store = useProvider(pillSheetStoreProvider);
    final settingState = useProvider(settingStoreProvider.state);
    if (settingState.entity == null || !store.firstLoadIsEnded) {
      return Indicator();
    }
    return Center(
      child: ListView(
        children: [
          if (_notificationString(state).isNotEmpty)
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: 26),
              child: Container(
                height: 26,
                color: PilllColors.secondary,
                child: Center(
                  child: Text(_notificationString(state),
                      style: FontType.assisting.merge(TextColorStyle.white)),
                ),
              ),
            ),
          SizedBox(height: 97),
          if (state.isInvalid)
            Align(
                child:
                    _empty(context, store, settingState.entity.pillSheetType)),
          if (!state.isInvalid) ...[
            Align(child: _pillSheet(context, currentPillSheet, store)),
            SizedBox(height: 40),
            if (currentPillSheet.inNotTakenDuration)
              Align(child: _notTakenButton(context, state, store)),
            if (!currentPillSheet.inNotTakenDuration &&
                currentPillSheet.allTaken)
              Align(child: _cancelTakeButton(currentPillSheet, store)),
            if (!currentPillSheet.allTaken &&
                !currentPillSheet.inNotTakenDuration)
              Align(child: _takenButton(context, currentPillSheet, store)),
          ],
          SizedBox(height: 60),
        ],
      ),
    );
  }

  String _notificationString(PillSheetState state) {
    if (state.isInvalid) {
      return "";
    }
    final pillSheet = state.entity;
    if (pillSheet == null) {
      return "";
    }
    if (pillSheet.typeInfo.dosingPeriod < pillSheet.todayPillNumber) {
      switch (pillSheet.pillSheetType) {
        case PillSheetType.pillsheet_21:
          return "休薬期間中";
        case PillSheetType.pillsheet_28_4:
          return "偽薬期間中";
        case PillSheetType.pillsheet_28_7:
          return "偽薬期間中";
      }
    }

    final threshold = 4;
    if (pillSheet.typeInfo.dosingPeriod - threshold + 1 <
        pillSheet.todayPillNumber) {
      final diff =
          pillSheet.typeInfo.dosingPeriod - pillSheet.todayPillNumber + 1;
      return "あと$diff日で偽薬期間です";
    }

    return "";
  }

  Widget _takenButton(
    BuildContext context,
    PillSheetModel pillSheet,
    PillSheetStateStore store,
  ) {
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () {
        analytics.logEvent(name: "takenButtonPressed", parameters: {
          "lastTakenDate": pillSheet.lastTakenPillNumber,
          "todayPillNumber": pillSheet.todayPillNumber,
        });
        _take(context, pillSheet, now(), store);
      },
    );
  }

  Widget _cancelTakeButton(
      PillSheetModel pillSheet, PillSheetStateStore store) {
    return TertiaryButton(
      text: "飲んでない",
      onPressed: () {
        analytics.logEvent(name: "cancelTakenButtonPressed", parameters: {
          "lastTakenDate": pillSheet.lastTakenPillNumber,
          "todayPillNumber": pillSheet.todayPillNumber,
        });
        _cancelTake(pillSheet, store);
      },
    );
  }

  Widget _notTakenButton(
    BuildContext context,
    PillSheetState state,
    PillSheetStateStore store,
  ) {
    return TertiaryButton(
      text: _notificationString(state),
      onPressed: () {},
    );
  }

  void _take(
    BuildContext context,
    PillSheetModel pillSheet,
    DateTime takenDate,
    PillSheetStateStore store,
  ) {
    if (pillSheet.todayPillNumber == pillSheet.lastTakenPillNumber) {
      return;
    }
    store.take(takenDate);
  }

  void _cancelTake(PillSheetModel pillSheet, PillSheetStateStore store) {
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      return;
    }
    store.take(pillSheet.lastTakenDate.subtract(Duration(days: 1)));
  }

  PillSheet _pillSheet(
    BuildContext context,
    PillSheetModel pillSheet,
    PillSheetStateStore store,
  ) {
    return PillSheet(
      firstWeekday: pillSheet.beginingDate == null
          ? Weekday.Sunday
          : WeekdayFunctions.weekdayFromDate(pillSheet.beginingDate),
      doneStateBuilder: (number) {
        return number <= pillSheet.todayPillNumber;
      },
      pillMarkTypeBuilder: (number) => store.markFor(number),
      enabledMarkAnimation: (number) => store.shouldPillMarkAnimation(number),
      markSelected: (number) {
        analytics.logEvent(name: "pillMarkTapped", parameters: {
          "number": number,
          "lastTakenDate": pillSheet.lastTakenPillNumber,
          "todayPillNumber": pillSheet.todayPillNumber,
        });
        if (number <= pillSheet.lastTakenPillNumber) {
          return;
        }
        var diff = pillSheet.todayPillNumber - number;
        if (diff < 0) {
          // This is in the future pill number.
          return;
        }
        var takenDate = now().subtract(Duration(days: diff));
        _take(context, pillSheet, takenDate, store);
      },
    );
  }

  Widget _empty(BuildContext context, PillSheetStateStore store,
      PillSheetType pillSheetType) {
    var progressing = false;
    return GestureDetector(
      child: SizedBox(
        width: PillSheet.size.width,
        height: PillSheet.size.height,
        child: Stack(
          children: <Widget>[
            Center(child: SvgPicture.asset("images/empty_frame.svg")),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.add, color: TextColor.noshime),
                Text("ピルシートを追加",
                    style: FontType.assisting.merge(TextColorStyle.noshime)),
              ],
            )),
          ],
        ),
      ),
      onTap: () {
        if (progressing) return;
        progressing = true;

        var pillSheet = PillSheetModel.create(pillSheetType);
        store.register(pillSheet).catchError((error) {
          showErrorAlert(
            context,
            message: "ピルシートがすでに存在しています。表示等に問題がある場合は設定タブから「お問い合わせ」ください",
          );
        }, test: (e) => e is PillSheetAlreadyExists).catchError((error) {
          showErrorAlert(
            context,
            message: "ピルシートの作成に失敗しました。時間をおいて再度お試しください",
          );
        }, test: (e) => e is PillSheetAlreadyDeleted).whenComplete(
            () => progressing = false);
      },
    );
  }
}
