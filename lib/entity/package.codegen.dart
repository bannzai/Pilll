import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.codegen.g.dart';
part 'package.codegen.freezed.dart';

class PackageFirestoreKey {
  static const latestOS = "latestOS";
}

@freezed
class Package with _$Package {
  @JsonSerializable(explicitToJson: true)
  const factory Package({
    required String latestOS,
    required String appName,
    required String appVersion,
    required String buildNumber,
  }) = _Package;

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);
}
