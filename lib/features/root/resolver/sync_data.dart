import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';

// NOTE: [SyncData:Widget]
class SyncDataResolver extends HookConsumerWidget {
  const SyncDataResolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final customerInfo = ref.watch(customerInfoProvider);
    final latestPillSheetGroup = ref.watch(latestPillSheetGroupProvider);
    useAutomaticKeepAlive(wantKeepAlive: true);

    final userValue = user.asData?.value;
    // 取得し直しに失敗した時 (前の値を持つ AsyncError) は前の値を使う。前の値も無い時は同期せず、Widget に同期済みの値を残す
    final customerInfoValue = customerInfo.valueOrNull;
    useEffect(() {
      final f = (() async {
        if (user.isLoading || customerInfo.isLoading || customerInfoValue == null) {
          return;
        }
        try {
          syncUserStatus(
            premiumOrTrial: userValue == null ? null : customerInfoValue.premiumOrTrial(user: userValue),
          );
        } catch (error) {
          debugPrint(error.toString());
        }
      });

      f();
      return null;
    }, [userValue, customerInfoValue]);

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
