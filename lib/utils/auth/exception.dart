import 'package:firebase_auth/firebase_auth.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/features/error/alert_error.dart';
import 'package:pilll/features/localizations/l.dart';

Exception? mapFromFirebaseAuthException(FirebaseAuthException e, LinkAccountType accountType) {
  if (e.code == 'provider-already-linked') {
    throw AlertError(
      L.accountAlreadyLinked(accountType.providerName, e.message ?? ''),
      faqLinkURL: 'https://pilll.notion.site/a8d3c745e58c40f0b8b771bb70f7a7d1',
    );
  }
  if (e.code == 'credential-already-in-use') {
    throw AlertError(
      L.accountAlreadyLinkedWithOtherPilllAccount(accountType.providerName, e.message ?? ''),
      faqLinkURL: 'https://pilll.notion.site/a8d3c745e58c40f0b8b771bb70f7a7d1',
    );
  }
  if (e.code == 'email-already-in-use') {
    throw AlertError(
      L.emailAlreadyInUse(accountType.providerName, e.message ?? ''),
      faqLinkURL: 'https://pilll.notion.site/a8d3c745e58c40f0b8b771bb70f7a7d1',
    );
  }
  return null;
}
