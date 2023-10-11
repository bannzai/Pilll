import 'package:pilll/features/before_pill_sheet_group_history/page.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/record/components/header/today_taken_pill_number.dart';
import 'package:pilll/features/settings/today_pill_number/setting_today_pill_number_page.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

abstract class RecordPageInformationHeaderConst {
  static const double height = 130;
}

class RecordPageInformationHeader extends StatelessWidget {
  final DateTime today;
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;
  final PremiumAndTrial premiumAndTrial;
  const RecordPageInformationHeader({
    Key? key,
    required this.today,
    required this.pillSheetGroup,
    required this.setting,
    required this.premiumAndTrial,
  }) : super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(today);
  String _todayWeekday() => DateTimeFormatter.weekday(today);

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = this.pillSheetGroup;
    final activePillSheet = pillSheetGroup?.activePillSheet;
    final setting = this.setting;

    return Stack(
      children: [
        SizedBox(
          height: RecordPageInformationHeaderConst.height,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _todayWidget(),
                  const SizedBox(width: 28),
                  const SizedBox(
                    height: 64,
                    child: VerticalDivider(
                      width: 10,
                      color: PilllColors.divider,
                    ),
                  ),
                  const SizedBox(width: 28),
                  TodayTakenPillNumber(
                      pillSheetGroup: pillSheetGroup,
                      setting: setting,
                      onPressed: () {
                        analytics.logEvent(name: "tapped_record_information_header");
                        if (activePillSheet != null && pillSheetGroup != null && !pillSheetGroup.isDeactived) {
                          Navigator.of(context).push(
                            SettingTodayPillNumberPageRoute.route(
                              pillSheetGroup: pillSheetGroup,
                              activePillSheet: activePillSheet,
                            ),
                          );
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
        // TODO:  [PillSheetModifiedHistory-V2-BeforePillSheetGroupHistory] 2024-05-01
        // ピルシートグループIDを用いてフィルタリングできるようになるので、一つ前のピルシートグループの履歴を表示する機能を解放する
        // Align(
        //   alignment: Alignment.topRight,
        //   child: IconButton(
        //     icon: const Icon(Icons.history, color: PilllColors.primary),
        //     onPressed: () {
        //       analytics.logEvent(name: "tapped_record_information_header_history");

        //       if (premiumAndTrial.isPremium || premiumAndTrial.isTrial) {
        //         Navigator.of(context).push(
        //           BeforePillSheetGroupHistoryPageRoute.route(),
        //         );
        //       } else {
        //         showPremiumIntroductionSheet(context);
        //       }
        //     },
        //     color: Colors.black,
        //   ),
        // ),
      ],
    );
  }

  Center _todayWidget() {
    return Center(
      child: Text(
        "${_formattedToday()} (${_todayWeekday()})",
        style: const TextStyle(
          fontFamily: FontFamily.number,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: TextColor.gray,
        ),
      ),
    );
  }
}
