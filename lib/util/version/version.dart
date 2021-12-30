import 'package:package_info/package_info.dart';

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
    assert(splited.length > 3, "unexpected version format $str");

    final versions = List.filled(3, 0);
    for (int i = 0; i < splited.length; i++) {
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
      major < other.major && minor < other.minor && patch < other.patch;
}
