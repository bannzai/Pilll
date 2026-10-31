import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/features/menstruation/menstruation_card_state.codegen.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class MenstruationCard extends StatelessWidget {
  final MenstruationCardState state;

  const MenstruationCard(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    // 訳の長い言語ではラベルと日付が 1 行に収まらず日付を次の行に落とすため、高さは固定せず従来の 111 を下限にする
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 111),
      child: AppCard(
        child: Padding(
          // ラベルや日付がカードの端に接しないよう、カードの角丸 (12) より少し広い余白にした
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'images/menstruation.svg',
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.red,
                          BlendMode.srcIn,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          state.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: TextColor.noshime,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateTimeFormatter.monthAndWeekday(state.scheduleDate),
                    style: const TextStyle(
                      color: TextColor.gray,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.japanese,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  top: 2,
                  bottom: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  state.countdownString,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: TextColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
