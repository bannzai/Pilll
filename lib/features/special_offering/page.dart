import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _specialOfferingClosedKey = 'special_offering_paywall_closed_at';

Future<bool> shouldShowSpecialOffering() async {
  final prefs = await SharedPreferences.getInstance();
  return !prefs.containsKey(_specialOfferingClosedKey);
}

Future<void> setSpecialOfferingClosed() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_specialOfferingClosedKey, DateTime.now().millisecondsSinceEpoch);
}

void showSpecialOfferingModal(BuildContext context) async {
  if (await shouldShowSpecialOffering()) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SpecialOfferingModal(),
    );
  }
}

class SpecialOfferingModal extends HookWidget {
  const SpecialOfferingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isClosing = useState(false);

    return AlertDialog(
      title: const Text('今回限りの特別オファー'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('今だけ特別価格でプレミアム機能をゲット！'),
          // ここにプランや価格、特徴などを追加
        ],
      ),
      actions: [
        TextButton(
          onPressed: isClosing.value
              ? null
              : () async {
                  isClosing.value = true;
                  await setSpecialOfferingClosed();
                  Navigator.of(context).pop();
                },
          child: const Text('閉じる（この画面は再表示されません）'),
        ),
        // 購入ボタンなどもここに追加可能
      ],
    );
  }
}
