import 'package:Pilll/main/components/indicator.dart';
import 'package:Pilll/main/components/pill/pill_mark.dart';
import 'package:Pilll/main/components/pill/pill_sheet.dart';
import 'package:Pilll/main/record/record_taken_information.dart';
import 'package:Pilll/model/app_state.dart';
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
        shouldRebuild: (prev, next) => !identical(prev, next),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RecordTakenInformation(
                      today: DateTime.now(),
                      pillSheetModel: AppState.shared.currentPillSheet,
                    ),
                    if (pillSheet == null) _empty(),
                    if (pillSheet != null) ...[
                      _pillSheet(),
                      SizedBox(height: 24),
                      Container(
                        height: 44,
                        width: 180,
                        child: PrimaryButton(
                          text: "飲んだ",
                          onPressed: () {},
                        ),
                      ),
                    ],
                    SizedBox(height: 8),
                  ],
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

  PillSheet _pillSheet() {
    return PillSheet(
      isHideWeekdayLine: false,
      pillMarkTypeBuilder: (number) {
        return PillMarkType.normal;
      },
      markSelected: (number) {},
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
            .then((_) => AppState.shared.notifyWith(
                (model) => AppState.shared.currentPillSheet = pillSheet))
            .then((_) => progressing = false);
      },
    );
  }
}
