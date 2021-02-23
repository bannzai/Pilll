import 'package:Pilll/auth/auth.dart';
import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/util/environment.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

inquiry() {
  PackageInfo.fromPlatform().then((value) => debugInfo(",")).then((info) {
    print(
        "length:${Uri.encodeFull("https://form.run/@pilll-reminder-app-1613749422?_field_14=$info").length}");
    launch(
        Uri.encodeFull(
            "https://form.run/@pilll-reminder-app-1613749422?_field_14=$info"),
        forceSafariVC: true);
  });
}

Future<String> debugInfo(String separator) async {
  String userID = (await auth()).uid;
  DatabaseConnection databaseConnection = DatabaseConnection(userID);
  PillSheetModel pillSheet =
      await PillSheetService(databaseConnection).fetchLast();
  final package = await PackageInfo.fromPlatform();
  final buildNumber = package.buildNumber;
  final contents = [
    "buildNumber:$buildNumber",
    "env:${Environment.isProduction ? "prod" : "dev"}",
    "userID:$userID",
    "pillSheetID:${pillSheet?.id}",
    "pillSheetStateJSON:${pillSheet == null ? "null" : pillSheet.toJson()}",
  ];
  return contents.join(separator);
}
