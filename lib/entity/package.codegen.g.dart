// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PackageImpl _$$PackageImplFromJson(Map<String, dynamic> json) =>
    _$PackageImpl(
      latestOS: json['latestOS'] as String,
      appName: json['appName'] as String,
      appVersion: json['appVersion'] as String,
      buildNumber: json['buildNumber'] as String,
    );

Map<String, dynamic> _$$PackageImplToJson(_$PackageImpl instance) =>
    <String, dynamic>{
      'latestOS': instance.latestOS,
      'appName': instance.appName,
      'appVersion': instance.appVersion,
      'buildNumber': instance.buildNumber,
    };
