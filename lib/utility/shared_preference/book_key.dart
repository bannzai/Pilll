import 'package:Pilll/utility/shared_preference/key_type.dart';

enum BoolKey {
  isDidEndInitialSettingKey,
}

extension BoolKeyType on KeyType<bool> {
  String get preferenceKey {}
}
