import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/native/channel.dart';

Future<bool> isHealthDataAvailable() async {
  if (!Platform.isIOS) {
    return false;
  }

  final result = await methodChannel.invokeMethod("isHealthDataAvailable");
  return result["isHealthDataAvailable"] == true;
}

Future<String> addMenstruationFlowHealthKitData(
  Menstruation menstruation,
) async {
  if (!Platform.isIOS) {
    throw FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }

// Avoid codec error
// e.g) Unhandled Exception: Invalid argument: Instance of 'Timestamp'
  var json = menstruation.toJson();
  for (final key in json.keys) {
    final value = json[key];
    if (value is Timestamp) {
      json[key] = value.toDate().millisecondsSinceEpoch;
    }
  }

  dynamic response =
      await methodChannel.invokeMethod("addMenstruationFlowHealthKitData", {
    "menstruation": json,
  });

  if (response["result"] == "success") {
    return response["healthKitSampleDataUUID"] as String;
  } else if (response["result"] == "failure") {
    throw UserDisplayedError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<bool> isAuthorizedReadAndShareToHealthKitData() async {
  if (!Platform.isIOS) {
    throw FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }

  final result = await methodChannel
      .invokeMethod("isAuthorizedReadAndShareToHealthKitData");
  return result["isAuthorizedReadAndShareToHealthKitData"] == true;
}

Future<String> updateOrAddMenstruationFlowHealthKitData(
  Menstruation menstruation,
) async {
  if (!Platform.isIOS) {
    throw FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }

// Avoid codec error
// e.g) Unhandled Exception: Invalid argument: Instance of 'Timestamp'
  var json = menstruation.toJson();
  for (final key in json.keys) {
    final value = json[key];
    if (value is Timestamp) {
      json[key] = value.toDate().millisecondsSinceEpoch;
    }
  }

  dynamic response = await methodChannel
      .invokeMethod("updateOrAddMenstruationFlowHealthKitData", {
    "menstruation": json,
  });

  if (response["result"] == "success") {
    return response["healthKitSampleDataUUID"] as String;
  } else if (response["result"] == "failure") {
    throw UserDisplayedError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<void> deleteMenstruationFlowHealthKitData(
  Menstruation menstruation,
) async {
  if (!Platform.isIOS) {
    throw FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }

// Avoid codec error
// e.g) Unhandled Exception: Invalid argument: Instance of 'Timestamp'
  var json = menstruation.toJson();
  for (final key in json.keys) {
    final value = json[key];
    if (value is Timestamp) {
      json[key] = value.toDate().millisecondsSinceEpoch;
    }
  }

  dynamic response =
      await methodChannel.invokeMethod("deleteMenstrualFlowHealthKitData", {
    "menstruation": json,
  });

  if (response["result"] == "success") {
    return;
  } else if (response["result"] == "failure") {
    throw UserDisplayedError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<bool> shouldRequestForAccessToHealthKitData() async {
  if (!Platform.isIOS) {
    return false;
  }
  if (!await isHealthDataAvailable()) {
    return false;
  }

  dynamic response = await methodChannel.invokeMethod(
    "shouldRequestForAccessToHealthKitData",
  );

  if (response["result"] == "success") {
    return response["shouldRequestForAccessToHealthKitData"] == true;
  } else if (response["result"] == "failure") {
    throw UserDisplayedError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<bool> requestWriteMenstrualFlowHealthKitDataPermission() async {
  if (!Platform.isIOS) {
    return false;
  }
  if (!await isHealthDataAvailable()) {
    return false;
  }

  dynamic response = await methodChannel.invokeMethod(
    "requestWriteMenstrualFlowHealthKitDataPermission",
  );

  if (response["result"] == "success") {
    return response["isSuccess"] == true;
  } else if (response["result"] == "failure") {
    throw UserDisplayedError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}
