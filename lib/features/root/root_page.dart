import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class RootPage extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;
  const RootPage({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return builder(context);
  }
}
