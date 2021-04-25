import 'package:pilll/domain/diary/post_diary_store_provider_family.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/state/diary.dart';
import 'package:pilll/store/post_diary.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final _postDiaryStoreProvider = StateNotifierProvider.autoDispose
    .family<PostDiaryStore, PostDiaryStoreProviderFamily>((ref, family) {
  final service = ref.watch(diaryServiceProvider);
  final diary = family.diary;
  if (diary == null) {
    return PostDiaryStore(
        service, DiaryState(entity: Diary.fromDate(family.date)));
  }
  return PostDiaryStore(service, DiaryState(entity: diary.copyWith()));
});

abstract class PostDiaryPageConst {
  static double keyboardToobarHeight = 44;
}

class PostDiaryPage extends HookWidget {
  final DateTime date;
  final Diary? diary;

  PostDiaryPage(this.date, this.diary);

  PostDiaryStoreProviderFamily _family() {
    return PostDiaryStoreProviderFamily(date: date, diary: diary);
  }

  @override
  Widget build(BuildContext context) {
    final store = useProvider(_postDiaryStoreProvider(_family()));
    final state = useProvider(_postDiaryStoreProvider(_family()).state);
    final TextEditingController? textEditingController =
        useTextEditingController(text: state.entity.memo);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // NOTE: The final keyboard height cannot be got at the moment of focus via MediaQuery.of(context).viewInsets.bottom. so it is delayed.
        Future.delayed(Duration(milliseconds: 100)).then((_) {
          final overwrapHeight = focusNode.rect.bottom -
              (MediaQuery.of(context).viewInsets.bottom +
                  PostDiaryPageConst.keyboardToobarHeight);
          if (overwrapHeight > 0) {
            scrollController.animateTo(overwrapHeight,
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          }
        });
      } else {
        scrollController.animateTo(scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
    return Scaffold(
      backgroundColor: PilllColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          SecondaryButton(
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
      padding: EdgeInsets.only(top: 10, bottom: 10),
    );
  }

  Widget _physicalConditions(PostDiaryStore store, DiaryState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("体調", style: FontType.componentTitle.merge(TextColorStyle.black)),
        Spacer(),
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
                  borderRadius: BorderRadius.only(
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
                  child: VerticalDivider(width: 1, color: PilllColors.divider)),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
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
        Spacer(),
      ],
    );
  }

  Widget _physicalConditionDetails(PostDiaryStore store, DiaryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("体調詳細",
            style: FontType.componentTitle.merge(TextColorStyle.black)),
        SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: Diary.allPhysicalConditions
              .map((e) => ChoiceChip(
                    label: Text(e),
                    labelStyle: FontType.assisting.merge(
                        state.entity.physicalConditions.contains(e)
                            ? TextColorStyle.white
                            : TextColorStyle.darkGray),
                    disabledColor: PilllColors.disabledSheet,
                    selectedColor: PilllColors.secondary,
                    selected: state.entity.physicalConditions.contains(e),
                    onSelected: (selected) {
                      state.entity.physicalConditions.contains(e)
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
        SizedBox(width: 80),
        GestureDetector(
          onTap: () {
            store.toggleHasSex();
          },
          child: Container(
              padding: EdgeInsets.all(4),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state.entity.hasSex
                      ? PilllColors.thinSecondary
                      : PilllColors.disabledSheet),
              child: SvgPicture.asset("images/heart.svg",
                  color: state.entity.hasSex
                      ? PilllColors.secondary
                      : TextColor.darkGray)),
        ),
        Spacer(),
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
            Spacer(),
            SecondaryButton(
              text: '完了',
              onPressed: () {
                focusNode.unfocus();
              },
            ),
          ],
        ),
        decoration: BoxDecoration(color: PilllColors.white),
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
          decoration: InputDecoration(
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
      settings: RouteSettings(name: "PostDiaryPage"),
      builder: (_) => PostDiaryPage(date, diary),
      fullscreenDialog: true,
    );
  }
}
