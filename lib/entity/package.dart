import 'package:freezed_annotation/freezed_annotation.dart';

part 'package.g.dart';
part 'package.freezed.dart';

class PackageFirestoreKey {
  static final latestOS = "latestOS";
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
