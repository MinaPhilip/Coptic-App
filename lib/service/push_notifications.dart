import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notifications.dart';

String? fcmToken;

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future init() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      fcmToken = value;
      log(value!);
    });
    messaging.onTokenRefresh.listen((value) {
      fcmToken = value;
    });
    FirebaseMessaging.onBackgroundMessage(handlebackgroundMessage);
    //foreground
    handleForegroundMessage();
    await messaging.subscribeToTopic('all').then((val) {
      log('sub');
    });

    // messaging.unsubscribeFromTopic('all');
  }

  static Future<void> handlebackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'null');
  }

  static void handleForegroundMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        // show local notification
        LocalNotificationService.showBasicNotification(
          message,
        );
      },
    );
  }
}
