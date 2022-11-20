import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/provider/diary_setting.dart';
import 'package:pilll/features/diary_setting_physical_condtion_detail/page.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/const.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

const _secitonTitle = TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 16, color: TextColor.black);

class DiaryPostPage extends HookConsumerWidget {
  final DateTime date;
  final Diary? diary;

  const DiaryPostPage(this.date, this.diary, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diary = this.diary ?? Diary.fromDate(date);

    return AsyncValueGroup.group2(ref.watch(premiumAndTrialProvider), ref.watch(diarySettingProvider)).when(
      data: (data) => DiaryPostPageBody(
        date: date,
        diary: diary,
        premiumAndTrial: data.t1,
        diarySetting: data.t2,
      ),
      error: (error, stackTrace) => UniversalErrorPage(
        error: error,
        reload: () => ref.refresh(refreshAppProvider),
        child: null,
      ),
      loading: () => const Indicator(),
    );
  }
}

extension DiaryPostPageRoute on DiaryPostPage {
  static Route<dynamic> route(DateTime date, Diary? diary) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "DiaryPostPage"),
      builder: (_) => DiaryPostPage(date, diary),
      fullscreenDialog: true,
    );
  }
}

class DiaryPostPageBody extends HookConsumerWidget {
  final DateTime date;
  final Diary diary;
  final PremiumAndTrial premiumAndTrial;
  final DiarySetting? diarySetting;

  const DiaryPostPageBody({
    Key? key,
    required this.date,
    required this.diary,
    required this.premiumAndTrial,
    required this.diarySetting,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController(text: diary.memo);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    final offset = MediaQuery.of(context).viewInsets.bottom + keyboardToolbarHeight + 60;

    final physicalCondition = useState<PhysicalConditionStatus?>(diary.physicalConditionStatus);
    final physicalConditionDetails = useState(diary.physicalConditions);
    final sex = useState(diary.hasSex);
    final memo = useState(diary.memo);

    final setDiary = ref.watch(setDiaryProvider);

    return Scaffold(
      backgroundColor: PilllColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AlertButton(
              text: "保存",
              onPressed: () async {
                analytics.logEvent(name: "diary_post_button_tapped");

                await setDiary(diary.copyWith(
                  physicalConditionStatus: physicalCondition.value,
                  physicalConditions: physicalConditionDetails.value,
                  hasSex: sex.value,
                  memo: memo.value,
                ));

                Navigator.of(context).pop();
              }),
        ],
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, offset),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(DateTimeFormatter.yearAndMonthAndDay(date),
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: TextColor.main,
                      )),
                  ...[
                    _physicalCondition(physicalCondition),
                    _physicalConditionDetails(context, physicalConditionDetails),
                    _sex(sex),
                    _memo(context, textEditingController, focusNode, memo),
                  ].map((e) => _withContentSpacer(e)),
                ],
              ),
            ),
            if (focusNode.hasFocus) _keyboardToolbar(context, focusNode),
          ],
        ),
      ),
    );
  }

  Widget _withContentSpacer(Widget content) {
    return Container(
      child: content,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
    );
  }

  Widget _physicalCondition(ValueNotifier<PhysicalConditionStatus?> physicalCondition) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("体調", style: _secitonTitle),
        const Spacer(),
        Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: PilllColors.divider,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                  color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad) ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/angry.svg",
                        color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad) ? PilllColors.primary : TextColor.darkGray),
                    onPressed: () {
                      if (diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad)) {
                        physicalCondition.value = null;
                      } else {
                        physicalCondition.value = PhysicalConditionStatus.bad;
                      }
                    }),
              ),
              const SizedBox(height: 48, child: VerticalDivider(width: 1, color: PilllColors.divider)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine) ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/laugh.svg",
                        color: diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine) ? PilllColors.primary : TextColor.darkGray),
                    onPressed: () {
                      if (diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine)) {
                        physicalCondition.value = null;
                      } else {
                        physicalCondition.value = PhysicalConditionStatus.fine;
                      }
                    }),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _physicalConditionDetails(BuildContext context, ValueNotifier<List<String>> physicalConditionDetails) {
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
            const Text("体調詳細", style: _secitonTitle),
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
                      color: diary.physicalConditions.contains(e) ? TextColor.white : TextColor.darkGray,
                    ),
                    disabledColor: PilllColors.disabledSheet,
                    selectedColor: PilllColors.primary,
                    selected: diary.physicalConditions.contains(e),
                    onSelected: (selected) {
                      if (diary.physicalConditions.contains(e)) {
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

  Widget _sex(ValueNotifier<bool> sex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("sex", style: _secitonTitle),
        const SizedBox(width: 80),
        GestureDetector(
          onTap: () {
            sex.value = !sex.value;
          },
          child: Container(
              padding: const EdgeInsets.all(4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle, color: diary.hasSex ? PilllColors.thinSecondary : PilllColors.disabledSheet),
              child: SvgPicture.asset("images/heart.svg", color: diary.hasSex ? PilllColors.primary : TextColor.darkGray)),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _keyboardToolbar(BuildContext context, FocusNode focusNode) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: Container(
        height: keyboardToolbarHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            const Spacer(),
            AlertButton(
              text: '完了',
              onPressed: () async {
                analytics.logEvent(name: "post_diary_done_button_pressed");
                focusNode.unfocus();
              },
            ),
          ],
        ),
        decoration: const BoxDecoration(color: PilllColors.white),
      ),
    );
  }

  Widget _memo(
    BuildContext context,
    TextEditingController textEditingController,
    FocusNode focusNode,
    ValueNotifier<String> memo,
  ) {
    const textLength = 120;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 40,
        maxHeight: 200,
      ),
      child: TextFormField(
        onChanged: (text) {
          memo.value = text;
        },
        decoration: const InputDecoration(
          hintText: "メモ",
          border: OutlineInputBorder(),
        ),
        controller: textEditingController,
        maxLines: null,
        maxLength: textLength,
        keyboardType: TextInputType.multiline,
        focusNode: focusNode,
      ),
    );
  }
}
