import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/native/channel.dart';

Future<bool> isHealthDataAvailable() async {
  if (!Platform.isIOS) {
    return false;
  }

  final result = await methodChannel.invokeMethod("isHealthDataAvailable");
  return result["isHealthDataAvailable"] == true;
}

Future<bool> healthKitRequestAuthorizationIsUnnecessary() async {
  if (!Platform.isIOS) {
    throw const FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw const FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }

  final result = await methodChannel.invokeMethod("healthKitRequestAuthorizationIsUnnecessary");
  return result["healthKitRequestAuthorizationIsUnnecessary"] == true;
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
    throw AlertError(response["reason"]);
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
    throw AlertError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<String> addMenstruationFlowHealthKitData(
  Menstruation menstruation,
) async {
  if (!Platform.isIOS) {
    throw const FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw const FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }
  if (!await healthKitRequestAuthorizationIsUnnecessary()) {
    throw const FormatException("設定アプリよりヘルスケアを有効にしてください");
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

  dynamic response = await methodChannel.invokeMethod("addMenstruationFlowHealthKitData", {
    "menstruation": json,
  });

  if (response["result"] == "success") {
    return response["healthKitSampleDataUUID"] as String;
  } else if (response["result"] == "failure") {
    throw AlertError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<String> updateOrAddMenstruationFlowHealthKitData(
  Menstruation menstruation,
) async {
  if (!Platform.isIOS) {
    throw const FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw const FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }
  if (!await healthKitRequestAuthorizationIsUnnecessary()) {
    throw const FormatException("設定アプリよりヘルスケアを有効にしてください");
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

  dynamic response = await methodChannel.invokeMethod("updateOrAddMenstruationFlowHealthKitData", {
    "menstruation": json,
  });

  if (response["result"] == "success") {
    return response["healthKitSampleDataUUID"] as String;
  } else if (response["result"] == "failure") {
    throw AlertError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}

Future<void> deleteMenstruationFlowHealthKitData(
  Menstruation menstruation,
) async {
  if (!Platform.isIOS) {
    throw const FormatException("iOSアプリにのみ対応しています");
  }
  if (!await isHealthDataAvailable()) {
    throw const FormatException("ヘルスケアに対応していない端末ではご利用できません");
  }
  if (!await healthKitRequestAuthorizationIsUnnecessary()) {
    throw const FormatException("設定アプリよりヘルスケアを有効にしてください");
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

  dynamic response = await methodChannel.invokeMethod("deleteMenstrualFlowHealthKitData", {
    "menstruation": json,
  });

  if (response["result"] == "success") {
    return;
  } else if (response["result"] == "failure") {
    throw AlertError(response["reason"]);
  } else {
    throw Exception("unknown error");
  }
}
