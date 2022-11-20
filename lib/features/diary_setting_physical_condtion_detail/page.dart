import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/diary_setting_physical_condtion_detail/mutation.dart';
import 'package:pilll/features/diary_setting_physical_condtion_detail/state.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/error/universal_error_page.dart';

class DiarySettingPhysicalConditionDetailPage extends HookConsumerWidget {
  const DiarySettingPhysicalConditionDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createDiarySetting = ref.watch(createDiarySettingPhysicalConditionDetailProvider);
    final addDiarySetting = ref.watch(addDiarySettingPhysicalConditionDetailProvider);
    final deleteDiarySetting = ref.watch(deleteDiarySettingPhysicalConditionDetailProvider);
    final state = ref.watch(diarySettingPhysicalConditionDetailAsyncStateProvider);
    final textFieldController = useTextEditingController();
    final scrollController = useScrollController();

    scrollController.addListener(() {
      primaryFocus?.unfocus();
    });

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
          appBar: AppBar(
            title: const Text("体調詳細",
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: FontFamily.japanese,
                  color: TextColor.main,
                  fontWeight: FontWeight.w600,
                )),
            shadowColor: Colors.transparent,
          ),
          body: ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: textFieldController,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: PilllColors.secondary),
                    ),
                    hintText: "入力して追加",
                  ),
                  onSubmitted: (physicalConditionDetail) async {
                    analytics.logEvent(name: "submit_physical_condition_detail", parameters: {"element": physicalConditionDetail});
                    try {
                      await addDiarySetting(diarySetting: diarySetting, physicalConditionDetail: physicalConditionDetail);
                      textFieldController.text = "";
                    } catch (error) {
                      showErrorAlert(context, error);
                    }
                  },
                  maxLength: 8,
                ),
              ),
              for (final p in diarySetting.physicalConditions)
                Column(
                  children: [
                    ListTile(
                      title: Text(p),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await deleteDiarySetting(diarySetting: diarySetting, physicalConditionDetail: p);
                        },
                      ),
                    ),
                    const Divider(),
                  ],
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
