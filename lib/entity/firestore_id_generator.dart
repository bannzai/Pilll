```dart
import 'package:uuid/uuid.dart';

/// Firestoreドキュメント用の一意IDを生成するクラス
/// 
/// UUID v4形式のランダムな識別子を生成し、Firestore内の
/// 各ドキュメントが重複しない一意なIDを持つことを保証する。
/// Pilllアプリ内のピル服用記録、生理記録、日記などの
/// すべてのFirestoreドキュメントのID生成に使用される。
class FirestoreIDGenerator {
  /// UUID v4形式の一意な文字列IDを生成して返す
  /// 
  /// 128ビットのランダムな値を基にした標準的なUUID v4を生成する。
  /// 生成されたIDはFirestoreドキュメントの主キーとして使用される。
  String call() => const Uuid().v4();
}

/// FirestoreIDGeneratorのグローバルインスタンス
/// 
/// アプリ全体で統一されたID生成機能を提供する。
/// 各種Entityクラスでの新規ドキュメント作成時に使用される。
FirestoreIDGenerator firestoreIDGenerator = FirestoreIDGenerator();
```
