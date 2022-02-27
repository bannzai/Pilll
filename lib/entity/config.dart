import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

@freezed
class Config with _$Config {
  factory Config({
    required String minimumSupportedAppVersion,
  }) = _Config;
  Config._();
}
