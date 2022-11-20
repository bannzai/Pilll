import 'package:firebase_auth/firebase_auth.dart';

class LinkValueContainer {
  final UserCredential credential;
  final String? email;

  LinkValueContainer(this.credential, this.email);
}
