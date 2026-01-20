import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final dir = Directory('lib');
  final extractedStrings = <String, String>{};

  await for (final file in dir.list(recursive: true)) {
    if (file is File &&
        file.path.endsWith('.dart') &&
        !file.path.endsWith('.freezed.dart')) {
      final content = await file.readAsString();

      // Remove line breaks and unnecessary whitespaces
      final singleLineContent = content.replaceAll(RegExp(r'\s+'), ' ');

      // Extract strings following Text(, return , or text:
      final regex = RegExp(r"(Text\(|return |text:)\s*[']([^']+)[']");
      for (final match in regex.allMatches(singleLineContent)) {
        final extractedString = match.group(2);
        if (extractedString != null) {
          // Use the extracted string as the key and value for simplicity
          extractedStrings[extractedString] = extractedString;
        }
      }
    }
  }

  // Save the extracted strings in AppLocalizations format JSON
  final jsonContent = jsonEncode(extractedStrings);
  final outputFile = File('lib/l10n/app_localizations.json');
  await outputFile.writeAsString(jsonContent);

  print('Extracted strings saved to lib/l10n/app_localizations.json');
}
