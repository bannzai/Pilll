import 'package:package_info/package_info.dart';
import 'package:pilll/utils/environment.dart';

class Version {
  final int major;
  final int minor;
  final int patch;

  Version({
    required this.major,
    required this.minor,
    required this.patch,
  });

  factory Version.parse(String str) {
    final splited = str.split(".");
    if (Environment.isDevelopment) {
      assert(
          splited.length <= 3 || (splited.last == "dev" && splited.length == 4),
          "unexpected version format $str");
    }

    final versions = List.filled(3, 0);
    for (int i = 0; i < splited.length; i++) {
      if (splited[i] == "dev") {
        break;
      }
      versions[i] = int.parse(splited[i]);
    }
    return Version(
      major: versions[0],
      minor: versions[1],
      patch: versions[2],
    );
  }

  static Future<Version> fromPackage() async {
    final package = await PackageInfo.fromPlatform();
    return Version.parse(package.version);
  }

  bool isLessThan(Version other) =>
      major < other.major ||
      (major <= other.major && minor < other.minor) ||
      (major <= other.major && minor <= other.minor && patch < other.patch);

  String get version {
    return "$major.$minor.$patch";
  }
}
