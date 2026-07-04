import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
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

        SharedPreferences.setMockInitialValues({});
        final sharedPreferences = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
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

    group('表示期限', () {
      // 表示期限以外の表示条件をすべて満たした状態で、初回表示時刻と現在時刻(tick)を操作して判定結果を返す
      Future<bool> readShouldShowLifetimeOffer({
        required String? firstDisplayedDateTime,
        required DateTime tick,
        int lifetimeOfferDurationHours =
            RemoteConfigParameterDefaultValues.lifetimeOfferDurationHours,
      }) async {
        final mockTodayRepository = MockTodayService();
        when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
        todayRepository = mockTodayRepository;

        SharedPreferences.setMockInitialValues({
          if (firstDisplayedDateTime != null)
            StringKey.lifetimeOfferFirstDisplayedDateTime:
                firstDisplayedDateTime,
        });
        final sharedPreferences = await SharedPreferences.getInstance();

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            tickProvider.overrideWith(() => FakeTick(fakeDateTime: tick)),
            remoteConfigParameterProvider.overrideWithValue(
              RemoteConfigParameter(
                lifetimeOfferEnabled: true,
                lifetimeOfferDurationHours: lifetimeOfferDurationHours,
              ),
            ),
            isLifetimePurchasedProvider
                .overrideWith((ref) => Future.value(false)),
            lifetimeDiscountPackageProvider
                .overrideWith((ref) => FakeRevenueCatPackage()),
            firebaseUserStateProvider.overrideWith(
              (ref) => Stream.value(
                FakeFirebaseAuthUser(
                  fakeCreationTime:
                      DateTime(2026, 7, 3).subtract(const Duration(days: 340)),
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

      test('初回表示前（初回表示時刻が未セット）の場合は表示される', () async {
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime: null,
            tick: DateTime(2026, 7, 3, 9, 0, 0),
          ),
          isTrue,
        );
      });

      test('初回表示から24時間ちょうど（期限と同時刻）の場合は表示される', () async {
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime:
                DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
            tick: DateTime(2026, 7, 3, 9, 0, 0),
          ),
          isTrue,
        );
      });

      test('初回表示から24時間+1秒の場合は表示されない', () async {
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime:
                DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
            tick: DateTime(2026, 7, 3, 9, 0, 1),
          ),
          isFalse,
        );
      });

      test('Remote Configで表示期間を48時間にした場合は24時間経過後も表示される', () async {
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime:
                DateTime(2026, 7, 1, 9, 0, 0).toIso8601String(),
            tick: DateTime(2026, 7, 2, 9, 0, 1),
            lifetimeOfferDurationHours: 48,
          ),
          isTrue,
        );
      });

      test('Remote Configで表示期間を48時間にした場合は48時間+1秒で表示されない', () async {
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime:
                DateTime(2026, 7, 1, 9, 0, 0).toIso8601String(),
            tick: DateTime(2026, 7, 3, 9, 0, 1),
            lifetimeOfferDurationHours: 48,
          ),
          isFalse,
        );
      });
    });
  });

  group('#lifetimeOfferDeadlineProvider', () {
    // 初回表示時刻とRemote Configの表示期間を操作して表示期限を返す
    Future<DateTime?> readDeadline({
      required String? firstDisplayedDateTime,
      int lifetimeOfferDurationHours =
          RemoteConfigParameterDefaultValues.lifetimeOfferDurationHours,
    }) async {
      SharedPreferences.setMockInitialValues({
        if (firstDisplayedDateTime != null)
          StringKey.lifetimeOfferFirstDisplayedDateTime: firstDisplayedDateTime,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          remoteConfigParameterProvider.overrideWithValue(
            RemoteConfigParameter(
              lifetimeOfferDurationHours: lifetimeOfferDurationHours,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      return container.read(lifetimeOfferDeadlineProvider);
    }

    test('初回表示時刻が未セットの場合はnullを返す', () async {
      expect(await readDeadline(firstDisplayedDateTime: null), isNull);
    });

    test('初回表示時刻から既定24時間後の期限を返す', () async {
      expect(
        await readDeadline(
          firstDisplayedDateTime:
              DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
        ),
        DateTime(2026, 7, 3, 9, 0, 0),
      );
    });

    test('Remote Configの表示期間（48時間）に応じた期限を返す', () async {
      expect(
        await readDeadline(
          firstDisplayedDateTime:
              DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
          lifetimeOfferDurationHours: 48,
        ),
        DateTime(2026, 7, 4, 9, 0, 0),
      );
    });
  });

  group('#lifetimeOfferRemainingDurationProvider', () {
    // 初回表示時刻と現在時刻(tick)を操作して残り時間を返す
    Future<Duration> readRemainingDuration({
      required String? firstDisplayedDateTime,
      required DateTime tick,
    }) async {
      SharedPreferences.setMockInitialValues({
        if (firstDisplayedDateTime != null)
          StringKey.lifetimeOfferFirstDisplayedDateTime: firstDisplayedDateTime,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          tickProvider.overrideWith(() => FakeTick(fakeDateTime: tick)),
          remoteConfigParameterProvider
              .overrideWithValue(RemoteConfigParameter()),
        ],
      );
      addTearDown(container.dispose);

      return container.read(lifetimeOfferRemainingDurationProvider);
    }

    test('初回表示前（初回表示時刻が未セット）は満額の残り時間を返す', () async {
      expect(
        await readRemainingDuration(
          firstDisplayedDateTime: null,
          tick: DateTime(2026, 7, 3, 9, 0, 0),
        ),
        const Duration(hours: 24),
      );
    });

    test('初回表示済みの場合は期限までの残り時間を返す', () async {
      expect(
        await readRemainingDuration(
          firstDisplayedDateTime:
              DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
          tick: DateTime(2026, 7, 3, 8, 0, 0),
        ),
        const Duration(hours: 1),
      );
    });

    test('期限を過ぎた場合は負のDurationを返す', () async {
      expect(
        await readRemainingDuration(
          firstDisplayedDateTime:
              DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
          tick: DateTime(2026, 7, 3, 9, 0, 1),
        ),
        const Duration(seconds: -1),
      );
    });
  });

  group('#lifetimeOfferCountdownString', () {
    test('残り時間をHH:MM:SS形式の文字列にする', () {
      expect(
        lifetimeOfferCountdownString(
            const Duration(hours: 23, minutes: 59, seconds: 59)),
        '23:59:59',
      );
    });

    test('24時間ちょうどの場合は24:00:00になる', () {
      expect(
        lifetimeOfferCountdownString(const Duration(hours: 24)),
        '24:00:00',
      );
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
