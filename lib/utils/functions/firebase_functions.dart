import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/entity/inquiry.codegen.dart';
import 'package:pilll/utils/environment.dart';

final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

/// お問い合わせの callable に test: true を付けるか。
/// DEBUG ビルドか、dev flavor (pilll-dev に接続する main.dev.dart 起動。TestFlight 等に配る release ビルドを含む) なら true。
/// 本番のお問い合わせチャンネルに開発中のお問い合わせを混ぜず、サーバーにテスト用チャンネル (#test-notification) へ投稿させるため。
/// dev flavor の release ビルドは kDebugMode が false になり、DEBUG ビルドの判定だけでは本番チャンネルに届いていた。
bool inquiryIsTest({required bool debugMode, required Flavor? flavor}) {
  return debugMode || flavor == Flavor.DEVELOP || flavor == Flavor.LOCAL;
}

extension FirebaseFunctionsExt on FirebaseFunctions {
  Future<String> inquiry({
    required InquiryType inquiryType,
    String? otherTypeText,
    required String email,
    required String content,
  }) async {
    final result = await httpsCallable('inquiry').call({
      'inquiryType': inquiryType.name,
      if (otherTypeText != null) 'otherTypeText': otherTypeText,
      'email': email,
      'content': content,
      if (inquiryIsTest(debugMode: kDebugMode, flavor: Environment.flavor)) 'test': true,
    });
    final response = mapToJSON(result.data);
    return response['inquiryId'] as String;
  }

  /// ログイン中のユーザーにトライアル (RevenueCat の Premium の Promotional Entitlement) を付与する。
  /// 期限の日数は Remote Config の trialDeadlineDateOffsetDay をサーバーが読み、付与は 1 アカウント 1 回でサーバーが判定する (bannzai/PilllBackend#581)。
  /// サーバーは付与した時に `{ promotionDeadlineDateMs }` を返し、既に付与済み (旧方式のトライアル済みを含む) の時は already-exists のエラーを返す
  /// (bannzai/PilllBackend#582 の functions/src/functions/startPromotion)。期限は CustomerInfo から読むため戻り値は使わず、
  /// already-exists はトライアルを開始済みとして成功と同じに扱う (初期設定のやり直しで 2 回目に呼ばれた時に、初期設定を完了できなくしないため)。
  /// それ以外のエラーは FirebaseFunctionsException のまま投げる
  Future<void> startPromotion() async {
    try {
      await httpsCallable('startPromotion').call();
    } on FirebaseFunctionsException catch (error) {
      if (error.code == 'already-exists') {
        return;
      }
      rethrow;
    }
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
