import 'package:Pilll/auth/auth.dart';
import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/service/setting.dart';
import 'package:Pilll/util/environment.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

inquiry() {
  PackageInfo.fromPlatform().then((value) => debugInfo(", ")).then((info) {
    launch(
        Uri.encodeFull(
            "https://docs.google.com/forms/d/e/1FAIpQLSddEpE641jIKEL9cxgiKaRytmBtsP7PXnDdXonEyE-n62JMWQ/viewform?usp=pp_url&entry.2066946565=$info"),
        forceSafariVC: true);
  });
}

Future<String> debugInfo(String separator) async {
  String userID = (await auth()).uid;
  DatabaseConnection databaseConnection = DatabaseConnection(userID);
  PillSheetModel pillSheet =
      await PillSheetService(databaseConnection).fetchLast();
  Setting setting = await SettingService(databaseConnection).fetch();
  final package = await PackageInfo.fromPlatform();
  final appName = package.appName;
  final buildNumber = package.buildNumber;
  final packageName = package.packageName;
  final contents = [
    "DEBUG INFO",
    "appName: $appName",
    "packageName: $packageName",
    "buildNumber: $buildNumber",
    "env: ${Environment.isProduction ? "production" : "development"}",
    "user id: $userID",
    "pillSheet.entity.id: ${pillSheet?.id}",
    "pillSheetState.entity: ${pillSheet == null ? "null" : pillSheet.toJson()}",
    "settingState.entity: ${setting == null ? "null" : setting.toJson()}",
  ];
  return contents.join(separator);
}
