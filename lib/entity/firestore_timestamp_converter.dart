import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TimestampConverter {
  static Timestamp dateTimeToTimestamp(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
  static DateTime timestampToDateTime(Timestamp timestamp) =>
      timestamp.toDate();
}
