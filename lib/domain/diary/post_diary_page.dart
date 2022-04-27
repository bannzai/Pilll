import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/diary/diary_state.codegen.dart';
import 'package:pilll/domain/diary/post_diary_store.dart';
import 'package:pilll/domain/diary/post_diary_store_provider_family.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final _postDiaryStoreProvider = StateNotifierProvider.autoDispose
    .family<PostDiaryStore, DiaryState, PostDiaryStoreProviderFamily>(
        (ref, family) {
  final service = ref.watch(diaryDatabaseProvider);
  final diary = family.diary;
  if (diary == null) {
    return PostDiaryStore(
        service, DiaryState(diary: Diary.fromDate(family.date)));
  }
  return PostDiaryStore(service, DiaryState(diary: diary.copyWith()));
});

abstract class PostDiaryPageConst {
  static double keyboardToobarHeight = 44;
}

class PostDiaryPage extends HookConsumerWidget {
  final DateTime date;
  final Diary? diary;

  PostDiaryPage(this.date, this.diary);

  PostDiaryStoreProviderFamily _family() {
    return PostDiaryStoreProviderFamily(date: date, diary: diary);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(_postDiaryStoreProvider(_family()).notifier);
    final state = ref.watch(_postDiaryStoreProvider(_family()));
    final TextEditingController? textEditingController =
        useTextEditingController(text: state.diary.memo);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // NOTE: The final keyboard height cannot be got at the moment of focus via MediaQuery.of(context).viewInsets.bottom. so it is delayed.
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          final overwrapHeight = focusNode.rect.bottom -
              (MediaQuery.of(context).viewInsets.bottom +
                  PostDiaryPageConst.keyboardToobarHeight);
          if (overwrapHeight > 0) {
            scrollController.animateTo(overwrapHeight,
                duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        });
      } else {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
            onPressed: () => store.register().then((value) {
              Navigator.of(context).pop();
            }),
          ),
        ],
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(DateTimeFormatter.yearAndMonthAndDay(this.date),
                        style: FontType.sBigTitle.merge(TextColorStyle.main)),
                    ...[
                      _physicalConditions(store, state),
                      _physicalConditionDetails(store, state),
                      _sex(store, state),
                      _memo(context, textEditingController, focusNode, store,
                          state),
                    ].map((e) => _withContentSpacer(e)),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom +
                          PostDiaryPageConst.keyboardToobarHeight +
                          60,
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

  Widget _physicalConditions(PostDiaryStore store, DiaryState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
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
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  color: state.hasPhysicalConditionStatusFor(
                          PhysicalConditionStatus.bad)
                      ? PilllColors.thinSecondary
                      : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/angry.svg",
                        color: state.hasPhysicalConditionStatusFor(
                                PhysicalConditionStatus.bad)
                            ? PilllColors.secondary
                            : TextColor.darkGray),
                    onPressed: () {
                      store.switchingPhysicalCondition(
                          PhysicalConditionStatus.bad);
                    }),
              ),
              Container(
                  height: 48,
                  child: const VerticalDivider(width: 1, color: PilllColors.divider)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  color: state.hasPhysicalConditionStatusFor(
                          PhysicalConditionStatus.fine)
                      ? PilllColors.thinSecondary
                      : Colors.transparent,
                ),
                child: IconButton(
                    icon: SvgPicture.asset("images/laugh.svg",
                        color: state.hasPhysicalConditionStatusFor(
                                PhysicalConditionStatus.fine)
                            ? PilllColors.secondary
                            : TextColor.darkGray),
                    onPressed: () {
                      store.switchingPhysicalCondition(
                          PhysicalConditionStatus.fine);
                    }),
              ),
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _physicalConditionDetails(PostDiaryStore store, DiaryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("体調詳細",
            style: FontType.componentTitle.merge(TextColorStyle.black)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: Diary.allPhysicalConditions
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: FontType.assisting.merge(
                        state.diary.physicalConditions.contains(e)
                            ? TextColorStyle.white
                            : TextColorStyle.darkGray),
                    disabledColor: PilllColors.disabledSheet,
                    selectedColor: PilllColors.secondary,
                    selected: state.diary.physicalConditions.contains(e),
                    onSelected: (selected) {
                      state.diary.physicalConditions.contains(e)
                          ? store.removePhysicalCondition(e)
                          : store.addPhysicalCondition(e);
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _sex(PostDiaryStore store, DiaryState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("sex", style: FontType.componentTitle.merge(TextColorStyle.black)),
        const SizedBox(width: 80),
        GestureDetector(
          onTap: () {
            store.toggleHasSex();
          },
          child: Container(
              padding: const EdgeInsets.all(4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.diary.hasSex
                      ? PilllColors.thinSecondary
                      : PilllColors.disabledSheet),
              child: SvgPicture.asset("images/heart.svg",
                  color: state.diary.hasSex
                      ? PilllColors.secondary
                      : TextColor.darkGray)),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _keyboardToolbar(BuildContext context, FocusNode focusNode) {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom,
      child: Container(
        height: PostDiaryPageConst.keyboardToobarHeight,
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
    PostDiaryStore store,
    DiaryState state,
  ) {
    final textLength = 120;
    return Container(
      child: ConstrainedBox(
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
      ),
    );
  }
}

extension PostDiaryPageRoute on PostDiaryPage {
  static Route<dynamic> route(DateTime date, Diary? diary) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "PostDiaryPage"),
      builder: (_) => PostDiaryPage(date, diary),
      fullscreenDialog: true,
    );
  }
}
