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
          SettingAccountCooperationRow(
              accountType: LinkAccountType.apple,
              isLinked: (accountType) {
                // TODO:
                return false;
              },
              onTap: () {
                // TODO:
                return;
              })
        ]),
      ),
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
      title: Row(
        children: [
          Text(_title, style: FontType.listRow),
          SizedBox(width: 8),
          SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
        ],
      ),
      onTap: onTap,
    );
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
