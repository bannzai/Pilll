import 'package:cloud_functions/cloud_functions.dart';
import 'package:pilll/entity/inquiry.codegen.dart';

final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

extension FirebaseFunctionsExt on FirebaseFunctions {
  Future<String> inquiry({required InquiryType inquiryType, String? otherTypeText, required String email, required String content}) async {
    final result = await httpsCallable(
      'inquiry',
    ).call({'inquiryType': inquiryType.name, if (otherTypeText != null) 'otherTypeText': otherTypeText, 'email': email, 'content': content});
    final response = mapToJSON(result.data);
    return response['inquiryId'] as String;
  }

  Future<bool> startPromotion({required int promotionDayCount}) async {
    final result = await httpsCallable('startPromotion').call({'promotionDayCount': promotionDayCount});
    final response = mapToJSON(result.data);
    if (response['result'] != 'OK') {
      throw Exception(response['error']['message']);
    }
    return response['data']['isAlreadyExist'] as bool;
  }
}

// Map<String, dynamic>.fromだけだとネストした子要素が_Map<Object? Object?>のままになる
// 以下のエラーを回避する _TypeError (type '_Map<Object?, Object?>' is not a subtype of type 'Map<String, dynamic>' in type cast)
Map<String, dynamic> mapToJSON(Map<dynamic, dynamic> map) {
  final newMap = <String, dynamic>{};
  for (final key in map.keys) {
    final value = map[key];
    final newKey = key.toString();
    if (value is Map) {
      newMap[newKey] = mapToJSON(value);
    } else if (value is List) {
      newMap[newKey] = value.map((e) {
        if (e is Map) {
          return mapToJSON(e);
        }
        return e;
      }).toList();
    } else {
      newMap[newKey] = value;
    }
  }
  return newMap;
}
