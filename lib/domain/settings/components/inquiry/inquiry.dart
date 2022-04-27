import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/setting.dart';
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
  final userID = FirebaseAuth.instance.currentUser?.uid;
  if (userID == null) {
    return Future.value("DEBUG INFO user is not found");
  }

  DatabaseConnection databaseConnection = DatabaseConnection(userID);

  PillSheetGroup? pillSheetGroup;
  try {
    pillSheetGroup =
        await PillSheetGroupDatastore(databaseConnection).fetchLatest();
  } catch (_) {}

  Setting? setting;
  try {
    setting = await SettingDatastore(databaseConnection).fetch();
  } catch (_) {}

  List<Menstruation> menstruations = [];
  try {
    menstruations = await MenstruationDatastore(databaseConnection).fetchAll();
  } catch (_) {}

  Menstruation? menstruation =
      menstruations.isNotEmpty ? menstruations.first : null;

  PackageInfo? package;
  try {
    package = await PackageInfo.fromPlatform();
  } catch (_) {}
  final appName = package?.appName;
  final buildNumber = package?.buildNumber;
  final packageName = package?.packageName;

  final contents = [
    "DEBUG INFO",
    "appName: $appName",
    "packageName: $packageName",
    "buildNumber: $buildNumber",
    "env: ${Environment.isProduction ? "production" : "development"}",
    "user id: $userID",
    "latestMenstruation: ${menstruation?.toString()}",
    "pillSheetGroupID: ${pillSheetGroup?.id}",
    "activedPillSheet: ${pillSheetGroup?.activedPillSheet?.toString()}",
    "settingState.entity: ${setting?.toString()}",
  ];
  return contents.join(separator);
}
