import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/molecules/keyboard_toolbar.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/diary_post/memo.dart';
import 'package:pilll/features/diary_post/physical_condition.dart';
import 'package:pilll/features/diary_post/physical_condition_details.dart';
import 'package:pilll/features/diary_post/sex.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/provider/diary_setting.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiaryPostPage extends HookConsumerWidget {
  final DateTime date;
  final Diary? diary;

  const DiaryPostPage(this.date, this.diary, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diary = this.diary ?? Diary.fromDate(date);

    return AsyncValueGroup.group2(ref.watch(userProvider), ref.watch(diarySettingProvider)).when(
      data: (data) => DiaryPostPageBody(
        date: date,
        diary: diary,
        user: data.$1,
        diarySetting: data.$2,
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
  final User user;
  final DiarySetting? diarySetting;

  const DiaryPostPageBody({
    Key? key,
    required this.date,
    required this.diary,
    required this.user,
    required this.diarySetting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoTextEditingController = useTextEditingController(text: diary.memo);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    final physicalCondition = useState<PhysicalConditionStatus?>(diary.physicalConditionStatus);
    final physicalConditionDetails = useState(diary.physicalConditions);
    final sex = useState(diary.hasSex);

    final setDiary = ref.watch(setDiaryProvider);

    // FIXME: なぜかFocusScope.of(context).hasFocusになりKeyboardToolbarが表示されてしまうのでunfocusする
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        FocusScope.of(context).unfocus();
      });
      return null;
    }, []);

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

                final navigator = Navigator.of(context);
                await setDiary(diary.copyWith(
                  physicalConditionStatus: physicalCondition.value,
                  physicalConditions: physicalConditionDetails.value,
                  hasSex: sex.value,
                  memo: memoTextEditingController.text,
                ));

                navigator.pop();
              }),
        ],
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                controller: scrollController,
                children: [
                  Text(DateTimeFormatter.yearAndMonthAndDay(date),
                      style: const TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: TextColor.main,
                      )),
                  const SizedBox(height: 20),
                  DiaryPostPhysicalCondition(physicalCondition: physicalCondition),
                  const SizedBox(height: 20),
                  DiaryPostPhysicalConditionDetails(
                      user: user, diarySetting: diarySetting, context: context, physicalConditionDetails: physicalConditionDetails),
                  const SizedBox(height: 20),
                  DiaryPostSex(sex: sex),
                  const SizedBox(height: 20),
                  DiaryPostMemo(textEditingController: memoTextEditingController, focusNode: focusNode),
                ],
              ),
            ),
            if (focusNode.hasPrimaryFocus) ...[
              KeyboardToolbar(
                doneButton: AlertButton(
                  text: '完了',
                  onPressed: () async {
                    analytics.logEvent(name: "post_diary_done_button_pressed");
                    focusNode.unfocus();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
