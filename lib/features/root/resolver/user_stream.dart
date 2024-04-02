import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/user.dart';

class UserStreamResolver extends HookConsumerWidget {
  final Function(User) stream;

  const UserStreamResolver({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).asData?.value;
    if (user != null) {
      Future.microtask(() => stream(user));
    }
    return const SizedBox();
  }
}
