import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/formatter/text_input_formatter.dart';
import 'package:pilll/utils/local_notification.dart';

class DisplayNumberSettingSheet extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  const DisplayNumberSettingSheet({super.key, required this.pillSheetGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final begin = useState(pillSheetGroup.displayNumberSetting?.beginPillNumber);
    final end = useState(pillSheetGroup.displayNumberSetting?.endPillNumber);

    final beginTextFieldController = useTextEditingController(text: '${begin.value ?? 1}');
    final endTextFieldController = useTextEditingController(text: '${end.value ?? pillSheetGroup.sequentialEstimatedEndPillNumber}');

    final beforePillSheetGroup = ref.watch(beforePillSheetGroupProvider).valueOrNull;

    const estimatedKeyboardHeight = 216;
    const offset = 24;
    final height = 1 - ((estimatedKeyboardHeight - offset) / MediaQuery.of(context).size.height);

    final batchFactory = ref.watch(batchFactoryProvider);
    final batchSetPillSheetGroup = ref.watch(batchSetPillSheetGroupProvider);
    final batchSetPillSheetModifiedHistory = ref.watch(batchSetPillSheetModifiedHistoryProvider);
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    return DraggableScrollableSheet(
      initialChildSize: height,
      maxChildSize: height,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: AppColors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Text(
                  L.changePillDaysForSheet,
                  style: const TextStyle(
                    color: TextColor.main,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                RedTextButton(
                  text: L.change,
                  onPressed: () async {
                    analytics.logEvent(
                      name: 'sheet_change_display_number_setting',
                    );
                    await _submit(
                      batchFactory: batchFactory,
                      batchSetPillSheetGroup: batchSetPillSheetGroup,
                      batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
                      begin: begin,
                      end: end,
                    );
                    await registerReminderLocalNotification();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(
                            seconds: 2,
                          ),
                          content: Text(L.changedStartAndEndNumbers),
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                )
              ]),
              const SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('images/begin_display_number_setting.svg'),
                          const SizedBox(width: 4),
                          Text(
                            L.startOfPillDays,
                            style: const TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: TextColor.main,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            L.taking,
                            style: const TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: TextColor.main,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 42,
                            height: 40,
                            child: TextField(
                              style: const TextStyle(
                                color: TextColor.darkGray,
                                fontSize: 15,
                                fontFamily: FontFamily.number,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                              controller: beginTextFieldController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                AppTextFieldFormatter.greaterThanZero,
                              ],
                              decoration: const InputDecoration(
                                fillColor: AppColors.mat,
                                filled: true,
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(width: 1),
                                ),
                                contentPadding: EdgeInsets.only(bottom: 8),
                              ),
                              onChanged: (text) {
                                try {
                                  begin.value = int.parse(text);
                                } catch (_) {}
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            L.startFromNumber,
                            style: const TextStyle(
                              fontFamily: FontFamily.japanese,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: TextColor.main,
                            ),
                          ),
                        ],
                      ),
                      if (beforePillSheetGroup != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              L.estimatedEndPillNumber(beforePillSheetGroup.sequentialEstimatedEndPillNumber),
                              style: const TextStyle(
                                fontFamily: FontFamily.japanese,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: TextColor.main,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      SvgPicture.asset('images/end_display_number_setting.svg'),
                      const SizedBox(width: 4),
                      Text(
                        L.changeEndOfPillDays,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: TextColor.main,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 42,
                        height: 40,
                        child: TextField(
                          style: const TextStyle(
                            color: TextColor.darkGray,
                            fontSize: 15,
                            fontFamily: FontFamily.number,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          controller: endTextFieldController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            AppTextFieldFormatter.greaterThanZero,
                          ],
                          decoration: const InputDecoration(
                            fillColor: AppColors.mat,
                            filled: true,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            contentPadding: EdgeInsets.only(bottom: 8),
                          ),
                          onChanged: (text) {
                            try {
                              end.value = int.parse(text);
                            } catch (_) {}
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        L.changedToNumber,
                        style: const TextStyle(
                          fontFamily: FontFamily.japanese,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: TextColor.main,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit({
    required BatchFactory batchFactory,
    required BatchSetPillSheetGroup batchSetPillSheetGroup,
    required BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory,
    required ValueNotifier<int?> begin,
    required ValueNotifier<int?> end,
  }) async {
    final PillSheetGroupDisplayNumberSetting? updatedDisplayNumberSetting;
    if (begin.value == null && end.value == null) {
      updatedDisplayNumberSetting = null;
    } else {
      updatedDisplayNumberSetting = PillSheetGroupDisplayNumberSetting(
        beginPillNumber: begin.value ?? 1,
        endPillNumber: end.value ?? 1,
      );
    }
    if (updatedDisplayNumberSetting == null) {
      return;
    }

    final updatedPillSheetGroup = pillSheetGroup.copyWith(
      displayNumberSetting: updatedDisplayNumberSetting,
    );
    final batch = batchFactory.batch();
    if (begin.value != pillSheetGroup.displayNumberSetting?.beginPillNumber) {
      batchSetPillSheetModifiedHistory(
        batch,
        PillSheetModifiedHistoryServiceActionFactory.createChangedBeginDisplayNumberAction(
          pillSheetGroupID: pillSheetGroup.id,
          beforeDisplayNumberSetting: pillSheetGroup.displayNumberSetting,
          afterDisplayNumberSetting: updatedDisplayNumberSetting,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        ),
      );
    }

    if (end.value != pillSheetGroup.displayNumberSetting?.endPillNumber) {
      batchSetPillSheetModifiedHistory(
        batch,
        PillSheetModifiedHistoryServiceActionFactory.createChangedEndDisplayNumberAction(
          pillSheetGroupID: pillSheetGroup.id,
          beforeDisplayNumberSetting: pillSheetGroup.displayNumberSetting,
          afterDisplayNumberSetting: updatedDisplayNumberSetting,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        ),
      );
    }

    batchSetPillSheetGroup(
      batch,
      updatedPillSheetGroup,
    );

    await batch.commit();
  }
}

void showDisplayNumberSettingSheet(
  BuildContext context, {
  required PillSheetGroup pillSheetGroup,
}) {
  analytics.setCurrentScreen(screenName: 'DisplayNumberSettingSheet');
  showModalBottomSheet(
    context: context,
    builder: (context) => DisplayNumberSettingSheet(
      pillSheetGroup: pillSheetGroup,
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
