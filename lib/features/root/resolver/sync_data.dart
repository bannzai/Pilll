import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';

// NOTE: [SyncData:Widget]
class SyncDataResolver extends HookConsumerWidget {
  const SyncDataResolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupProvider);
    useAutomaticKeepAlive(wantKeepAlive: true);

    useEffect(() {
      final f = (() async {
        if (user.isLoading) {
          return;
        }
        try {
          syncUserStatus(user: user.asData?.value);
        } catch (error) {
          debugPrint(error.toString());
        }
      });

      f();
      return null;
    }, [user.asData?.value]);

    useEffect(() {
      final f = (() async {
        if (latestPillSheetGroup.isLoading) {
          return;
        }
        try {
          syncActivePillSheetValue(
            pillSheetGroup: latestPillSheetGroup.asData?.value,
          );
        } catch (error) {
          debugPrint(error.toString());
        }
      });

      f();
      return null;
    }, [latestPillSheetGroup.asData?.value]);

    return const SizedBox();
  }
}
