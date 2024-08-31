import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
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

  static Future<String> getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "coptic-app-c115f",
  "private_key_id": "b28d923f86682ecfbe2694ef10a430d5dac54e81",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQChPySnAF16glfZ\nZA3wkRh+2sXD63tFpsOkRqN+H7ruFy4Zwy99LSrpxZAW8XXw83+mnMV/tF1i15kg\nKb0uHKoY6G5KFRZGqj8ikFcsjxwoF8sgKo5wFCFMWMqOyjFJCg6nAKdPo7U8cYbN\ndx3FcjJVB1PN5qG2G6bB9ANLfviGvPZqbiEgCZto20zrRLhOZ9DvimYbv+tJC/hG\nYZ9MhnHr68g/Iv140qc42il1/bIPk9zMWG/0ueaRxk41JRvqQ3+Qz5R3vmXhftzk\npeCeBOvAbeHq4sgx0w1lnl7cTlAMZpEIKoffyRbEDos98tljV0QH4E4x9l79Kkyq\nmWhbS/x5AgMBAAECggEATfz9y74L+FBpj+3qJhPvbo9+fnt69F2rm11E/x/2p+hT\nNkemxNrfOhEBV29y1VbYQyvpBBKm5kMTvzAg3Vgk1wY4LaGUVBpMjfmVCCqxehzD\n9GtQ2BmMX2JEmhpmCwcPvis9QPITmsfn5KF7pz9L4783A8vMJAmstntASrf/GR8v\nHgk/j/1/q4tf3cI671cFTmanRZWU7VI/52166Iqw1oioqtZjbPzDqgXfEJjQEcSX\nD+FoYSiHMz66lKeCmVT7iwkPilZUChgEGHSTw/eIBMWKKtvLtr0dlrZFv2AuE4Sz\nuN6VV6cwSqnOU2qfe3tqKsOIZgAU2qnb8O3I4GEvrwKBgQDjhKBDAAOh2Cu1GPfF\n9JtZOBZwkniQjRYAuuc/YTTcp+n+SC+KwssSUYgeIwuMgKaVndzFDsna8+Pn+QNU\n4GVYEDEKqcDDk3Feh0abEKZY3ISI28L9hvGFbMu7qc+/1IDPpqBJGI+Jxgpf3vcd\nE28+lg9eqZoCa7Fyurf07BFNhwKBgQC1bq/tiGfUo8g14fGU2bAhbwAZNzMzJx/a\nZmBQSpMI5Z1dsnzBh3SxHrpclZzyr0uq7cFkgh1iEmLhGOXs+XOzdAgOHsmfklmS\nPrFYhOg0+/E05/hpK2jKiNlzQT4MxSmjoZdPoKsHJOcyE56MJ/QXFPb+gHyMCPW8\nKlC0RBrl/wKBgQDJwkHwSGHwMufHh+WpeRoOC2vy1iDuZv7dFOGe1c/v4UPiyBbI\n4ab9jqm7t+404Z1YTo6JfWzJqsAvZSZsLTYR2wHyZ8jWZrkBT8rwFdq+MIejaebH\nttQVMv6UY6kkfwjfm+7GA26+iY2HqQzQjvx2rtHga1x0yxWoHSamnnVVnwKBgHzG\n8xdZiI8lVLw59/t2+zsDK/4riHrVnYKGhhayMw0bXW7jIgm3LvnhOCoUeywsgs27\nVhXZpnucSYSlqvufU4NHeYK8ic3EyPVbSHyoa0qFOw43uxAZWqhwFZy+cf42Wry+\nlWGeDgGLz7UQ6SlbEPQO5w+BLibgwp/2Oiq/6//hAoGAWlZWynBIQTMTa0l+tlYY\nvY134BhnYsg0f6q7kvSjR15v9ipKWDcwB7C4gSiKbQcI6IaA9Wvj3bsGgV4bZfw8\nBnYFSicTuIRrK1BbM/48twPZpFpV8+S94G1GpqxPEN1j0cEbGP/O6pOmkFTt3G1M\nxlojr1j6fk03vGg/vGfunVU=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-znjcr@coptic-app-c115f.iam.gserviceaccount.com",
  "client_id": "107986580029099309553",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-znjcr%40coptic-app-c115f.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''');

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = http.Client();
    final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
      accountCredentials,
      scopes,
      client,
    );

    return accessCredentials.accessToken.data;
  }

  static Future<void> sendNotificationToTopic(
    String? topic,
    String title,
    String body,
  ) async {
    final url =
        'https://fcm.googleapis.com/v1/projects/coptic-app-c115f/messages:send';

    final accessToken = await getAccessToken(); // Obtain the access token

    final Map<String, dynamic> message = {
      "message": {
        "topic": topic,
        "notification": {"title": title, "body": body},
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
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }
}
 // Replace with your server key