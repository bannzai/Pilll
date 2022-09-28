import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/diary_post/state.codegen.dart';
import 'package:pilll/domain/diary_post/state_notifier.dart';
import 'package:pilll/domain/diary_post/diary_post_state_provider_family.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/page.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/const.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

const _secitonTitle = TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: FontSize.sLarge, color: TextColor.black);

class DiaryPostPage extends HookConsumerWidget {
  final DateTime date;
  final Diary? diary;

  const DiaryPostPage(this.date, this.diary, {Key? key}) : super(key: key);

  DiaryPostStateProviderFamily _family() {
    return DiaryPostStateProviderFamily(date: date, diary: diary);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateNotifier = ref.watch(diaryPostStateNotifierProvider(_family()).notifier);
    final asyncState = ref.watch(diaryPostStateNotifierProvider(_family()));

    if (asyncState is AsyncLoading) {
      return const ScaffoldIndicator();
    }

    late DiaryPostState state;
    try {
      state = asyncState.value!;
    } catch (error) {
      return UniversalErrorPage(error: error, child: null, reload: () => ref.refresh(diaryPostAsyncStateProvider(_family())));
    }

    final TextEditingController? textEditingController = useTextEditingController(text: state.diary.memo);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // NOTE: The final keyboard height cannot be got at the moment of focus via MediaQuery.of(context).viewInsets.bottom. so it is delayed.
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          final overwrapHeight = focusNode.rect.bottom - (MediaQuery.of(context).viewInsets.bottom + keyboardToolbarHeight);
          if (overwrapHeight > 0) {
            scrollController.animateTo(overwrapHeight, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        });
      } else {
        scrollController.animateTo(scrollController.position.minScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
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
            onPressed: () => stateNotifier.register().then((value) {
              Navigator.of(context).pop();
            }),
          ),
        ],
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(DateTimeFormatter.yearAndMonthAndDay(date), style: FontType.sBigTitle.merge(TextColorStyle.main)),
                    ...[
                      _physicalConditions(stateNotifier, state),
                      _physicalConditionDetails(context, stateNotifier, state),
                      _sex(stateNotifier, state),
                      _memo(context, textEditingController, focusNode, stateNotifier, state),
                    ].map((e) => _withContentSpacer(e)),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom + keyboardToolbarHeight + 60,
                    ),
                  ],
                ),
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

  Widget _physicalConditions(DiaryPostStateNotifier store, DiaryPostState state) {
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
                  color: state.diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad) ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/angry.svg",
                        color: state.diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.bad) ? PilllColors.secondary : TextColor.darkGray),
                    onPressed: () {
                      store.switchingPhysicalCondition(PhysicalConditionStatus.bad);
                    }),
              ),
              const SizedBox(height: 48, child: VerticalDivider(width: 1, color: PilllColors.divider)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                  color: state.diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine) ? PilllColors.thinSecondary : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/laugh.svg",
                        color: state.diary.hasPhysicalConditionStatusFor(PhysicalConditionStatus.fine) ? PilllColors.secondary : TextColor.darkGray),
                    onPressed: () {
                      store.switchingPhysicalCondition(PhysicalConditionStatus.fine);
                    }),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _physicalConditionDetails(BuildContext context, DiaryPostStateNotifier store, DiaryPostState state) {
    late List<String> physicalConditionDetails;
    if (state.premiumAndTrial.premiumOrTrial) {
      physicalConditionDetails = state.diarySetting?.physicalConditions ?? defaultPhysicalConditions;
    } else {
      physicalConditionDetails = defaultPhysicalConditions;
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
                if (state.premiumAndTrial.isPremium || state.premiumAndTrial.isTrial) {
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
          children: physicalConditionDetails
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: FontType.assisting.merge(state.diary.physicalConditions.contains(e) ? TextColorStyle.white : TextColorStyle.darkGray),
                    disabledColor: PilllColors.disabledSheet,
                    selectedColor: PilllColors.secondary,
                    selected: state.diary.physicalConditions.contains(e),
                    onSelected: (selected) {
                      state.diary.physicalConditions.contains(e) ? store.removePhysicalCondition(e) : store.addPhysicalCondition(e);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _sex(DiaryPostStateNotifier store, DiaryPostState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("sex", style: _secitonTitle),
        const SizedBox(width: 80),
        GestureDetector(
          onTap: () {
            store.toggleHasSex();
          },
          child: Container(
              padding: const EdgeInsets.all(4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(shape: BoxShape.circle, color: state.diary.hasSex ? PilllColors.thinSecondary : PilllColors.disabledSheet),
              child: SvgPicture.asset("images/heart.svg", color: state.diary.hasSex ? PilllColors.secondary : TextColor.darkGray)),
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
    TextEditingController? textEditingController,
    FocusNode focusNode,
    DiaryPostStateNotifier store,
    DiaryPostState state,
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
          store.editedMemo(text);
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

extension DiaryPostPageRoute on DiaryPostPage {
  static Route<dynamic> route(DateTime date, Diary? diary) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "DiaryPostPage"),
      builder: (_) => DiaryPostPage(date, diary),
      fullscreenDialog: true,
    );
  }
}
