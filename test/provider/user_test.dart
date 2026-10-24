import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/provider/user.dart';

import '../helper/mock.mocks.dart';

void main() {
  group("#EndInitialSetting", () {
    test("トライアルの開始を startTrial callable に任せ、クライアントから値を渡さない", () async {
      final firebaseFunctions = MockFirebaseFunctions();
      final httpsCallable = MockHttpsCallable();
      when(firebaseFunctions.httpsCallable('startTrial'))
          .thenReturn(httpsCallable);
      when(httpsCallable.call())
          .thenAnswer((_) async => MockHttpsCallableResult());

      await EndInitialSetting(firebaseFunctions)();

      verify(firebaseFunctions.httpsCallable('startTrial')).called(1);
      verify(httpsCallable.call()).called(1);
    });
  });

  group("#SyncPurchaseInfo", () {
    test("isPremium の設定を syncRevenueCat callable に任せる", () async {
      final firebaseFunctions = MockFirebaseFunctions();
      final httpsCallable = MockHttpsCallable();
      when(firebaseFunctions.httpsCallable('syncRevenueCat'))
          .thenReturn(httpsCallable);
      when(httpsCallable.call())
          .thenAnswer((_) async => MockHttpsCallableResult());

      await SyncPurchaseInfo(firebaseFunctions)();

      verify(firebaseFunctions.httpsCallable('syncRevenueCat')).called(1);
      verify(httpsCallable.call()).called(1);
    });
  });
}
