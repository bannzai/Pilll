import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

final migration20240819Provider = Provider.autoDispose((ref) => ref.watch(boolSharedPreferencesProvider(BoolKey.migration20240819)));
final migration20240819NotifierProvider = Provider.autoDispose((ref) => ref.watch(boolSharedPreferencesProvider(BoolKey.migration20240819).notifier));

class Migration20240819 extends HookConsumerWidget {
  const Migration20240819({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupProvider).asData?.value;
    final setting = ref.watch(settingProvider).asData?.value;
    final database = ref.watch(databaseProvider);
    final migration20240819 = ref.watch(migration20240819Provider);
    final migration20240819Notifier = ref.watch(migration20240819NotifierProvider);

    useEffect(() {
      Future<void> f() async {
        if (migration20240819.value == true) {
          return;
        }
        if (latestPillSheetGroup == null || setting == null) {
          return;
        }
        if (latestPillSheetGroup.activePillSheet == null) {
          return;
        }
        await database
            .pillSheetGroupReference(
              latestPillSheetGroup.id,
            )
            .set(
              latestPillSheetGroup.copyWith(
                pillSheetAppearanceMode: setting.pillSheetAppearanceMode,
              ),
              SetOptions(merge: true),
            );
        migration20240819Notifier.set(true);
      }

      f();
      return null;
    }, []);

    return const SizedBox();
  }
}
