import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    try {
      log('Notification received: ${message.notification?.title}');
      // Extract the image URL from the message
      String? imageUrl = message.notification?.android?.imageUrl;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        // Fetch the image
        final http.Response imageResponse = await http.get(Uri.parse(imageUrl));

        if (imageResponse.statusCode == 200) {
          // If the image is successfully fetched, display it in the notification
          BigPictureStyleInformation bigPictureStyleInformation =
              BigPictureStyleInformation(
            ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(imageResponse.bodyBytes),
            ),
            largeIcon: ByteArrayAndroidBitmap.fromBase64String(
              base64Encode(imageResponse.bodyBytes),
            ),
          );

          AndroidNotificationDetails android = AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: bigPictureStyleInformation,
            playSound: true,
            sound: RawResourceAndroidNotificationSound(
                'long_notification_sound'.split('.').first),
          );

          NotificationDetails details = NotificationDetails(android: android);

          await flutterLocalNotificationsPlugin.show(
            0,
            message.notification?.title,
            message.notification?.body,
            details,
          );
        } else {
          log('Failed to fetch image, status code: ${imageResponse.statusCode}');
          _showSimpleNotification(message);
        }
      } else {
        log('No valid image URL provided.');
        _showSimpleNotification(message);
      }
    } catch (e) {
      log('Error showing notification: $e');
      _showSimpleNotification(message);
    }
  }

// Fallback method to show a simple notification without an image
  static void _showSimpleNotification(RemoteMessage message) async {
    AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
          'long_notification_sound'.split('.').first),
    );

    NotificationDetails details = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'chat_channel_id',
      'Chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
