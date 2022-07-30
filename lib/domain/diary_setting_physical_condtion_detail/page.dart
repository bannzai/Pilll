import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/state_notifier.dart';
import 'package:pilll/error/universal_error_page.dart';

class DiarySettingPhysicalConditionDetailPage extends HookConsumerWidget {
  const DiarySettingPhysicalConditionDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diarySettingPhysicalConditionDetailStateNotifierProvider);
    return state.when(
      data: (state) => ListView(
        children: [
          for (final p in state.diarySetting.physicalConditions) Text(p),
        ],
      ),
      error: (error, _) => UniversalErrorPage(error: error, child: null, reload: null),
      loading: () => const ScaffoldIndicator(),
    );
  }
}
