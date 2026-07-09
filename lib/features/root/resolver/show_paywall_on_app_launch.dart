import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

/// 同一起動内で起動時ペイウォールを表示済みかどうか
///
/// 他の起動時自動モーダル（例: ShowLifetimeOfferOnAppLaunch）が同一起動で重ねて表示されるのを避けるための、
/// アプリプロセス内でのみ保持するフラグ。永続化はしない。
final shownPaywallOnThisAppLaunchProvider = StateProvider<bool>((ref) => false);

class ShowPaywallOnAppLaunch extends HookConsumerWidget {
  final Widget Function(BuildContext) builder;
  const ShowPaywallOnAppLaunch({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
    final shownPaywallWhenAppFirstLaunch = ref.watch(
      boolSharedPreferencesProvider(BoolKey.shownPaywallWhenAppFirstLaunch),
    );
    final shownPaywallWhenAppFirstLaunchNotifier = ref.watch(
      boolSharedPreferencesProvider(
        BoolKey.shownPaywallWhenAppFirstLaunch,
      ).notifier,
    );
    if (!remoteConfigParameter.isPaywallFirst) {
      return builder(context);
    }
    // Androidの場合revenueCatから情報を取得する処理でエラーになるので早期リターンして回避
    if (kDebugMode && Platform.isAndroid) {
      return builder(context);
    }

    useEffect(() {
      if (shownPaywallWhenAppFirstLaunch.value != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          ref.read(shownPaywallOnThisAppLaunchProvider.notifier).state = true;
          await showPremiumIntroductionSheet(context, source: PaywallSource.appLaunch);
          shownPaywallWhenAppFirstLaunchNotifier.set(true);
        });
      }
      return null;
    }, []);

    // チェックせずにbuilder(context)をするとプッシュ通知の許可を求めるダイアログが先に出る。via SkipInitialSetting
    if (shownPaywallWhenAppFirstLaunch.value == true) {
      return builder(context);
    } else {
      return const ScaffoldIndicator();
    }
  }
}
