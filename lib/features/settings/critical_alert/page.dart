import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
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
                    final grand = await localNotificationService.requestPermissionWithCriticalAlert();
                    if (grand == true) {
                      useCriticalAlert.value = value;
                    } else {
                      useCriticalAlert.value = false;
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
                      value: ciritcalAlertVolume.value,
                      label: ciritcalAlertVolume.value.toString(),
                      onChanged: (value) {
                        ciritcalAlertVolume.value = value;
                      },
                    ),
                  ],
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

class MedicineFormSectionLayout extends StatelessWidget {
  final IconData icon;
  final String text;
  final List<Widget> children;

  const MedicineFormSectionLayout({
    super.key,
    required this.icon,
    required this.text,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: foregroundColor,
                ),
                const SizedBox(width: 8.0),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}
