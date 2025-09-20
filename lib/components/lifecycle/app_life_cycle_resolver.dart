import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:pilll/utils/alarm_kit_service.dart';

// NOTE: [SyncData:Widget]
class AppLifeCycleResolver extends HookConsumerWidget {
  const AppLifeCycleResolver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnAppLifecycleStateChange((previous, current) {
      if (previous == AppLifecycleState.hidden || previous == AppLifecycleState.paused || previous == AppLifecycleState.detached) {
        if (current == AppLifecycleState.resumed || current == AppLifecycleState.inactive) {
          AlarmKitService.stopAllAlarms();
        }
      }
    });
    return const SizedBox();
  }
}
