import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/alarm_kit_service.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

class AlarmKitSetting extends HookConsumerWidget {
  final Setting setting;
  final bool isPremium;
  final bool isTrial;
  const AlarmKitSetting({super.key, required this.setting, required this.isPremium, required this.isTrial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlarmKitAvailableFuture = useFuture(AlarmKitService.isAvailable());
    final isAlarmKitAvailable = isAlarmKitAvailableFuture.data;
    final isLoading = useState(false);

    // AlarmKitが利用できない場合は何も表示しない
    if (isAlarmKitAvailable != true) {
      return const SizedBox.shrink();
    }

    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          const Text(
            'アラーム機能',
            style: TextStyle(fontFamily: FontFamily.roboto, fontWeight: FontWeight.w300, fontSize: 16),
          ),
          if (!isPremium) ...[const SizedBox(width: 8), const PremiumBadge()],
        ],
      ),
      subtitle: const Text(
        '目覚まし同様の通知が鳴ります。サイレントモードや集中モード時でも確実に通知されます',
        style: TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w300, fontSize: 14),
      ),
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
      trailing: Stack(
        alignment: Alignment.center,
        children: [
          Switch(
            value: setting.useAlarmKit,
            onChanged: (value) async {
              if (isLoading.value) {
                return;
              }
              if (!isPremium && !isTrial) {
                return;
              }

              analytics.logEvent(name: 'did_toggle_alarm_kit_setting', parameters: {'enabled': value});

              isLoading.value = true;
              try {
                if (value) {
                  // AlarmKit有効時は権限リクエスト
                  final hasPermission = await AlarmKitService.requestPermission();
                  if (hasPermission) {
                    final setSetting = ref.read(setSettingProvider);
                    await setSetting(setting.copyWith(useAlarmKit: true));
                    // 設定変更時に通知を再登録
                    final registerReminderLocalNotification = ref.read(registerReminderLocalNotificationProvider);
                    await registerReminderLocalNotification();
                  } else {
                    // 権限が拒否された場合はエラーメッセージ表示
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('アラーム機能の権限が必要です。設定から許可してください。')));
                    }
                  }
                } else {
                  // AlarmKit無効時
                  final setSetting = ref.read(setSettingProvider);
                  await setSetting(setting.copyWith(useAlarmKit: false));
                  // 設定変更時に通知を再登録
                  final registerReminderLocalNotification = ref.read(registerReminderLocalNotificationProvider);
                  await registerReminderLocalNotification();
                }
              } catch (e) {
                analytics.debug(name: 'alarm_kit_setting_error', parameters: {'error': e.toString()});
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('設定の変更に失敗しました。もう一度お試しください。')));
                }
              } finally {
                isLoading.value = false;
              }
            },
          ),
          if (isLoading.value) const SizedBox(width: 40, height: 40, child: Indicator()),
        ],
      ),
    );
  }
}
