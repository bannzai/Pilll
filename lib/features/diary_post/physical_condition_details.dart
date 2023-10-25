import 'package:pilll/features/diary_post/util.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/diary_setting_physical_condtion_detail/page.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/provider/user.dart';
import 'package:flutter/material.dart';

class DiaryPostPhysicalConditionDetails extends StatelessWidget {
  const DiaryPostPhysicalConditionDetails({
    Key? key,
    required this.premiumAndTrial,
    required this.diarySetting,
    required this.context,
    required this.physicalConditionDetails,
  }) : super(key: key);

  final PremiumAndTrial premiumAndTrial;
  final DiarySetting? diarySetting;
  final BuildContext context;
  final ValueNotifier<List<String>> physicalConditionDetails;

  @override
  Widget build(BuildContext context) {
    late List<String> availablePhysicalConditionDetails;
    if (premiumAndTrial.premiumOrTrial) {
      availablePhysicalConditionDetails = diarySetting?.physicalConditions ?? defaultPhysicalConditions;
    } else {
      availablePhysicalConditionDetails = defaultPhysicalConditions;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("体調詳細", style: sectionTitle),
            const SizedBox(width: 12),
            IconButton(
              onPressed: () {
                analytics.logEvent(name: "edit_physical_condition_detail");
                if (premiumAndTrial.isPremium || premiumAndTrial.isTrial) {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height - 200,
                          child: const DiarySettingPhysicalConditionDetailPage(),
                        );
                      });
                } else {
                  showPremiumIntroductionSheet(context);
                }
              },
              padding: const EdgeInsets.all(4),
              icon: const Icon(
                Icons.edit,
              ),
              iconSize: 20,
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: availablePhysicalConditionDetails
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: physicalConditionDetails.value.contains(e) ? TextColor.white : TextColor.darkGray,
                    ),
                    disabledColor: PilllColors.disabledSheet,
                    selectedColor: PilllColors.primary,
                    selected: physicalConditionDetails.value.contains(e),
                    onSelected: (selected) {
                      if (physicalConditionDetails.value.contains(e)) {
                        physicalConditionDetails.value = [...physicalConditionDetails.value]..remove(e);
                      } else {
                        physicalConditionDetails.value = [...physicalConditionDetails.value, e];
                      }
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}
