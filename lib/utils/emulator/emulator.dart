import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

void connectToEmulator() {
  final domain = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false, host: '$domain:8080', sslEnabled: false);
}
