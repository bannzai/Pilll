import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/user.dart';

/// 開発者オプション内の行。タップするとトライアルを強制終了し、無料ユーザー（非トライアル）状態での動作確認を可能にする
class EndTrialForDebugRow extends ConsumerWidget {
  const EndTrialForDebugRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('トライアル解除'),
      subtitle: const Text('trialDeadlineDateを過去日に変更し、無料ユーザー状態にする'),
      trailing: const Icon(Icons.timer_off),
      onTap: () async {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        await ref.read(endTrialForDebugProvider).call();
        scaffoldMessenger.showSnackBar(const SnackBar(content: Text('トライアルを解除しました')));
      },
    );
  }
}
