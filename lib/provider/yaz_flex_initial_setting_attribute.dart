import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

/// 初期設定でヤーズフレックス向けの導線を通って登録したかを表す属性の名前
/// Firebase Analytics のユーザープロパティと RevenueCat の customer attribute の両方に同じ名前で載せる
/// (BigQuery では events の user_properties と mart.revenuecat_webhooks の subscriberAttributes から読む)
/// Firebase Analytics のユーザープロパティ名は 24 文字までのため、24 文字に収めている
const yazFlexInitialSettingAttributeName = 'yaz_flex_initial_setting';

/// [SetYazFlexInitialSettingAttribute] を提供する。テストでは Firebase Analytics と RevenueCat を呼ばない実装に差し替える
final setYazFlexInitialSettingAttributeProvider = Provider(
  (ref) => SetYazFlexInitialSettingAttribute(),
);

/// 初期設定の登録時に、ヤーズフレックス向けの導線を通ったかを Firebase Analytics と RevenueCat に載せる
/// 課金率・継続率を導線ごとに比べるための属性で、この属性を足す前に初期設定を終えたユーザーには付かない
class SetYazFlexInitialSettingAttribute {
  /// [isYazFlex] が true なら 'true'、false なら 'false' を載せる。従来の導線のユーザーにも 'false' を載せるのは、属性を足す前に初期設定を終えたユーザー (未設定) と区別するため
  /// 計測用の属性で、載せられなくても初期設定の登録は続けられるように、失敗は記録するだけで例外を投げない
  Future<void> call({required bool isYazFlex}) async {
    // 片方の失敗でもう片方に載らなくなるのを避けるため、載せる先ごとに失敗を受ける
    try {
      analytics.setUserProperties(yazFlexInitialSettingAttributeName, isYazFlex.toString());
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
    }
    try {
      await Purchases.setAttributes({yazFlexInitialSettingAttributeName: isYazFlex.toString()});
    } catch (exception, stack) {
      errorLogger.recordError(exception, stack);
    }
  }
}
