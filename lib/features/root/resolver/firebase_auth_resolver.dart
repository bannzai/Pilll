import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/page.dart';
import 'package:pilll/provider/auth.dart';

class FirebaseAuthResolver extends HookConsumerWidget {
  final Widget Function(BuildContext, User) builder;
  const FirebaseAuthResolver({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(firebaseUserStateProvider)
        .when(
          data: (user) {
            if (user != null) {
              return builder(context, user);
            }

            return _FirebaseAuthSignInResolver(builder: builder);
          },
          error: (e, st) => UniversalErrorPage(
            error: e,
            reload: () {
              ref.invalidate(firebaseSignInOrCurrentUserProvider);
            },
            child: null,
          ),
          loading: () => const ScaffoldIndicator(),
        );
  }
}

class _FirebaseAuthSignInResolver extends HookConsumerWidget {
  final Widget Function(BuildContext, User) builder;
  const _FirebaseAuthSignInResolver({required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(firebaseSignInOrCurrentUserProvider)
        .when(
          data: (user) => builder(context, user),
          error: (e, st) => UniversalErrorPage(
            error: e,
            reload: () {
              ref.invalidate(firebaseSignInOrCurrentUserProvider);
            },
            child: null,
          ),
          loading: () => const ScaffoldIndicator(),
        );
  }
}
