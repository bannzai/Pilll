import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/alarm_kit_service.dart';
import 'package:pilll/utils/analytics.dart';

class AlarmKitSetting extends HookConsumerWidget {
  final Setting setting;
  const AlarmKitSetting({
    super.key,
    required this.setting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlarmKitAvailable = useState<bool?>(null);
    final isLoading = useState(false);

    useEffect(() {
      // AlarmKitの利用可能性を確認
      AlarmKitService.isAvailable().then((available) {
        isAlarmKitAvailable.value = available;
      });
      return null;
    }, []);

    // AlarmKitが利用できない場合は何も表示しない
    if (isAlarmKitAvailable.value != true) {
      return const SizedBox.shrink();
    }

    return ListTile(
      minVerticalPadding: 9,
      title: Text(
        'アラーム機能',
        style: const TextStyle(
          fontFamily: FontFamily.roboto,
          fontWeight: FontWeight.w300,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        'サイレントモードやフォーカスモード時でも確実に通知されます（iOS 26以降）',
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
      trailing: isLoading.value
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(),
            )
          : Switch(
              value: setting.useAlarmKit,
              onChanged: (value) async {
                if (isLoading.value) return;

                analytics.logEvent(
                  name: 'did_toggle_alarm_kit_setting',
                  parameters: {'enabled': value},
                );

                isLoading.value = true;
                try {
                  if (value) {
                    // AlarmKit有効時は権限リクエスト
                    final hasPermission = await AlarmKitService.requestPermission();
                    if (hasPermission) {
                      await ref.read(settingNotifierProvider.notifier).updateSetting(
                            setting.copyWith(useAlarmKit: true),
                          );
                      // 設定変更時に通知を再登録
                      ref.read(registerReminderLocalNotificationProvider).call();
                    } else {
                      // 権限が拒否された場合はエラーメッセージ表示
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('アラーム機能の権限が必要です。設定から許可してください。'),
                          ),
                        );
                      }
                    }
                  } else {
                    // AlarmKit無効時
                    await ref.read(settingNotifierProvider.notifier).updateSetting(
                          setting.copyWith(useAlarmKit: false),
                        );
                    // 設定変更時に通知を再登録
                    ref.read(registerReminderLocalNotificationProvider).call();
                  }
                } catch (e) {
                  analytics.debug(name: 'alarm_kit_setting_error', parameters: {'error': e.toString()});
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('設定の変更に失敗しました。もう一度お試しください。'),
                      ),
                    );
                  }
                } finally {
                  isLoading.value = false;
                }
              },
            ),
    );
  }
}