import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/root/launch_exception.dart';
import 'package:pilll/provider/force_update.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/template.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/utils/platform/platform.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RootPage extends HookConsumerWidget {
  // NOTE: テスト時にRootPageより下のWidgetのProviderを用意するのは現実的では無いので、builderからメインストリームのWidgetを決定する。
  final Widget Function(BuildContext, String) builder;
  const RootPage({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkForceUpdate = ref.watch(checkForceUpdateProvider);
    final shouldForceUpdate = useState(false);

    // Setup for application
    useEffect(() {
      if (!Environment.isTest) {
        // Set global error page
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return UniversalErrorPage(
            error: details.exception.toString(),
            child: null,
            reload: () => ref.refresh(refreshAppProvider),
          );
        };
      }

      void f() async {
        try {
          // 計測してみたらこの処理が結構長かった。通常の起動時間に影響があるので、この処理を非同期にする。
          // 多少データが変更される可能性があるが、それは許容する。ほとんど問題はないはず
          if (await checkForceUpdate()) {
            shouldForceUpdate.value = true;
          }
        } catch (e, st) {
          errorLogger.recordError(e, st);
        }
      }

      f();
      return null;
    }, []);

    // For force update
    if (shouldForceUpdate.value) {
      Future.microtask(() async {
        await showOKDialog(context, title: "アプリをアップデートしてください", message: "お使いのアプリのバージョンのアップデートをお願いしております。$storeNameから最新バージョンにアップデートしてください",
            ok: () async {
          await launchUrl(
            Uri.parse(forceUpdateStoreURL),
            mode: LaunchMode.externalApplication,
          );
        });
      });
      return const ScaffoldIndicator();
    }

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
