import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/root/launch_exception.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:flutter/material.dart';

// FIXME: test 時にboolSharedPreferencesProviderをそのまま使うとフリーズする。 => riverpod_generatorで書き換えたりしたのでもうしない可能性はある
final didEndInitialSettingProvider = Provider.autoDispose((ref) => ref.watch(boolSharedPreferencesProvider(BoolKey.didEndInitialSetting)));

enum InitialSettingOrAppPageScreenType { initialSetting, app }

// InitialSettingかAppのメインストリームのWidgetに分岐する
// 主にdidEndInitialSettingの値によって分岐するが、下位互換や何らかの理由でuser.settingがnullになってしまったユーザーのためにuserの値を見てinitialSettingに分岐するかも決定する
class InitialSettingOrAppPage extends HookConsumerWidget {
  final Widget Function(BuildContext) initialSettingPageBuilder;
  final Widget Function(BuildContext) homePageBuilder;
  const InitialSettingOrAppPage({
    super.key,
    required this.homePageBuilder,
    required this.initialSettingPageBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final didEndInitialSetting = ref.watch(didEndInitialSettingProvider);

    // UserSetupPageでUserはできているのでfetchが終わり次第値は必ず入る。ここでwatchしないとInitialSetting -> Appへの遷移が成立しない
    final user = ref.watch(userProvider).valueOrNull;
    final error = useState<LaunchException?>(null);
    final screenType = retrieveScreenType(user: user, didEndInitialSetting: didEndInitialSetting.value);

    useEffect(() {
      if (user != null) {
        if (user.setting == null) {
          analytics.logEvent(name: "uset_setting_is_null", parameters: {"uid": user.id});
        }
      }

      return null;
    }, [user]);

    return UniversalErrorPage(
      error: error.value,
      reload: () => ref.refresh(refreshAppProvider),
      child: () {
        if (screenType == null) {
          return const ScaffoldIndicator();
        }
        switch (screenType) {
          case InitialSettingOrAppPageScreenType.initialSetting:
            return initialSettingPageBuilder(context);
          case InitialSettingOrAppPageScreenType.app:
            return homePageBuilder(context);
        }
      }(),
    );
  }
}

InitialSettingOrAppPageScreenType? retrieveScreenType({
  required User? user,
  required bool? didEndInitialSetting,
}) {
  if (user == null) {
    return null;
  }
  if (user.setting == null) {
    return InitialSettingOrAppPageScreenType.initialSetting;
  }

  if (didEndInitialSetting == null) {
    analytics.logEvent(name: "did_end_i_s_is_null");
    return InitialSettingOrAppPageScreenType.initialSetting;
  }
  if (!didEndInitialSetting) {
    analytics.logEvent(name: "did_end_i_s_is_false");
    return InitialSettingOrAppPageScreenType.initialSetting;
  }

  analytics.logEvent(name: "screen_type_is_home");
  return InitialSettingOrAppPageScreenType.app;
}
