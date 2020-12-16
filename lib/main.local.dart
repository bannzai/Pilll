import 'dart:io';

import 'package:Pilll/entrypoint.dart';
import 'package:Pilll/util/environment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  Environment.flavor = Flavor.LOCAL;
  connectToEmulator();
  await entrypoint();
}

void connectToEmulator() {
  final domain = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: false, host: '$domain:8080', sslEnabled: false);
}
