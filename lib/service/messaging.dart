import 'package:firebase_messaging/firebase_messaging.dart';

class Messaging {
  // Only Apple Platfroms
  Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void listenNotificationEvents() {
    
  }
}

final messaging = Messaging();
