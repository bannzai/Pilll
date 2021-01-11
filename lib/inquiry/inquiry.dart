import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

inquiry() {
  PackageInfo.fromPlatform().then((value) {
    var version = value.version;
    launch(
        "https://docs.google.com/forms/d/e/1FAIpQLSdLX5lLdOSr2B2mwzCptH1kjsJUYy8cKFSYguxl9yvep5b7ig/viewform?usp=pp_url&entry.2066946565=$version",
        forceSafariVC: true);
  });
}
