import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:flutter/material.dart';

class UserSignIn extends HookConsumerWidget {
  final Widget Function(BuildContext, String) builder;
  const UserSignIn({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(firebaseSignInProvider).when(
          data: (user) => builder(context, user.uid),
          error: (e, st) => UniversalErrorPage(
            error: e,
            reload: () {
              ref.invalidate(firebaseSignInProvider);
            },
            child: null,
          ),
          loading: () => const ScaffoldIndicator(),
        );
  }
}
