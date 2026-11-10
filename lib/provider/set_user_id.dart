import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

final setUserIDProvider = Provider((_) => SetUserID());

class SetUserID {
  Future<void> call({required String userID}) async {
    unawaited(FirebaseCrashlytics.instance.setUserIdentifier(userID));
    unawaited(firebaseAnalytics.setUserId(id: userID));

    // 初期設定のログインで別のアカウントに切り替わった時は SDK を設定済みのため、logIn で RevenueCat のユーザーを切り替え、
    // 呼び出し側がそのユーザーの CustomerInfo を読めるよう完了を待つ
    if (await Purchases.isConfigured && await Purchases.appUserID != userID) {
      final customerInfo = await logInPurchasesUser(uid: userID, currentFirebaseUserID: () => FirebaseAuth.instance.currentUser?.uid);
      // 通知のアクション (fetchCustomerInfoOutsideUI) が先に別のユーザーで SDK を設定した時は initializePurchase を通らないため、ここでも登録する。
      // 登録時に SDK が切り替える前のユーザーの CustomerInfo で呼ぶのは無視し、切り替えた後のユーザーの CustomerInfo を書く
      addCustomerInfoUpdateListenerIgnoringLastReceived();
      unawaited(callUpdatePurchaseInfo(customerInfo));
      return;
    }
    // Keep call initialPurchase before logIn.
    await initializePurchase(userID);
    // 待っている間に Firebase Auth のユーザーが変わった時に RevenueCat を古いユーザーに戻さないよう、logInPurchasesUser を通す。
    // 切り替えないと決まった時 (StateError) は、新しいユーザーの UserSetup が切り替えるため、記録だけして続ける
    unawaited(
      logInPurchasesUser(uid: userID, currentFirebaseUserID: () => FirebaseAuth.instance.currentUser?.uid)
          .then((_) {}, onError: (Object error, StackTrace stackTrace) => errorLogger.recordError(error, stackTrace)),
    );
  }
}
