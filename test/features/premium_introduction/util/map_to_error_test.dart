import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/premium_introduction/util/map_to_error.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() {
  group('#mapToDisplayedException', () {
    // PurchasesErrorHelper.getErrorCode は PlatformException.code を enum の index として解釈する
    PlatformException platformException(PurchasesErrorCode errorCode) => PlatformException(
          code: '${PurchasesErrorCode.values.indexOf(errorCode)}',
          message: 'message',
          details: 'details',
        );

    test('purchases_flutter v10 で追加されたエラーコードはサポート外エラーのFormatExceptionにマップされる', () {
      // Pilllが使用していない機能のエラーコード (map_to_error.dart のコメント参照)
      const addedErrorCodes = [
        PurchasesErrorCode.featureNotAvailableInCustomEntitlementsComputationMode,
        PurchasesErrorCode.signatureVerificationFailed,
        PurchasesErrorCode.featureNotSupportedWithStoreKit1,
        PurchasesErrorCode.invalidWebPurchaseToken,
        PurchasesErrorCode.purchaseBelongsToOtherUser,
        PurchasesErrorCode.expiredWebPurchaseToken,
        PurchasesErrorCode.testStoreSimulatedPurchaseError,
      ];
      for (final errorCode in addedErrorCodes) {
        expect(
          mapToDisplayedException(platformException(errorCode)),
          isA<FormatException>(),
          reason: '$errorCode はFormatExceptionにマップされるべき',
        );
      }
    });

    test('purchaseCancelledErrorはユーザー起因のキャンセルなのでnullを返す', () {
      expect(mapToDisplayedException(platformException(PurchasesErrorCode.purchaseCancelledError)), isNull);
    });

    test('enumの範囲外のエラーコードはunknownErrorとして扱われFormatExceptionにマップされる', () {
      // 境界値: getErrorCode は values.length 以上の code を unknownError に丸める
      expect(
        mapToDisplayedException(PlatformException(
          code: '${PurchasesErrorCode.values.length}',
          message: 'message',
          details: 'details',
        )),
        isA<FormatException>(),
      );
    });
  });
}
