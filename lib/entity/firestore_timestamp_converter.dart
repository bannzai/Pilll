import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  static Timestamp? dateTimeToTimestamp(DateTime? dateTime) =>
      dateTime == null ? null : Timestamp.fromDate(dateTime);
  static DateTime? timestampToDateTime(Timestamp? timestamp) =>
      timestamp?.toDate();
}

class NonNullTimestampConverter {
  static Timestamp dateTimeToTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
  static DateTime timestampToDateTime(Timestamp timestamp) =>
      timestamp.toDate();
}
