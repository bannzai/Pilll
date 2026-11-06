import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/root/resolver/user_setup.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/provider/set_user_id.dart';
import 'package:pilll/provider/user.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../helper/fake.dart';
import '../../../helper/mock.mocks.dart';

/// build した回数を数える CustomerInfoNotifier。アカウントの切り替えで CustomerInfo を取得し直したかを確かめる
class _CountingCustomerInfoNotifier extends FixedCustomerInfoNotifier {
  _CountingCustomerInfoNotifier(
      {required super.customerInfo, required this.onBuild});

  /// build のたびに呼ぶ
  final void Function() onBuild;

  @override
  FutureOr<CustomerInfo> build() {
    onBuild();
    return super.build();
  }
}

void main() {
  group('#UserSetup', () {
    testWidgets(
        '初期設定のログインで userID が変わったら、そのユーザーで RevenueCat を設定し直し CustomerInfo を取得し直す',
        (tester) async {
      final fetchOrCreateUser = MockFetchOrCreateUser();
      when(fetchOrCreateUser('anonymous'))
          .thenAnswer((_) async => const User(id: 'anonymous'));
      when(fetchOrCreateUser('signed_in'))
          .thenAnswer((_) async => const User(id: 'signed_in'));
      final setUserID = MockSetUserID();
      when(setUserID(userID: anyNamed('userID'))).thenAnswer((_) async {});
      final saveUserLaunchInfo = MockSaveUserLaunchInfo();
      when(saveUserLaunchInfo(any)).thenReturn(null);
      var customerInfoBuildCount = 0;

      Widget app({required String userID}) => ProviderScope(
            overrides: [
              fetchOrCreateUserProvider.overrideWithValue(fetchOrCreateUser),
              setUserIDProvider.overrideWithValue(setUserID),
              saveUserLaunchInfoProvider.overrideWithValue(saveUserLaunchInfo),
              customerInfoProvider.overrideWith(
                () => _CountingCustomerInfoNotifier(
                    customerInfo: freeCustomerInfo,
                    onBuild: () => customerInfoBuildCount++),
              ),
            ],
            child: MaterialApp(
                home: UserSetup(
                    userID: userID, builder: (_) => const Text('home'))),
          );

      await tester.pumpWidget(app(userID: 'anonymous'));
      await tester.pumpAndSettle();
      expect(find.text('home'), findsOneWidget);
      verify(setUserID(userID: 'anonymous')).called(1);
      final customerInfoBuildCountBeforeSignIn = customerInfoBuildCount;

      await tester.pumpWidget(app(userID: 'signed_in'));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
      verify(fetchOrCreateUser('signed_in')).called(1);
      verify(setUserID(userID: 'signed_in')).called(1);
      expect(customerInfoBuildCount,
          greaterThan(customerInfoBuildCountBeforeSignIn));
    });
  });
}
