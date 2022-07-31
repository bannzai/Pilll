import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/mutation.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/state_notifier.dart';
import 'package:pilll/error/error_alert.dart';
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
      data: (state) {
        final diarySetting = state.diarySetting;
        if (diarySetting == null) {
          return const ScaffoldIndicator();
        }
        return Scaffold(
          body: ListView(
            children: [
              for (final p in diarySetting.physicalConditions) Text(p),
              TextField(
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PilllColors.primary),
                  ),
                ),
                autofocus: true,
                onSubmitted: (physicalConditionDetail) async {
                  analytics.logEvent(name: "submit_physical_condition_detail", parameters: {"element": physicalConditionDetail});
                  try {
                    addDiarySetting(diarySetting: diarySetting, physicalConditionDetail: physicalConditionDetail);
                    Navigator.of(context).pop();
                  } catch (error) {
                    showErrorAlert(context, error);
                  }
                },
                maxLength: 8,
              ),
            ],
          ),
        );
      },
      error: (error, _) => UniversalErrorPage(error: error, child: null, reload: null),
      loading: () => const ScaffoldIndicator(),
    );
  }
}
