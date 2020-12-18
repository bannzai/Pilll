import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_info.g.dart';
part 'launch_info.freezed.dart';

abstract class LaunchInfoFirestoreKey {
  static final latestOS = "latestOS";
}

@freezed
abstract class LaunchInfo implements _$LaunchInfo {
  LaunchInfo._();
  factory LaunchInfo({
    @required String latestOS,
    @required String appVersion,
  }) = _LaunchInfo;

  factory LaunchInfo.fromJson(Map<String, dynamic> json) =>
      _$LaunchInfoFromJson(json);
  Map<String, dynamic> toJson() => _$_$_LaunchInfoToJson(this);
}
