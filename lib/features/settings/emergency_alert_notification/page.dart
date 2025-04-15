import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences用のキー
const String _keyEmergencyAlertEnabled = 'emergency_alert_enabled';
const String _keyEmergencyAlertVolume = 'emergency_alert_volume';

// 緊急アラート設定用のプロバイダー
final emergencyAlertEnabledProvider = StateProvider<bool>((ref) => false);
final emergencyAlertVolumeProvider = StateProvider<double>((ref) => 0.8);

// 設定読み込み用のプロバイダー
final loadEmergencyAlertSettingsProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final enabled = prefs.getBool(_keyEmergencyAlertEnabled) ?? false;
  final volume = prefs.getDouble(_keyEmergencyAlertVolume) ?? 0.8;

  ref.read(emergencyAlertEnabledProvider.notifier).state = enabled;
  ref.read(emergencyAlertVolumeProvider.notifier).state = volume;
});

class EmergencyAlertNotificationPage extends HookConsumerWidget {
  const EmergencyAlertNotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 設定を読み込む
    ref.watch(loadEmergencyAlertSettingsProvider);

    final isEmergencyAlertEnabled = ref.watch(emergencyAlertEnabledProvider);
    final emergencyAlertVolume = ref.watch(emergencyAlertVolumeProvider);

    // ローカルの状態
    final volumeState = useState(emergencyAlertVolume);

    // クリティカルアラートの権限を要求する関数
    Future<void> requestCriticalAlertPermissions() async {
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          criticalAlert: true,
        );
      }
    }

    // 設定が変更されたら保存する
    Future<void> saveEmergencyAlertEnabled(bool value) async {
      try {
        analytics.logEvent(name: 'change_emergency_alert_enabled');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_keyEmergencyAlertEnabled, value);
        ref.read(emergencyAlertEnabledProvider.notifier).state = value;

        // 有効にする場合はクリティカルアラートの権限を要求
        if (value) {
          await requestCriticalAlertPermissions();
        }

        // メッセージ表示
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                '緊急アラートを${value ? 'ON' : 'OFF'}にしました',
              ),
            ),
          );
        }
      } catch (error) {
        if (context.mounted) showErrorAlert(context, error);
      }
    }

    Future<void> saveEmergencyAlertVolume(double value) async {
      try {
        analytics.logEvent(name: 'change_emergency_alert_volume');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble(_keyEmergencyAlertVolume, value);
        ref.read(emergencyAlertVolumeProvider.notifier).state = value;
      } catch (error) {
        if (context.mounted) showErrorAlert(context, error);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '緊急アラート',
          style: TextStyle(
            color: TextColor.black,
          ),
        ),
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '緊急アラート設定',
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: TextColor.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSwitchRow(
                    'クリティカルアラートを有効にする',
                    isEmergencyAlertEnabled,
                    (value) async {
                      await saveEmergencyAlertEnabled(value);
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    '緊急アラート音量',
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: TextColor.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.volume_down, color: TextColor.darkGray),
                      Expanded(
                        child: Slider(
                          value: volumeState.value,
                          onChanged: isEmergencyAlertEnabled
                              ? (value) {
                                  volumeState.value = value;
                                }
                              : null,
                          onChangeEnd: (value) async {
                            await saveEmergencyAlertVolume(value);
                          },
                          min: 0.0,
                          max: 1.0,
                          activeColor: AppColors.secondary,
                          inactiveColor: isEmergencyAlertEnabled ? AppColors.lightGray : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      const Icon(Icons.volume_up, color: TextColor.darkGray),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '緊急アラートは通常の服薬リマインダーよりも目立つ通知を送信します。サイレントモードやマナーモードでも通知されるため、ピルの服用を見逃すことが少なくなります。',
                    style: TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: TextColor.darkGray,
                    ),
                  ),
                  if (Platform.isIOS) ...[
                    const SizedBox(height: 10),
                    const Text(
                      '※ iOSでは緊急アラートを使用するために通知の権限設定が必要です。設定を有効にすると権限確認が表示されます。',
                      style: TextStyle(
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                        color: TextColor.darkGray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool initialValue, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Switch(
            value: initialValue,
            onChanged: onChanged,
            activeColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

extension EmergencyAlertNotificationPageRoutes on EmergencyAlertNotificationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: 'EmergencyAlertNotificationPage'),
      builder: (_) => const EmergencyAlertNotificationPage(),
    );
  }
}
