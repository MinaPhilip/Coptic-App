import 'dart:convert';

import 'package:elkeraza/helper/awesome_snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopicManager {
  static Future<void> _saveTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> topics = prefs.getStringList('subscribedTopics') ?? [];
    if (!topics.contains(topic)) {
      topics.add(topic);
      await prefs.setStringList('subscribedTopics', topics);
    }
  }

  static String convertToTopicName(String arabicText) {
    // Mapping Arabic characters to Latin equivalents
    final Map<String, String> arabicToLatin = {
      'ا': 'a',
      'ب': 'b',
      'ت': 't',
      'ث': 'th',
      'ج': 'j',
      'ح': 'h',
      'خ': 'kh',
      'د': 'd',
      'ذ': 'dh',
      'ر': 'r',
      'ز': 'z',
      'س': 's',
      'ش': 'sh',
      'ص': 's',
      'ض': 'd',
      'ط': 't',
      'ظ': 'z',
      'ع': 'a',
      'غ': 'gh',
      'ف': 'f',
      'ق': 'q',
      'ك': 'k',
      'ل': 'l',
      'م': 'm',
      'ن': 'n',
      'هـ': 'h',
      'و': 'w',
      'ي': 'y',
      ' ': '_',
      'ـ': '',
    };

    // Transliterate Arabic text to Latin
    final transliteratedText = arabicText.split('').map((char) {
      return arabicToLatin[char] ?? char;
    }).join('');

    final topicName =
        transliteratedText.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

    return topicName;
  }

  static Future<void> subscribeToTopic(String topic) async {
    final topicName = convertToTopicName(topic);
    await FirebaseMessaging.instance.subscribeToTopic(topicName);
    await _saveTopic(topicName);
  }

  static Future<void> unsubscribeFromAllTopics() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> topics = prefs.getStringList('subscribedTopics') ?? [];

    for (String topic in topics) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }

    await prefs.remove('subscribedTopics');
  }

  static Future<void> sendNotificationToTopic(
    BuildContext context, // Add context to show the SnackBar
    String? topic,
    String title,
    String body,
  ) async {
    final url =
        'https://fcm.googleapis.com/v1/projects/coptic-app-c115f/messages:send';

    try {
      final accessToken =
          'ya29.a0AcM612wOkw7BWReXVc-XoxVUZqUf6aY9PlH1KFJk65ssX4QQ7DaKZ0E18U-isvr5VnpNmQb7cMq9jAjuN8yms5J5aQEx6dXSL_lQu7xnJOe-8EwH2Nqgg_d6EFi4TZ78YaNYG1bnTtMCM501fm89ZrlCbe7nhwX2Yno8ymFoIgaCgYKAZASARISFQHGX2MiWVjdKOEKOaV4Uel8Tn1cuw0177'; // Replace with your actual access token

      final Map<String, dynamic> message = {
        "message": {
          "topic": topic,
          "notification": {
            "title": title,
            "body": body,
          },
          "android": {
            "notification": {
              "sound": "long_notification_sound",
              "channel_id":
                  "channel_id" // NOTIFICATION CHANNEL ID WITH CUSTOM SOUND REFERENCE HERE
            }
          }
        }
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
        showSuccessSnackbar(context, 'نجح', 'تم الارسال بنجاح');
      } else {
        print('Failed to send notification: ${response.body}');
        // Show Snackbar for failure
        showFailureSnackbar(context, 'خطا', '${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
      // Show Snackbar for error
      showFailureSnackbar(context, 'خطا', '$e');
    }
  }
}
 // Replace with your server key