import 'dart:io';

import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';

const _limits = <String, int>{
  'name.txt': 30,
  'subtitle.txt': 30,
  'keywords.txt': 100,
  'promotional_text.txt': 170,
  'description.txt': 4000,
};

void main() {
  final root = Directory('fastlane/metadata');
  final expected = allStoreScreenshotLocales.toSet();
  final actual =
      root.listSync().whereType<Directory>().map((directory) => directory.uri.pathSegments.where((segment) => segment.isNotEmpty).last).toSet();
  final errors = <String>[];

  if (actual.difference(expected).isNotEmpty || expected.difference(actual).isNotEmpty) {
    errors.add(
        'ロケール不一致: expected=${expected.length}, actual=${actual.length}, missing=${expected.difference(actual)}, extra=${actual.difference(expected)}');
  }

  for (final locale in expected) {
    for (final entry in _limits.entries) {
      final file = File('${root.path}/$locale/${entry.key}');
      if (!file.existsSync()) {
        errors.add('欠落: ${file.path}');
        continue;
      }
      final value = file.readAsStringSync().trim();
      final length = value.runes.length;
      // promotional_text は ASC 上も任意項目のため空を許容する
      // （ja はライブ値が未設定のまま維持する方針。他は必須扱いのまま）。
      final allowEmpty = entry.key == 'promotional_text.txt';
      if ((value.isEmpty && !allowEmpty) || length > entry.value) {
        errors.add('文字数NG: ${file.path} ($length / ${entry.value})');
      }
      if (locale != 'ja' && RegExp(r'[ぁ-んァ-ヶ]').hasMatch(value)) {
        errors.add('日本語かな混入: ${file.path}');
      }
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln(errors.join('\n'));
    exitCode = 1;
    return;
  }
  stdout.writeln('metadata OK: ${expected.length} locales × ${_limits.length} files');
}
