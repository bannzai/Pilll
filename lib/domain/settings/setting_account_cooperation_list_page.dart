import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/demography/demography_completed_dialog.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/domain/settings/setting_account_cooperation_list_page_store.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingAccountCooperationListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingAccountCooperationListProvider);
    final state = useProvider(settingAccountCooperationListProvider.state);
    final userService = useProvider(userServiceProvider);
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('アカウント設定', style: TextColorStyle.main),
        backgroundColor: PilllColors.white,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 16, left: 15, right: 16),
              child: Text(
                "アカウント連携",
                style: FontType.assisting.merge(TextColorStyle.primary),
              ),
            ),
            SettingAccountCooperationRow(
              accountType: LinkAccountType.apple,
              isLinked: () => state.isLinkedApple,
              onTap: () async {
                if (state.isLinkedApple) {
                  _showUnlinkDialog(context, store, LinkAccountType.apple);
                } else {
                  _linkApple(context, store, userService);
                }
              },
            ),
            SettingAccountCooperationRow(
              accountType: LinkAccountType.google,
              isLinked: () => state.isLinkedGoogle,
              onTap: () async {
                if (state.isLinkedGoogle) {
                  _showUnlinkDialog(context, store, LinkAccountType.google);
                } else {
                  _linkGoogle(context, store, userService);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _showUnlinkDialog(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
    LinkAccountType accountType,
  ) {
    final String eventSuffix = _logEventSuffix(accountType);
    analytics.logEvent(
      name: "show_unlink_dialog_$eventSuffix",
    );
    showDiscardDialog(
      context,
      title: "アカウント連携を解除しますか？",
      message: '''
連携を解除すると${accountType.providerName}を使ってログインができなくなります。
機種変更等でPilllでログインするときに必要です。
''',
      done: () {
        switch (accountType) {
          case LinkAccountType.apple:
            return _unlinkApple(context, store);
          case LinkAccountType.google:
            return _unlinkGoogle(context, store);
        }
      },
      doneText: "解除する",
    );
  }

  String _logEventSuffix(LinkAccountType accountType) {
    switch (accountType) {
      case LinkAccountType.apple:
        return "apple";
      case LinkAccountType.google:
        return "google";
    }
  }

  _unlinkApple(BuildContext context,
          SettingAccountCooperationListPageStore store) async =>
      _unlink(context, store, LinkAccountType.apple);

  _unlinkGoogle(BuildContext context,
          SettingAccountCooperationListPageStore store) async =>
      _unlink(context, store, LinkAccountType.google);

  _unlink(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
    LinkAccountType accountType,
  ) async {
    final String eventSuffix = _logEventSuffix(accountType);
    analytics.logEvent(
      name: "unlink_link_event_$eventSuffix",
    );

    showIndicator();
    try {
      switch (accountType) {
        case LinkAccountType.apple:
          await store.unlinkApple();
          break;
        case LinkAccountType.google:
          await store.unlinkGoogle();
          break;
      }
      hideIndicator();
    } catch (error, stack) {
      analytics.logEvent(
          name: "did_failure_unlink_event_$eventSuffix",
          parameters: {"errot_type": error.runtimeType.toString()});
      errorLogger.recordError(error, stack);
      hideIndicator();

      if (error is UserDisplayedError) {
        showErrorAlertWithError(context, error);
      } else {
        rootKey.currentState?.onError(error);
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text("${accountType.providerName}の連携を解除しました"),
      ),
    );
  }

  _linkApple(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
    UserService userService,
  ) async {
    return _link(context, store, userService, LinkAccountType.apple);
  }

  Future<void> _linkGoogle(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
    UserService userService,
  ) async {
    return _link(context, store, userService, LinkAccountType.google);
  }

  Future<void> _link(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
    UserService userService,
    LinkAccountType accountType,
  ) async {
    final String eventSuffix = _logEventSuffix(accountType);
    analytics.logEvent(
      name: "link_event_$eventSuffix",
    );
    showIndicator();
    try {
      switch (accountType) {
        case LinkAccountType.apple:
          await store.linkApple();
          break;
        case LinkAccountType.google:
          await store.linkGoogle();
          break;
      }
      hideIndicator();
      analytics.logEvent(
        name: "did_end_link_event_$eventSuffix",
      );
    } catch (error) {
      analytics.logEvent(
          name: "did_failure_link_event_$eventSuffix",
          parameters: {"errot_type": error.runtimeType.toString()});

      hideIndicator();
      if (error is UserDisplayedError) {
        showErrorAlertWithError(context, error);
      } else {
        rootKey.currentState?.onError(error);
      }
      return;
    }

    final snackBarDuration = Duration(seconds: 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: snackBarDuration,
        content: Text("${accountType.providerName}で連携しました"),
      ),
    );
    await Future.delayed(snackBarDuration);
    final sharedPreference = await SharedPreferences.getInstance();
    final isAlreadyShowDemography =
        sharedPreference.getBool(BoolKey.isAlreadyShowDemography);

    if (isAlreadyShowDemography == true) {
      return;
    }
    sharedPreference.setBool(BoolKey.isAlreadyShowDemography, true);

    Navigator.of(context).push(DemographyPageRoute.route(userService, () {
      showDemographyCompletedDialog(context);
    }));
  }
}

extension SettingAccountCooperationListPageRoute
    on SettingAccountCooperationListPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "SettingAccountCooperationListPage"),
      builder: (_) => SettingAccountCooperationListPage(),
    );
  }
}

class SettingAccountCooperationRow extends StatelessWidget {
  final LinkAccountType accountType;
  final bool Function() isLinked;
  final Function() onTap;

  SettingAccountCooperationRow({
    required this.accountType,
    required this.isLinked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _icon(),
      title: Text(_title, style: FontType.listRow),
      trailing: _check(),
      horizontalTitleGap: 4,
      onTap: () => onTap(),
    );
  }

  Widget _icon() {
    switch (accountType) {
      case LinkAccountType.apple:
        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: PilllColors.appleBlack,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 24,
          height: 24,
          child: SvgPicture.asset("images/apple_icon.svg"),
        );
      case LinkAccountType.google:
        return Container(
          padding: EdgeInsets.all(6),
          child: SvgPicture.asset("images/google_icon.svg"),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PilllColors.shadow, width: 0.5),
          ),
        );
    }
  }

  String get _title {
    final linked = isLinked();
    final providerName = accountType.providerName;
    if (!linked) {
      return providerName;
    }
    return "$providerName で連携済み";
  }

  Widget _check() {
    final linked = isLinked();
    if (!linked) {
      return Container(width: 1, height: 1);
    }
    return Container(
        padding: EdgeInsets.only(left: 2, right: 2),
        color: PilllColors.enable,
        child: SvgPicture.asset("images/checkmark.svg"),
        width: 18,
        height: 18);
  }
}
