import 'package:Pilll/main/components/indicator.dart';
import 'package:Pilll/main/components/pill/pill_sheet.dart';
import 'package:Pilll/main/record/record_taken_information.dart';
import 'package:Pilll/model/pill_mark_type.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/today.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/all.dart';

class RecordPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: null,
      extendBodyBehindAppBar: true,
      body: _body(),
    );
  }

  Widget _body() {
    final currentPillSheet = useProvider(pillSheetStoreProvider.state).entity;
    final store = useProvider(pillSheetStoreProvider);
    final settingState = useProvider(settingStoreProvider.state);
    if (settingState.entity == null || !store.firstLoadIsEnded) {
      return Indicator();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: [
              RecordTakenInformation(
                today: DateTime.now(),
                pillSheetModel: currentPillSheet,
              ),
              if (_notificationString(currentPillSheet).isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 26),
                  child: Container(
                    height: 26,
                    color: PilllColors.attention,
                    child: Center(
                      child: Text(_notificationString(currentPillSheet),
                          style:
                              FontType.assisting.merge(TextColorStyle.white)),
                    ),
                  ),
                ),
            ],
          ),
          if (currentPillSheet == null)
            _empty(store, settingState.entity.pillSheetType),
          if (currentPillSheet != null) ...[
            _pillSheet(currentPillSheet, store),
            SizedBox(height: 24),
            currentPillSheet.allTaken
                ? _cancelTakeButton(currentPillSheet, store)
                : _takenButton(currentPillSheet, store),
          ],
          SizedBox(height: 8),
        ],
      ),
    );
  }

  String _notificationString(PillSheetModel currentPillSheet) {
    if (currentPillSheet.typeInfo.dosingPeriod <
        currentPillSheet.todayPillNumber) {
      switch (currentPillSheet.pillSheetType) {
        case PillSheetType.pillsheet_21:
          return "休薬期間中";
        case PillSheetType.pillsheet_28_4:
          return "偽薬期間中";
        case PillSheetType.pillsheet_28_7:
          return "偽薬期間中";
      }
    }

    final threshold = 4;
    if (currentPillSheet.typeInfo.dosingPeriod - threshold + 1 <
        currentPillSheet.todayPillNumber) {
      final diff = currentPillSheet.typeInfo.dosingPeriod -
          currentPillSheet.todayPillNumber +
          1;
      return "あと$diff日で偽薬期間です";
    }

    return "";
  }

  Widget _takenButton(PillSheetModel pillSheet, PillSheetStateStore store) {
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () => _take(pillSheet, today(), store),
    );
  }

  Widget _cancelTakeButton(
      PillSheetModel pillSheet, PillSheetStateStore store) {
    return TertiaryButton(
      text: "飲んでない",
      onPressed: () => _cancelTake(pillSheet, store),
    );
  }

  void _take(
      PillSheetModel pillSheet, DateTime takenDate, PillSheetStateStore store) {
    if (pillSheet.todayPillNumber == pillSheet.lastTakenPillNumber) {
      return;
    }
    store.take(takenDate);
  }

  void _cancelTake(PillSheetModel pillSheet, PillSheetStateStore store) {
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      throw FormatException(
          "This statement should pillSheet.allTaken is true and build _cancelTakeButton. pillSheet.allTaken is ${pillSheet.allTaken} and lastTakenPillNumber ${pillSheet.lastTakenPillNumber}, todayPillNumber ${pillSheet.todayPillNumber}");
    }
    store.take(pillSheet.lastTakenDate.subtract(Duration(days: 1)));
  }

  PillSheet _pillSheet(PillSheetModel pillSheet, PillSheetStateStore store) {
    return PillSheet(
      isHideWeekdayLine: false,
      pillMarkTypeBuilder: (number) {
        if (number <= pillSheet.lastTakenPillNumber) {
          return PillMarkType.done;
        }
        if (number > pillSheet.typeInfo.dosingPeriod) {
          return PillMarkType.notTaken;
        }
        if (number < pillSheet.todayPillNumber) {
          return PillMarkType.normal;
        }
        return PillMarkType.normal;
      },
      enabledMarkAnimation: (number) {
        if (number > pillSheet.typeInfo.dosingPeriod) {
          return false;
        }
        return number > pillSheet.lastTakenPillNumber &&
            number <= pillSheet.todayPillNumber;
      },
      markSelected: (number) {
        if (number <= pillSheet.lastTakenPillNumber) {
          return;
        }
        var diff = pillSheet.todayPillNumber - number;
        if (diff < 0) {
          // This is in the future pill number.
          return;
        }
        var takenDate = today().subtract(Duration(days: diff));
        _take(pillSheet, takenDate, store);
      },
    );
  }

  Widget _empty(PillSheetStateStore store, PillSheetType pillSheetType) {
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
        store.register(pillSheet).whenComplete(() => progressing = false);
      },
    );
  }
}
