import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/schedule_post/state.codegen.dart';
import 'package:pilll/domain/schedule_post/state_notifier.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/const.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class SchedulePostPage extends HookConsumerWidget {
  final DateTime date;

  const SchedulePostPage({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(schedulePostStateNotifierProvider(date));

    return asyncState.when(
      data: (state) => _SchedulePostPage(state: state),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(schedulePostAsyncStateProvider(date)),
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
    final schedule = state.scheduleOrNull(index: 0) ?? Schedule(title: "", date: state.date, createdDateTime: DateTime.now());
    final title = useState(schedule.title);
    final textEditingController = useTextEditingController(text: title.value);
    final focusNode = useFocusNode();
    final scrollController = useScrollController();
    final stateNotifier = ref.watch(schedulePostStateNotifierProvider(state.date).notifier);

    return Scaffold(
      backgroundColor: PilllColors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(DateTimeFormatter.yearAndMonthAndDay(state.date), style: FontType.sBigTitle.merge(TextColorStyle.main)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          AlertButton(
            text: "保存",
            onPressed: () async {
              await stateNotifier.post(schedule: schedule);
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Text(DateTimeFormatter.yearAndMonthAndDay(state.date), style: FontType.sBigTitle.merge(TextColorStyle.main)),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 40,
                        maxHeight: 200,
                      ),
                      child: TextFormField(
                        onChanged: (text) {
                          title.value = text;
                        },
                        decoration: const InputDecoration(
                          hintText: "通院する",
                          border: OutlineInputBorder(),
                        ),
                        controller: textEditingController,
                        maxLines: null,
                        maxLength: 60,
                        keyboardType: TextInputType.multiline,
                        focusNode: focusNode,
                      ),
                    ),
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
                analytics.logEvent(name: "post_schedule_done_button_pressed");
                focusNode.unfocus();
              },
            ),
          ],
        ),
        decoration: const BoxDecoration(color: PilllColors.white),
      ),
    );
  }
}

extension SchedulePostPageRoute on SchedulePostPage {
  static Route<dynamic> route(DateTime date) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SchedulePostPage"),
      builder: (_) => SchedulePostPage(date: date),
      fullscreenDialog: true,
    );
  }
}
