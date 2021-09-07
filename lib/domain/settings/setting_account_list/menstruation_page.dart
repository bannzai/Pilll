import 'package:flutter/material.dart';

class SettingMenstruationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

extension SettingMenstruationPageRoute on SettingMenstruationPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "SettingMenstruationPage"),
      builder: (_) => SettingMenstruationPage(),
    );
  }
}
