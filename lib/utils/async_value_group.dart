import 'package:riverpod/riverpod.dart';

/// AsyncValueGroup - 複数のAsyncValueを組み合わせるヘルパー
/// Riverpod 3.xへの移行に伴い、async_value_groupパッケージの代替として実装
class AsyncValueGroup {
  static AsyncValue<(T1, T2)> group2<T1, T2>(AsyncValue<T1> v1, AsyncValue<T2> v2) {
    if (v1 is AsyncLoading || v2 is AsyncLoading) {
      return const AsyncLoading();
    }
    if (v1 is AsyncError) {
      return AsyncError(v1.error!, v1.stackTrace!);
    }
    if (v2 is AsyncError) {
      return AsyncError(v2.error!, v2.stackTrace!);
    }
    return AsyncData((v1.value as T1, v2.value as T2));
  }

  static AsyncValue<(T1, T2, T3)> group3<T1, T2, T3>(AsyncValue<T1> v1, AsyncValue<T2> v2, AsyncValue<T3> v3) {
    if (v1 is AsyncLoading || v2 is AsyncLoading || v3 is AsyncLoading) {
      return const AsyncLoading();
    }
    if (v1 is AsyncError) {
      return AsyncError(v1.error!, v1.stackTrace!);
    }
    if (v2 is AsyncError) {
      return AsyncError(v2.error!, v2.stackTrace!);
    }
    if (v3 is AsyncError) {
      return AsyncError(v3.error!, v3.stackTrace!);
    }
    return AsyncData((v1.value as T1, v2.value as T2, v3.value as T3));
  }

  static AsyncValue<(T1, T2, T3, T4)> group4<T1, T2, T3, T4>(AsyncValue<T1> v1, AsyncValue<T2> v2, AsyncValue<T3> v3, AsyncValue<T4> v4) {
    if (v1 is AsyncLoading || v2 is AsyncLoading || v3 is AsyncLoading || v4 is AsyncLoading) {
      return const AsyncLoading();
    }
    if (v1 is AsyncError) {
      return AsyncError(v1.error!, v1.stackTrace!);
    }
    if (v2 is AsyncError) {
      return AsyncError(v2.error!, v2.stackTrace!);
    }
    if (v3 is AsyncError) {
      return AsyncError(v3.error!, v3.stackTrace!);
    }
    if (v4 is AsyncError) {
      return AsyncError(v4.error!, v4.stackTrace!);
    }
    return AsyncData((v1.value as T1, v2.value as T2, v3.value as T3, v4.value as T4));
  }

  static AsyncValue<(T1, T2, T3, T4, T5, T6)> group6<T1, T2, T3, T4, T5, T6>(
    AsyncValue<T1> v1,
    AsyncValue<T2> v2,
    AsyncValue<T3> v3,
    AsyncValue<T4> v4,
    AsyncValue<T5> v5,
    AsyncValue<T6> v6,
  ) {
    if (v1 is AsyncLoading || v2 is AsyncLoading || v3 is AsyncLoading || v4 is AsyncLoading || v5 is AsyncLoading || v6 is AsyncLoading) {
      return const AsyncLoading();
    }
    if (v1 is AsyncError) {
      return AsyncError(v1.error!, v1.stackTrace!);
    }
    if (v2 is AsyncError) {
      return AsyncError(v2.error!, v2.stackTrace!);
    }
    if (v3 is AsyncError) {
      return AsyncError(v3.error!, v3.stackTrace!);
    }
    if (v4 is AsyncError) {
      return AsyncError(v4.error!, v4.stackTrace!);
    }
    if (v5 is AsyncError) {
      return AsyncError(v5.error!, v5.stackTrace!);
    }
    if (v6 is AsyncError) {
      return AsyncError(v6.error!, v6.stackTrace!);
    }
    return AsyncData((v1.value as T1, v2.value as T2, v3.value as T3, v4.value as T4, v5.value as T5, v6.value as T6));
  }

  static AsyncValue<(T1, T2, T3, T4, T5, T6, T7, T8, T9, T10)> group10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
    AsyncValue<T1> v1,
    AsyncValue<T2> v2,
    AsyncValue<T3> v3,
    AsyncValue<T4> v4,
    AsyncValue<T5> v5,
    AsyncValue<T6> v6,
    AsyncValue<T7> v7,
    AsyncValue<T8> v8,
    AsyncValue<T9> v9,
    AsyncValue<T10> v10,
  ) {
    if (v1 is AsyncLoading ||
        v2 is AsyncLoading ||
        v3 is AsyncLoading ||
        v4 is AsyncLoading ||
        v5 is AsyncLoading ||
        v6 is AsyncLoading ||
        v7 is AsyncLoading ||
        v8 is AsyncLoading ||
        v9 is AsyncLoading ||
        v10 is AsyncLoading) {
      return const AsyncLoading();
    }
    if (v1 is AsyncError) {
      return AsyncError(v1.error!, v1.stackTrace!);
    }
    if (v2 is AsyncError) {
      return AsyncError(v2.error!, v2.stackTrace!);
    }
    if (v3 is AsyncError) {
      return AsyncError(v3.error!, v3.stackTrace!);
    }
    if (v4 is AsyncError) {
      return AsyncError(v4.error!, v4.stackTrace!);
    }
    if (v5 is AsyncError) {
      return AsyncError(v5.error!, v5.stackTrace!);
    }
    if (v6 is AsyncError) {
      return AsyncError(v6.error!, v6.stackTrace!);
    }
    if (v7 is AsyncError) {
      return AsyncError(v7.error!, v7.stackTrace!);
    }
    if (v8 is AsyncError) {
      return AsyncError(v8.error!, v8.stackTrace!);
    }
    if (v9 is AsyncError) {
      return AsyncError(v9.error!, v9.stackTrace!);
    }
    if (v10 is AsyncError) {
      return AsyncError(v10.error!, v10.stackTrace!);
    }
    return AsyncData((
      v1.value as T1,
      v2.value as T2,
      v3.value as T3,
      v4.value as T4,
      v5.value as T5,
      v6.value as T6,
      v7.value as T7,
      v8.value as T8,
      v9.value as T9,
      v10.value as T10,
    ));
  }
}
