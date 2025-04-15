import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/local_notification.dart';

class CriticalAlertPage extends HookConsumerWidget {
  final Setting setting;
  const CriticalAlertPage({super.key, required this.setting});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final useCriticalAlert = useState(setting.useCriticalAlert);
    final ciritcalAlertVolume = useState(setting.criticalAlertVolume);

    return Scaffold(
      body: Column(
        children: [
          SwitchListTile(
            value: useCriticalAlert.value,
            onChanged: (value) async {
              final grand = await localNotificationService.requestPermissionWithCriticalAlert();
              if (grand == true) {
                useCriticalAlert.value = value;
              } else {
                useCriticalAlert.value = false;
              }
            },
            title: Text(L.enableNotificationInSilentMode),
            subtitle: Text(L.silentModeNotificationDescription),
          ),
          Slider(
            value: ciritcalAlertVolume.value,
            label: ciritcalAlertVolume.value.toString(),
            onChanged: (value) {
              ciritcalAlertVolume.value = value;
            },
          ),
        ],
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
