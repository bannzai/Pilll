import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodayPillNumber extends HookConsumerWidget {
  const TodayPillNumber({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ListTile(
      leading: Icon(Icons.numbers),
      title: Text("今日飲むピル番号の変更"),
    );
  }
}
