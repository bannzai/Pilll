import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/provider/app_is_released.dart';

void main() {
  group('#appIsReleasedFromVersions', () {
    test('アプリバージョンとストアバージョンが一致する場合は公開済み(true)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202407.29.133308',
          storeVersion: '202407.29.133308',
        ),
        true,
      );
    });

    test('アプリバージョンがストアより古い場合は公開済み(true)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202407.29.133308',
          storeVersion: '202602.01.211552',
        ),
        true,
      );
    });

    test('アプリバージョンがストアより新しい場合は未リリース扱い(false)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202602.01.211552',
          storeVersion: '202407.29.133308',
        ),
        false,
      );
    });

    test('ストアバージョンがnullの場合(ストア取得失敗)は未リリース扱い(false)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202602.01.211552',
          storeVersion: null,
        ),
        false,
      );
    });

    test('patch境界: アプリがストアより1つだけ新しい場合は未リリース扱い(false)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202602.01.211552',
          storeVersion: '202602.01.211551',
        ),
        false,
      );
    });

    test('minor境界: 1日分進んだ新版は未リリース扱い(false)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202602.02.000000',
          storeVersion: '202602.01.999999',
        ),
        false,
      );
    });

    test('major境界: 月またぎの新版は未リリース扱い(false)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202603.01.000000',
          storeVersion: '202602.28.235959',
        ),
        false,
      );
    });

    test('アプリがminor1つ古い版の場合は公開済み(true)', () {
      expect(
        appIsReleasedFromVersions(
          appVersion: '202602.01.000000',
          storeVersion: '202602.02.000000',
        ),
        true,
      );
    });
  });
}
