import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.g.dart';
part 'package.freezed.dart';

class PackageFirestoreKey {
  static final latestOS = "latestOS";
}

@freezed
class Package with _$Package {
  factory Package({
    String latestOS,
    String appName,
    String appVersion,
    String buildNumber,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PackageToJson(this as _$_Package);
}
