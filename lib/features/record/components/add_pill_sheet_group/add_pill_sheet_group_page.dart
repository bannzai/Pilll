import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/template/setting_pill_sheet_group/setting_pill_sheet_group.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/display_number_setting.dart';
import 'package:pilll/features/record/components/add_pill_sheet_group/provider.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

class AddPillSheetGroupPage extends HookConsumerWidget {
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;
  const AddPillSheetGroupPage({Key? key, required this.pillSheetGroup, required this.setting}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pillSheetGroup = this.pillSheetGroup;
    final addPillSheetGroup = ref.watch(addPillSheetGroupProvider);
    final pillSheetTypes = useState(setting.pillSheetEnumTypes);
    final displayNumberSetting = useState<PillSheetGroupDisplayNumberSetting?>(null);

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "ピルシート追加",
          style: TextStyle(color: TextColor.black),
        ),
        backgroundColor: PilllColors.white,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            children: [
              SettingPillSheetGroup(
                pillSheetTypes: pillSheetTypes.value,
                onAdd: (pillSheetType) {
                  analytics.logEvent(name: "setting_add_pill_sheet_group", parameters: {"pill_sheet_type": pillSheetType.fullName});
                  pillSheetTypes.value = [...pillSheetTypes.value, pillSheetType];
                },
                onChange: (index, pillSheetType) {
                  analytics
                      .logEvent(name: "setting_change_pill_sheet_group", parameters: {"index": index, "pill_sheet_type": pillSheetType.fullName});
                  final copied = [...pillSheetTypes.value];
                  copied[index] = pillSheetType;
                  pillSheetTypes.value = copied;
                },
                onDelete: (index) {
                  analytics.logEvent(name: "setting_delete_pill_sheet_group", parameters: {"index": index});
                  pillSheetTypes.value = [...pillSheetTypes.value]..removeAt(index);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Container(
                    color: PilllColors.background,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (pillSheetGroup != null)
                          DisplayNumberSetting(
                              pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
                              pillSheetGroup: pillSheetGroup,
                              onChanged: (value) {
                                displayNumberSetting.value = value;
                              }),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 180,
                          child: PrimaryButton(
                            text: "追加",
                            onPressed: () async {
                              analytics.logEvent(name: "pressed_add_pill_sheet_group");
                              final navigator = Navigator.of(context);
                              await addPillSheetGroup.call(
                                setting: setting,
                                pillSheetGroup: pillSheetGroup,
                                pillSheetTypes: pillSheetTypes.value,
                                displayNumberSetting: displayNumberSetting.value,
                              );
                              navigator.pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}

extension AddPillSheetGroupPageRoute on AddPillSheetGroupPage {
  static Route<dynamic> route({required PillSheetGroup? pillSheetGroup, required Setting setting}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      settings: const RouteSettings(name: "RecordPageAddingPillSheetGroupPage"),
      builder: (_) => AddPillSheetGroupPage(pillSheetGroup: pillSheetGroup, setting: setting),
    );
  }
}
