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

  test('フランス語ARBが完全で重要文言がフランス語になっている', () {
    final french = _readArb(File('${arbDirectory.path}/app_fr.arb'));
    expect(french['@@locale'], 'fr');
    expect(_messageKeys(french), templateKeys);

    // 訳文の字句は translate-app-arb skill の再翻訳で変わるため、特定の訳語に固定せず
    // 「空でなく日本語が残っていない」ことだけを検査する
    final japanese = RegExp(r'[ぁ-んァ-ヶ一-龯]');
    for (final key in _messageKeys(french)) {
      expect(french[key] as String, isNotEmpty, reason: key);
      expect(french[key] as String, isNot(matches(japanese)), reason: key);
    }
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
