import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PillSheetModifiedHistoriesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

extension PillSheetModifiedHistoriesPageRoute
    on PillSheetModifiedHistoriesPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "PillSheetModifiedHistoriesPage"),
      builder: (_) => PillSheetModifiedHistoriesPage(),
    );
  }
}
