import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.codegen.g.dart';
part 'config.codegen.freezed.dart';

@freezed
class Config with _$Config {
  factory Config({
    required String minimumSupportedAppVersion,
  }) = _Config;
  Config._();

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
