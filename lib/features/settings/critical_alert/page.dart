import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/local_notification.dart';

class CriticalAlertPage extends HookConsumerWidget {
  final Setting setting;
  const CriticalAlertPage({super.key, required this.setting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCriticalAlert = useState(setting.useCriticalAlert);
    final criticalAlertVolume = useState(setting.criticalAlertVolume);
    final setSetting = ref.watch(setSettingProvider);
    final registerReminderLocalNotification = ref.watch(
      registerReminderLocalNotificationProvider,
    );

    void updateSetting() async {
      await setSetting(
        setting.copyWith(
          useCriticalAlert: useCriticalAlert.value,
          criticalAlertVolume: criticalAlertVolume.value,
        ),
      );
      await registerReminderLocalNotification();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(L.enableNotificationInSilentModeSetting),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                SwitchListTile(
                  value: useCriticalAlert.value,
                  onChanged: (value) async {
                    final granted = await localNotificationService.requestPermissionWithCriticalAlert();
                    if (granted == true) {
                      useCriticalAlert.value = value;
                      updateSetting();
                    } else {
                      useCriticalAlert.value = false;
                      updateSetting();
                    }
                  },
                  title: Text(
                    L.enableNotificationInSilentMode,
                    style: const TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    L.silentModeNotificationDescription,
                    style: const TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          L.criticalAlertVolume,
                          style: const TextStyle(
                            color: TextColor.main,
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Slider(
                      value: criticalAlertVolume.value,
                      min: 0,
                      max: 1,
                      activeColor: AppColors.primary,
                      label: criticalAlertVolume.value.toString(),
                      onChanged: (value) {
                        criticalAlertVolume.value = value;
                      },
                      onChangeEnd: (value) {
                        criticalAlertVolume.value = value;
                        updateSetting();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    localNotificationService.testCriticalAlert(
                      volume: criticalAlertVolume.value,
                    );
                  },
                  child: const Text(
                    'テスト通知を送信',
                    style: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.bold,
                      color: TextColor.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension CriticalAlertPageRoutes on CriticalAlertPage {
  static Route<dynamic> route({required Setting setting}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'CriticalAlertPage'),
      builder: (_) => CriticalAlertPage(setting: setting),
    );
  }
}
