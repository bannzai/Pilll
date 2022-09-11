import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/schedule_post/state.codegen.dart';
import 'package:pilll/domain/schedule_post/state_notifier.dart';
import 'package:pilll/error/universal_error_page.dart';

class SchedulePostPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(schedulePostStateNotifierProvider);

    return asyncState.when(
      data: (state) => _SchedulePostPage(state: state),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(schedulePostAsyncStateProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class _SchedulePostPage extends HookConsumerWidget {
  final SchedulePostState state;

  const _SchedulePostPage({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateNotifier = ref.watch(schedulePostStateNotifierProvider.notifier);
    final TextEditingController? textEditingController = useTextEditingController(text: state.diary.memo);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // NOTE: The final keyboard height cannot be got at the moment of focus via MediaQuery.of(context).viewInsets.bottom. so it is delayed.
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          final overwrapHeight = focusNode.rect.bottom - (MediaQuery.of(context).viewInsets.bottom + DiaryPostPageConst.keyboardToobarHeight);
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
                      height: MediaQuery.of(context).viewInsets.bottom + DiaryPostPageConst.keyboardToobarHeight + 60,
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
}
