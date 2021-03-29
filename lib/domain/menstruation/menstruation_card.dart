import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/store/pill_sheet.dart';
import 'package:pilll/store/setting.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/datetime/day.dart' as utility;
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class MenstruationCard extends HookWidget {
  const MenstruationCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pillSheetState = useProvider(pillSheetStoreProvider.state);
    final settingState = useProvider(settingStoreProvider.state);
    final pillSheetEntity = pillSheetState.entity;
    final settingEntity = settingState.entity;
    return AppCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("images/menstruation_icon.svg", width: 20),
              Text("生理予定日",
                  style: TextColorStyle.noshime.merge(FontType.assisting)),
            ],
          ),
          Text(
            () {
              if (pillSheetEntity == null) {
                return "";
              }
              if (settingEntity == null) {
                return "";
              }
              for (int i = 0; i < 12; i += 1) {
                final begin =
                    menstruationDateRange(pillSheetEntity, settingEntity, i)
                        .begin;
                if (begin.isAfter(utility.today())) {
                  return DateTimeFormatter.monthAndWeekday(begin);
                }
              }
              return "";
            }(),
            style: TextColorStyle.gray.merge(
              FontType.xBigTitle,
            ),
          ),
        ],
      ),
    );
  }
}
