import 'package:cloud_firestore/cloud_firestore.dart';

/// FirestoreのTimestamp型とDartのDateTime型の相互変換を行うユーティリティクラス。
/// nullable な値の変換に対応しており、null値の場合は適切にnullを返します。
/// Pilllアプリでのピル服用記録、生理記録、日記記録等の日時データを
/// Firestoreに保存・取得する際に使用されます。
class TimestampConverter {
  /// nullable な DateTime を Firestore の Timestamp に変換します。
  /// [dateTime] が null の場合は null を返します。
  /// 日時データをFirestoreに保存する際に使用されます。
  static Timestamp? dateTimeToTimestamp(DateTime? dateTime) => dateTime == null ? null : Timestamp.fromDate(dateTime);

  /// nullable な Firestore の Timestamp を DateTime に変換します。
  /// [timestamp] が null の場合は null を返します。
  /// Firestoreから取得した日時データをDartで扱う際に使用されます。
  static DateTime? timestampToDateTime(Timestamp? timestamp) => timestamp?.toDate();
}

/// FirestoreのTimestamp型とDartのDateTime型の相互変換を行うユーティリティクラス。
/// non-nullable な値の変換に対応しており、必ず有効な値が存在することを前提とします。
/// 必須の日時データ（ピルシート開始日、生理開始日等）の変換に使用されます。
class NonNullTimestampConverter {
  /// non-nullable な DateTime を Firestore の Timestamp に変換します。
  /// 必ず有効な [dateTime] を受け取り、対応するTimestampを返します。
  /// 必須の日時データをFirestoreに保存する際に使用されます。
  static Timestamp dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);

  /// non-nullable な Firestore の Timestamp を DateTime に変換します。
  /// 必ず有効な [timestamp] を受け取り、対応するDateTimeを返します。
  /// Firestoreから取得した必須日時データをDartで扱う際に使用されます。
  static DateTime timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
}
