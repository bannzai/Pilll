import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/auth/apple.dart';
import 'package:pilll/auth/google.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/demography/demography_page.dart';
import 'package:pilll/domain/settings/setting_account_cooperation_list_page_store.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';

class SettingAccountCooperationListPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final store = useProvider(settingAccountCooperationListProvider);
    final state = useProvider(settingAccountCooperationListProvider.state);
    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
        error: state.exception,
        reload: () => store.reset(),
        child: Builder(
          builder: (BuildContext context) {
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
                        "アカウント登録",
                        style: FontType.assisting.merge(TextColorStyle.primary),
                      ),
                    ),
                    SettingAccountCooperationRow(
                      accountType: LinkAccountType.apple,
                      isLinked: () => state.isLinkedApple,
                      onTap: () async {
                        if (state.isLinkedApple) {
                          return;
                        }
                        _linkApple(context, store);
                      },
                    ),
                    Divider(indent: 16),
                    SettingAccountCooperationRow(
                      accountType: LinkAccountType.google,
                      isLinked: () => state.isLinkedGoogle,
                      onTap: () async {
                        if (state.isLinkedGoogle) {
                          return;
                        }
                        _linkGoogle(context, store);
                      },
                    ),
                    Divider(indent: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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

  _linkApple(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
  ) async {
    return _link(context, store, LinkAccountType.apple);
  }

  Future<void> _linkGoogle(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
  ) async {
    return _link(context, store, LinkAccountType.google);
  }

  Future<void> _link(
    BuildContext context,
    SettingAccountCooperationListPageStore store,
    LinkAccountType accountType,
  ) async {
    final String eventSuffix = _logEventSuffix(accountType);
    analytics.logEvent(
      name: "link_event_$eventSuffix",
    );
    HUD.of(context).show();
    try {
      final bool isDetermined;
      switch (accountType) {
        case LinkAccountType.apple:
          isDetermined = await _handleApple(store);
          break;
        case LinkAccountType.google:
          isDetermined = await _handleGoogle(store);
          break;
      }
      HUD.of(context).hide();
      analytics.logEvent(
        name: "did_end_link_event_$eventSuffix",
      );
      if (!isDetermined) {
        return;
      }
    } catch (error) {
      analytics.logEvent(
          name: "did_failure_link_event_$eventSuffix",
          parameters: {"errot_type": error.runtimeType.toString()});

      HUD.of(context).hide();
      if (error is UserDisplayedError) {
        showErrorAlertWithError(context, error);
      } else {
        UniversalErrorPage.of(context).showError(error);
      }
      return;
    }

    final snackBarDuration = Duration(seconds: 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: snackBarDuration,
        content: Text("${accountType.providerName}で登録しました"),
      ),
    );
    await Future.delayed(snackBarDuration);
    showDemographyPageIfNeeded(context);
  }

  Future<bool> _handleApple(
      SettingAccountCooperationListPageStore store) async {
    switch (await store.linkApple()) {
      case SigninWithAppleState.cancel:
        return false;
      case SigninWithAppleState.determined:
        return true;
    }
  }

  Future<bool> _handleGoogle(
      SettingAccountCooperationListPageStore store) async {
    switch (await store.linkGoogle()) {
      case SigninWithGoogleState.cancel:
        return false;
      case SigninWithGoogleState.determined:
        return true;
    }
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
    return "$providerName で登録済み";
  }
}
