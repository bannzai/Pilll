import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/utils/datetime/day.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('#shouldShowLifetimeOfferProvider', () {
    group('利用日数の境界値（既定 335 < n < 355 の排他境界）', () {
      // 表示条件のうち利用日数以外はすべて満たした状態で判定結果を返す
      Future<bool> readShouldShowLifetimeOffer({required int usageDays}) async {
        final mockTodayRepository = MockTodayService();
        when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
        todayRepository = mockTodayRepository;

        final container = ProviderContainer(
          overrides: [
            remoteConfigParameterProvider.overrideWithValue(
                RemoteConfigParameter(lifetimeOfferEnabled: true)),
            isLifetimePurchasedProvider
                .overrideWith((ref) => Future.value(false)),
            lifetimeDiscountPackageProvider
                .overrideWith((ref) => FakeRevenueCatPackage()),
            firebaseUserStateProvider.overrideWith(
              (ref) => Stream.value(
                FakeFirebaseAuthUser(
                  fakeCreationTime:
                      DateTime(2026, 7, 3).subtract(Duration(days: usageDays)),
                ),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final subscription =
            container.listen(shouldShowLifetimeOfferProvider, (_, __) {});
        await container.read(isLifetimePurchasedProvider.future);
        await container.read(firebaseUserStateProvider.future);
        return subscription.read();
      }

      test('利用日数が335日（開始境界と同値）の場合は表示されない', () async {
        expect(await readShouldShowLifetimeOffer(usageDays: 335), isFalse);
      });

      test('利用日数が336日（開始境界+1）の場合は表示される', () async {
        expect(await readShouldShowLifetimeOffer(usageDays: 336), isTrue);
      });

      test('利用日数が354日（終了境界-1）の場合は表示される', () async {
        expect(await readShouldShowLifetimeOffer(usageDays: 354), isTrue);
      });

      test('利用日数が355日（終了境界と同値）の場合は表示されない', () async {
        expect(await readShouldShowLifetimeOffer(usageDays: 355), isFalse);
      });
    });

    group('利用日数以外の表示条件', () {
      // 表示対象の利用日数（340日）で、利用日数以外の条件を1つずつ崩して検証する
      Future<bool> readShouldShowLifetimeOffer({
        RemoteConfigParameter? remoteConfigParameter,
        FutureOr<bool>? isLifetimePurchased = false,
        bool hasLifetimeDiscountPackage = true,
        bool hasUserCreationTime = true,
      }) async {
        final mockTodayRepository = MockTodayService();
        when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
        todayRepository = mockTodayRepository;

        final container = ProviderContainer(
          overrides: [
            remoteConfigParameterProvider.overrideWithValue(
                remoteConfigParameter ??
                    RemoteConfigParameter(lifetimeOfferEnabled: true)),
            isLifetimePurchasedProvider
                .overrideWith((ref) => isLifetimePurchased!),
            lifetimeDiscountPackageProvider.overrideWith((ref) =>
                hasLifetimeDiscountPackage ? FakeRevenueCatPackage() : null),
            firebaseUserStateProvider.overrideWith(
              (ref) => Stream.value(
                FakeFirebaseAuthUser(
                  fakeCreationTime: hasUserCreationTime
                      ? DateTime(2026, 7, 3).subtract(const Duration(days: 340))
                      : null,
                ),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        final subscription =
            container.listen(shouldShowLifetimeOfferProvider, (_, __) {});
        await container.read(firebaseUserStateProvider.future);
        return subscription.read();
      }

      test('すべての条件を満たす場合は表示される', () async {
        expect(
            await readShouldShowLifetimeOffer(
                isLifetimePurchased: Future.value(false)),
            isTrue);
      });

      test('Remote ConfigのlifetimeOfferEnabledがfalseの場合は表示されない', () async {
        expect(
          await readShouldShowLifetimeOffer(
              remoteConfigParameter: RemoteConfigParameter()),
          isFalse,
        );
      });

      test('買い切り購入済みの場合は表示されない', () async {
        expect(
            await readShouldShowLifetimeOffer(
                isLifetimePurchased: Future.value(true)),
            isFalse);
      });

      test('買い切り購入状態のロード中は表示されない', () async {
        expect(
          await readShouldShowLifetimeOffer(
              isLifetimePurchased: Completer<bool>().future),
          isFalse,
        );
      });

      test('Discount offeringのlifetime packageが取得できない場合（Android相当）は表示されない',
          () async {
        expect(
            await readShouldShowLifetimeOffer(
                hasLifetimeDiscountPackage: false),
            isFalse);
      });

      test('FirebaseAuthのcreationTimeが取得できない場合は表示されない', () async {
        expect(await readShouldShowLifetimeOffer(hasUserCreationTime: false),
            isFalse);
      });
    });
  });

  group('#lifetimeOfferUsageDaysProvider', () {
    Future<int?> readUsageDays(
        {required DateTime today, required DateTime userCreationTime}) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(today);
      todayRepository = mockTodayRepository;

      final container = ProviderContainer(
        overrides: [
          firebaseUserStateProvider.overrideWith(
            (ref) => Stream.value(
                FakeFirebaseAuthUser(fakeCreationTime: userCreationTime)),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(firebaseUserStateProvider.future);
      return container.read(lifetimeOfferUsageDaysProvider);
    }

    test('creationTimeから今日までの経過日数を返す', () async {
      expect(
        await readUsageDays(
            today: DateTime(2026, 7, 3),
            userCreationTime: DateTime(2026, 6, 23)),
        10,
      );
    });

    test('年をまたぐ場合も経過日数を返す', () async {
      expect(
        await readUsageDays(
            today: DateTime(2026, 1, 4),
            userCreationTime: DateTime(2025, 12, 30)),
        5,
      );
    });

    test('うるう年の2月29日をまたぐ場合も経過日数を返す', () async {
      expect(
        await readUsageDays(
            today: DateTime(2024, 3, 1),
            userCreationTime: DateTime(2024, 2, 28)),
        2,
      );
    });

    test('creationTimeに時刻が含まれていても日付単位で計算される', () async {
      expect(
        await readUsageDays(
            today: DateTime(2026, 7, 3),
            userCreationTime: DateTime(2026, 6, 23, 23, 59, 59)),
        10,
      );
    });

    test('FirebaseAuthのユーザーが取得できるまではnullを返す', () async {
      final container = ProviderContainer(
        overrides: [
          firebaseUserStateProvider.overrideWith(
              (ref) => StreamController<FakeFirebaseAuthUser>().stream),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(lifetimeOfferUsageDaysProvider), isNull);
    });
  });
}
