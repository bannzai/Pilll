import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final arbDirectory = Directory('lib/l10n');
  final template = _readArb(File('${arbDirectory.path}/app_ja.arb'));
  final templateKeys = _messageKeys(template);

  test('全ARBのメッセージキーとプレースホルダーがテンプレートと一致する', () {
    final files = arbDirectory
        .listSync()
        .whereType<File>()
        .where((file) => RegExp(r'app_[A-Za-z_-]+\.arb$').hasMatch(file.path))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    expect(files, isNotEmpty);
    for (final file in files) {
      final arb = _readArb(file);
      expect(_messageKeys(arb), containsAll(templateKeys), reason: file.path);
      for (final key in templateKeys) {
        expect(
          _placeholders(arb[key] as String),
          _placeholders(template[key] as String),
          reason: '${file.path}: $key',
        );
      }
    }
  });

  test('全ARBの訳文が空でなく日本語の原文が混ざっていない', () {
    // 訳文の字句は translate-app-arb skill の再翻訳で変わるため、特定の訳語に固定せず
    // 「空でなく日本語が残っていない」ことだけを全言語で検査する。
    // 中国語は漢字を共有するため、かなだけを日本語の混入とみなす
    final kana = RegExp(r'[ぁ-んァ-ヶ]');
    final kanaOrKanji = RegExp(r'[ぁ-んァ-ヶ一-龯]');
    final files = arbDirectory
        .listSync()
        .whereType<File>()
        .where((file) => RegExp(r'app_[A-Za-z_-]+\.arb$').hasMatch(file.path))
        .where((file) => !file.path.endsWith('app_ja.arb'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    expect(files, isNotEmpty);
    for (final file in files) {
      final arb = _readArb(file);
      final japanese = arb['@@locale'] == 'zh' ? kana : kanaOrKanji;
      for (final key in templateKeys) {
        expect(arb[key] as String, isNotEmpty, reason: '${file.path}: $key');
        expect(arb[key] as String, isNot(matches(japanese)),
            reason: '${file.path}: $key');
      }
    }
  });

  group('#pauseTakingFromNumber', () {
    test('withNumber の結果を埋め込んだ時に番号の接頭辞・接尾辞が二重にならない', () {
      // 服用お休みダイアログのタイトルは L.pauseTakingFromNumber(L.withNumber(...)) で組み立てるため、
      // withNumber の {number} の前後の文字列が pauseTakingFromNumber の {number} の前後にも続くと
      // 「pill Pill 1」「1번번」のように重なる。
      // 「nomor」と「No.」のように綴りの違う同義語の重なりは文字列では判定できないため対象外
      final files = arbDirectory
          .listSync()
          .whereType<File>()
          .where((file) => RegExp(r'app_[A-Za-z_-]+\.arb$').hasMatch(file.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

      expect(files, isNotEmpty);
      for (final file in files) {
        final arb = _readArb(file);
        final withNumber = (arb['withNumber'] as String).toLowerCase().split('{number}');
        final pauseTakingFromNumber = (arb['pauseTakingFromNumber'] as String).toLowerCase().split('{number}');
        final withNumberPrefix = withNumber.first.trim();
        final withNumberSuffix = withNumber.last.trim();
        if (withNumberPrefix.isNotEmpty) {
          expect(pauseTakingFromNumber.first.trim(), isNot(endsWith(withNumberPrefix)), reason: file.path);
        }
        if (withNumberSuffix.isNotEmpty) {
          expect(pauseTakingFromNumber.last.trim(), isNot(startsWith(withNumberSuffix)), reason: file.path);
        }
      }
    });
  });
}

Map<String, dynamic> _readArb(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

Set<String> _placeholders(String message) =>
    RegExp(r'\{([A-Za-z][A-Za-z0-9_]*)\}')
        .allMatches(message)
        .map((match) => match.group(1)!)
        .toSet();
