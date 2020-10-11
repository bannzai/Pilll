import 'package:Pilll/main/components/indicator.dart';
import 'package:Pilll/main/components/pill/pill_sheet.dart';
import 'package:Pilll/main/record/record_taken_information.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/pill_mark_type.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/repository/pill_sheet.dart';
import 'package:Pilll/style/button.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/today.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: null,
      extendBodyBehindAppBar: true,
      body: Selector<AppState, PillSheetModel>(
        selector: (context, state) => state.currentPillSheet,
        shouldRebuild: (prev, next) =>
            !identical(prev, next) ||
            prev.sheetType.name != next.sheetType.name,
        builder:
            (BuildContext context, PillSheetModel pillSheet, Widget child) {
          return FutureBuilder(
            future: _fetchPillSheet(),
            builder:
                (BuildContext context, AsyncSnapshot<PillSheetModel> snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Indicator();
              var pillSheet = snapshot.data;
              return Center(
                child: Selector<AppState, int>(
                  selector: (context, state) =>
                      state.currentPillSheet?.lastTakenPillNumber ?? 0,
                  builder: (BuildContext context, int value, Widget child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RecordTakenInformation(
                          today: DateTime.now(),
                          pillSheetModel: AppState.shared.currentPillSheet,
                        ),
                        if (pillSheet == null) _empty(),
                        if (pillSheet != null) ...[
                          _pillSheet(pillSheet),
                          SizedBox(height: 24),
                          pillSheet.allTaken
                              ? _cancelTakeButton(pillSheet)
                              : _takenButton(pillSheet),
                        ],
                        SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<PillSheetModel> _fetchPillSheet() {
    return AppState.shared.currentPillSheet == null
        ? pillSheetRepository.fetchLast(AppState.shared.user.documentID).then(
            (model) => AppState.shared.updated(model,
                (state, pillSheet) => state.currentPillSheet = pillSheet))
        : Future.value(AppState.shared.currentPillSheet);
  }

  Widget _takenButton(PillSheetModel pillSheet) {
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () => _take(pillSheet, today()),
    );
  }

  Widget _cancelTakeButton(PillSheetModel pillSheet) {
    return TertiaryButton(
      text: "飲んでない",
      onPressed: () => _cancelTake(pillSheet),
    );
  }

  void _take(PillSheetModel pillSheet, DateTime takenDate) {
    if (pillSheet.todayPillNumber == pillSheet.lastTakenPillNumber) {
      return;
    }
    pillSheetRepository
        .take(AppState.shared.user.documentID, pillSheet, takenDate)
        .then((updatedPillSheet) => AppState.shared
            .notifyWith((model) => model.currentPillSheet = updatedPillSheet));
  }

  void _cancelTake(PillSheetModel pillSheet) {
    if (pillSheet.todayPillNumber != pillSheet.lastTakenPillNumber) {
      throw FormatException(
          "This statement should pillSheet.allTaken is true and build _cancelTakeButton. pillSheet.allTaken is ${pillSheet.allTaken} and lastTakenPillNumber ${pillSheet.lastTakenPillNumber}, todayPillNumber ${pillSheet.todayPillNumber}");
    }
    pillSheetRepository
        .take(AppState.shared.user.documentID, pillSheet,
            pillSheet.lastTakenDate.subtract(Duration(days: 1)))
        .then((updatedPillSheet) => AppState.shared
            .notifyWith((model) => model.currentPillSheet = updatedPillSheet));
  }

  PillSheet _pillSheet(PillSheetModel pillSheet) {
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
      markIsAnimated: (number) {
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
        _take(pillSheet, takenDate);
      },
    );
  }

  Widget _empty() {
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

        var pillSheet =
            PillSheetModel.create(AppState.shared.user.setting.pillSheetType);
        pillSheetRepository
            .register(
              AppState.shared.user.documentID,
              pillSheet,
            )
            .then((_) =>
                pillSheetRepository.fetchLast(AppState.shared.user.documentID))
            .then((pillSheet) => AppState.shared.notifyWith(
                (model) => AppState.shared.currentPillSheet = pillSheet))
            .then((_) => progressing = false);
      },
    );
  }
}
