import 'package:firebase_messaging/firebase_messaging.dart';
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
}
