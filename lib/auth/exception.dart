import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/entity/user_error.dart';

Exception? mapFromFirebaseAuthException(
    FirebaseAuthException e, LinkAccountType accountType) {
  if (e.code == "provider-already-linked")
    throw UserDisplayedError(
        "すでに${accountType.providerName}がPilllのアカウントに紐付いています。画面の更新をお試しください。詳細: ${e.message}");
  if (e.code == "credential-already-in-use")
    throw UserDisplayedError(
        "すでに${accountType.providerName}が他のPilllのアカウントに紐付いているため連携ができません。詳細: ${e.message}");
  if (e.code == "email-already-in-use")
    throw UserDisplayedError(
        "すでに${accountType.providerName}がでお使いのEmailが他のPilllアカウントに紐付いているため連携ができません。詳細: ${e.message}");
  return null;
}
