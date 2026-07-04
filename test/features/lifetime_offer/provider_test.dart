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

      group('2年目以降（365日周期で毎年同じ時期に表示される）', () {
        test('利用日数が700日（2年目の開始境界と同値: 700 % 365 = 335）の場合は表示されない', () async {
          expect(await readShouldShowLifetimeOffer(usageDays: 700), isFalse);
        });

        test('利用日数が701日（2年目の開始境界+1: 701 % 365 = 336）の場合は表示される', () async {
          expect(await readShouldShowLifetimeOffer(usageDays: 701), isTrue);
        });

        test('利用日数が719日（2年目の終了境界-1: 719 % 365 = 354）の場合は表示される', () async {
          expect(await readShouldShowLifetimeOffer(usageDays: 719), isTrue);
        });

        test('利用日数が720日（2年目の終了境界と同値: 720 % 365 = 355）の場合は表示されない', () async {
          expect(await readShouldShowLifetimeOffer(usageDays: 720), isFalse);
        });

        test('利用日数が1066日（3年目: 1066 % 365 = 336）の場合は表示される', () async {
          expect(await readShouldShowLifetimeOffer(usageDays: 1066), isTrue);
        });

        test('利用日数が400日（2年目だが周期内の日数が範囲外: 400 % 365 = 35）の場合は表示されない', () async {
          expect(await readShouldShowLifetimeOffer(usageDays: 400), isFalse);
        });
      });
    });

    group('利用日数以外の表示条件', () {
      // 表示対象の利用日数（340日）で、利用日数以外の条件を1つずつ崩して検証する
      Future<bool> readShouldShowLifetimeOffer({
        RemoteConfigParameter? remoteConfigParameter,
        FutureOr<bool>? isLifetimePurchased = false,
        bool isLifetimePurchasedThrows = false,
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
            isLifetimePurchasedProvider.overrideWith((ref) =>
                isLifetimePurchasedThrows
                    ? throw Exception('failed to fetch customer info')
                    : isLifetimePurchased!),
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

      test('買い切り購入状態の取得がエラーの場合は表示されない', () async {
        expect(
          await readShouldShowLifetimeOffer(isLifetimePurchasedThrows: true),
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
      // 表示期限以外の表示条件をすべて満たした状態で、初回表示時刻と現在時刻(tick)を操作して判定結果を返す。
      // firstDisplayedDateTimeは firstDisplayedCycle の周期番号付きキーに保存する
      Future<bool> readShouldShowLifetimeOffer({
        required String? firstDisplayedDateTime,
        required DateTime tick,
        int firstDisplayedCycle = 0,
        int usageDays = 340,
        int lifetimeOfferDurationHours =
            RemoteConfigParameterDefaultValues.lifetimeOfferDurationHours,
      }) async {
        final mockTodayRepository = MockTodayService();
        when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
        todayRepository = mockTodayRepository;

        SharedPreferences.setMockInitialValues({
          if (firstDisplayedDateTime != null)
            lifetimeOfferFirstDisplayedDateTimeKey(cycle: firstDisplayedCycle):
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

      test('前周期（1年目）の初回表示時刻は今周期（2年目）の表示期限に影響しない', () async {
        // 1年目のキー(_0)に期限切れの初回表示時刻が残っていても、2年目(usageDays: 705 → cycle 1)では未表示扱いになる
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime:
                DateTime(2025, 7, 1, 9, 0, 0).toIso8601String(),
            firstDisplayedCycle: 0,
            usageDays: 705,
            tick: DateTime(2026, 7, 3, 9, 0, 0),
          ),
          isTrue,
        );
      });

      test('今周期（2年目）の初回表示時刻が期限切れの場合は表示されない', () async {
        expect(
          await readShouldShowLifetimeOffer(
            firstDisplayedDateTime:
                DateTime(2026, 7, 1, 9, 0, 0).toIso8601String(),
            firstDisplayedCycle: 1,
            usageDays: 705,
            tick: DateTime(2026, 7, 3, 9, 0, 0),
          ),
          isFalse,
        );
      });
    });
  });

  group('#lifetimeOfferDeadlineProvider', () {
    // 初回表示時刻（firstDisplayedCycleの周期番号付きキーに保存）とRemote Configの表示期間を操作して表示期限を返す
    Future<DateTime?> readDeadline({
      required String? firstDisplayedDateTime,
      int firstDisplayedCycle = 0,
      int usageDays = 340,
      int lifetimeOfferDurationHours =
          RemoteConfigParameterDefaultValues.lifetimeOfferDurationHours,
    }) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        if (firstDisplayedDateTime != null)
          lifetimeOfferFirstDisplayedDateTimeKey(cycle: firstDisplayedCycle):
              firstDisplayedDateTime,
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
          container.listen(lifetimeOfferDeadlineProvider, (_, __) {});
      await container.read(firebaseUserStateProvider.future);
      return subscription.read();
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

    test('前周期（1年目）の初回表示時刻は参照せず、今周期（2年目）が未表示ならnullを返す', () async {
      expect(
        await readDeadline(
          firstDisplayedDateTime:
              DateTime(2025, 7, 1, 9, 0, 0).toIso8601String(),
          firstDisplayedCycle: 0,
          usageDays: 705,
        ),
        isNull,
      );
    });

    test('今周期（2年目）の初回表示時刻から期限を返す', () async {
      expect(
        await readDeadline(
          firstDisplayedDateTime:
              DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
          firstDisplayedCycle: 1,
          usageDays: 705,
        ),
        DateTime(2026, 7, 3, 9, 0, 0),
      );
    });
  });

  group('#lifetimeOfferRemainingDurationProvider', () {
    // 初回表示時刻（周期0のキーに保存）と現在時刻(tick)を操作して残り時間を返す
    Future<Duration> readRemainingDuration({
      required String? firstDisplayedDateTime,
      required DateTime tick,
    }) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        if (firstDisplayedDateTime != null)
          lifetimeOfferFirstDisplayedDateTimeKey(cycle: 0):
              firstDisplayedDateTime,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          tickProvider.overrideWith(() => FakeTick(fakeDateTime: tick)),
          remoteConfigParameterProvider
              .overrideWithValue(RemoteConfigParameter()),
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
          container.listen(lifetimeOfferRemainingDurationProvider, (_, __) {});
      await container.read(firebaseUserStateProvider.future);
      return subscription.read();
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
