import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/mutation.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/state_notifier.dart';
import 'package:pilll/error/universal_error_page.dart';

class DiarySettingPhysicalConditionDetailPage extends HookConsumerWidget {
  const DiarySettingPhysicalConditionDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createDiarySetting = ref.watch(createDiarySettingPhysicalConditionDetailProvider);
    final addDiarySetting = ref.watch(addDiarySettingPhysicalConditionDetailProvider);
    final state = ref.watch(diarySettingPhysicalConditionDetailStateNotifierProvider);

    useEffect(() {
      final diarySetting = state.asData?.value.diarySetting;
      if (diarySetting == null) {
        Future(() async {
          await createDiarySetting();
        });
      }

      return null;
    }, [state.asData?.value.diarySetting?.physicalConditions]);

    return state.when(
      data: (state) => ListView(
        children: [
          for (final p in state.diarySetting?.physicalConditions ?? []) Text(p),
        ],
      ),
      error: (error, _) => UniversalErrorPage(error: error, child: null, reload: null),
      loading: () => const ScaffoldIndicator(),
    );
  }
}
