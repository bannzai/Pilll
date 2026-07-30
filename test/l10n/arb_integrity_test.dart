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
    expect(french['pill'], 'Pilule');
    expect(french['todayPillToTake'], '💊 Pilule du jour');
    expect(french['menstruationScheduleDate'], 'Prochaines règles');
    expect(french['recordMenstruation'], 'Noter les règles');
    expect(french['menstruationFeatureAppealTitle'],
        'Suivez et prévoyez vos règles');

    final japanese = RegExp(r'[ぁ-んァ-ヶ一-龯]');
    for (final key in _messageKeys(french)) {
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
