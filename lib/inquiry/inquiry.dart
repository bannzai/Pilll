import 'package:pilll/auth/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/util/environment.dart';
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
  PillSheetModel? pillSheet =
      await PillSheetService(databaseConnection).fetchLast();
  Setting setting = await SettingService(databaseConnection).fetch();
  final menstruations =
      await MenstruationService(databaseConnection).fetchAll();
  Menstruation? menstruation =
      menstruations.isNotEmpty ? menstruations.last : null;
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
    "latestMenstruation: ${menstruation?.toJson()}",
    "pillSheet.entity.id: ${pillSheet?.id}",
    "pillSheetState.entity: ${pillSheet?.toJson()}",
    "settingState.entity: ${setting.toJson()}",
  ];
  return contents.join(separator);
}
