import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/setting.dart';

// NOTE: [Migrate:PillSheetAppearanceMode] setting -> latestPillSheetGroup の移行処理
class PillSheetAppearanceModeMigrationResolver extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;

  const PillSheetAppearanceModeMigrationResolver({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(settingProvider);
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupProvider);
    final setPillSheetGroup = ref.watch(setPillSheetGroupProvider);
    final resolved = useState(false);

    useEffect(() {
      final f = (() async {
        final settingData = setting.asData?.value;
        final latestPillSheetGroupData = latestPillSheetGroup.asData?.value;
        if (settingData == null || latestPillSheetGroupData == null) {
          return;
        }

        try {
          // NOTE: [Migrate:PillSheetAppearanceMode] SelectAppearanceModeModalでもsettingと同期をとっている。なので、移行が完了した後も実行し続けてもずれることはない
          await setPillSheetGroup(
            latestPillSheetGroupData.copyWith(
              pillSheetAppearanceMode: settingData.pillSheetAppearanceMode,
            ),
          );
          if (!resolved.value) {
            resolved.value = true;
          }
        } catch (error) {
          debugPrint(error.toString());
        }
      });
      f();
      return null;
    }, [latestPillSheetGroup.asData?.value != null, setting.asData?.value != null]);

    if (resolved.value) {
      return builder(context);
    } else {
      return const ScaffoldIndicator();
    }
  }
}
