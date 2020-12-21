// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LaunchInfo _$_$_LaunchInfoFromJson(Map<String, dynamic> json) {
  return _$_LaunchInfo(
    latestOS: json['latestOS'] as String,
    appName: json['appName'] as String,
    appVersion: json['appVersion'] as String,
    buildNumber: json['buildNumber'] as String,
  );
}

Map<String, dynamic> _$_$_LaunchInfoToJson(_$_LaunchInfo instance) =>
    <String, dynamic>{
      'latestOS': instance.latestOS,
      'appName': instance.appName,
      'appVersion': instance.appVersion,
      'buildNumber': instance.buildNumber,
    };
