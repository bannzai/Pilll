import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/user.dart';

class SettingAccountCooperationListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text('アカウント設定', style: TextColorStyle.main),
        backgroundColor: PilllColors.white,
      ),
      body: Container(
        child: ListView(children: [
          Container(
            padding: EdgeInsets.only(top: 16, left: 15, right: 16),
            child: Text(
              "アカウント連携",
              style: FontType.assisting.merge(TextColorStyle.primary),
            ),
          ),
          ...LinkAccountType.values.map((e) {
            return SettingAccountCooperationRow(
                accountType: e,
                isLinked: (accountType) {
                  // TODO:
                  return false;
                },
                onTap: () {
                  // TODO:
                  return;
                });
          }),
        ]),
      ),
    );
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
  final bool Function(LinkAccountType) isLinked;
  final VoidCallback onTap;

  SettingAccountCooperationRow({
    required this.accountType,
    required this.isLinked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _icon(),
      title: Align(
        child: Text(_title, style: FontType.listRow),
        alignment: Alignment(-1.18, 0),
      ),
      trailing: SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
      onTap: onTap,
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
    final linked = isLinked(accountType);
    switch (accountType) {
      case LinkAccountType.apple:
        return linked ? "Apple IDで連携済み" : "Apple ID";
      case LinkAccountType.google:
        return linked ? "Googleで連携済み" : "Google アカウント";
    }
  }
}
