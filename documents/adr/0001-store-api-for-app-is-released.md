# 0001. ストアAPI駆動で `appIsReleased` を判定する

## Status

Accepted

## Context

`appIsReleased` プロバイダーは「このビルドが既にストアで公開済みか」を判定し、以下の2箇所で分岐に使われてきた:

- `lib/features/record/components/announcement_bar/announcement_bar.dart` — 未リリース版 × 非プレミアム × 本番 のとき AdMob 広告を表示
- `lib/provider/purchase.dart` (`lifetimeDiscountRateProvider`) — 未リリース版のとき生涯購入割引レート計算をスキップ

従来の実装 (`lib/utils/remote_config.dart`) は Firebase Remote Config の `releasedVersion` キーに登録された文字列と端末のアプリバージョンを比較する方式で、**リリースのたびに Firebase コンソールで手動更新が必要**だった。更新忘れが発生すると広告・割引計算の挙動が意図通りに切り替わらず、本番の収益・UX に影響する運用リスクを抱えていた。

「ストア = 真実の源」として、実際にストアに公開されているバージョンを直接取得して比較する自動化方式に切り替えることで、手動運用を廃止し Single Source of Truth を徹底したい。

## Decision

`new_version_plus: ^1.0.1` を採用し、`NewVersionPlus().getVersionStatus()` 経由で iOS (iTunes Search API) / Android (Google Play Store HTML) から現在の公開バージョン文字列を取得する。取得したバージョンを Pilll の既存 `Version.parse` / `isGreaterThan` で比較し、従来と同じ `!appVersion.isGreaterThan(storeVersion)` のセマンティクスを維持する。

設計上のポイント:

- **フォールバック**: ストア取得失敗時 (HTTP エラー / ネットワーク不通 / 例外 / タイムアウト / `VersionStatus == null`) は `false` (未リリース扱い) を返す。`errorLogger.recordError` で Crashlytics に記録する。本番ユーザーがオフラインの際は未リリース扱いとなるため非プレミアムユーザーにはAdMob広告が表示され割引計算はスキップされるが、ストア審査中の新版が誤ってリリース済み扱いされるよりは安全側と判断
- **Riverpod キャッシュ**: `@Riverpod(keepAlive: true)` で単発 fetch とする。画面遷移のたびに iTunes / Play Store を叩くのを避け、認証系プロバイダーなど既存の `keepAlive: true` パターンと整合
- **テスト容易性**: `@visibleForTesting bool appIsReleasedFromVersions({required String appVersion, required String? storeVersion})` を純粋関数として分離し、境界値 Unit Test を書けるようにする
- **国コード**: Pilll は日本配信のみのため `iOSAppStoreCountry: 'jp'` / `androidPlayStoreCountry: 'jp'` を固定指定する
- **`kDebugMode` はデバッグビルドで `true`**: デバッグビルドでは広告を出さない既存仕様を維持
- **RemoteConfig `releasedVersion` キーは完全削除**: `lib/utils/remote_config.dart` の `setDefaults` と `lib/entity/remote_config_parameter.codegen.dart` のキー定義・デフォルト値の両方から削除する。アプリ側が参照しなくなれば Firebase コンソール側キーの後始末はいつでも可能

### 選定候補の比較

| 候補 | 採否 | 理由 |
|---|---|---|
| **new_version_plus** | **採用** | `storeVersion` 文字列を直接取得する API がシンプル。iOS/Android 両対応 |
| upgrader | 不採用 | UI も含むフル装備で今回の用途 (バックエンドロジックのみ) にはやや過剰。`UpgraderAppStore` / `UpgraderPlayStore` は内部 API 寄りで利用に不安 |
| 自前実装 | 不採用 | iOS は iTunes Lookup API で十分簡単だが、Android の Play Store HTML スクレイピングの保守コストが大きい |

### 連鎖アップグレード

`new_version_plus: ^1.0.1` は `package_info_plus: ^9.0.0` を要求し、それが Android ビルド環境の引き上げを要求する。以下を一括で更新する:

| 項目 | 旧 | 新 |
|---|---|---|
| Gradle wrapper | 8.9 | **8.13** |
| Android Gradle Plugin | 8.7.3 | **8.12.1** |
| Kotlin | 2.1.20 | **2.2.0** |
| package_info_plus | ^8.0.2 | **^9.0.0** |

`package_info_plus` 8 → 9 の public API には変更がないため Dart コード側の追従は不要。

## Consequences

### Positive

- Firebase コンソールでのバージョン手動更新 (運用負荷・更新忘れリスク) が解消される
- 「ストア = 真実の源」となり Single Source of Truth が徹底される
- 新パッケージ (`new_version_plus`) は単一機能でメンテナンスされており、推移的依存も最小限
- Android ビルド環境が Gradle 8.13 / AGP 8.12.1 / Kotlin 2.2.0 に引き上がり、将来的な依存追従が楽になる

### Negative / Trade-off

- Android は Google Play Store の HTML スクレイピングに依存するため、Google 側の HTML 構造変更で壊れる可能性がある (その場合はフォールバックで `false` に倒れる + Crashlytics 検知 + `new_version_plus` アップデート対応)
- 本番ユーザーがオフライン時には未リリース扱いとなるため、非プレミアムユーザーにはAdMob広告が表示され割引計算はスキップされる。`keepAlive: true` により再起動または通信回復で復元される
- ストア審査通過直後〜ストア API 反映までのラグ (数時間程度) により、新版が短時間「未リリース扱い」になる可能性がある。従来の手動 RemoteConfig 更新と比べて運用コストとのトレードオフで許容する
- Gradle/AGP/Kotlin の連鎖アップグレードにより、Android ビルド環境全体に影響範囲が及ぶ。本 ADR で採用した各バージョン (Gradle 8.13 / AGP 8.12.1 / Kotlin 2.2.0) は既存プラグインと互換であることを `./gradlew --version` およびローカル `flutter build apk --debug` の `compileFlutterBuildDebug` 段階まで通ることで確認済み

### Rollback

`appIsReleasedProvider.overrideWith((ref) => Future.value(true))` で ProviderScope 経由でアプリ全体を「公開済み」に即時切り替え可能。または本 PR 全体を revert することで Gradle/AGP/Kotlin も含めて元に戻せる。
