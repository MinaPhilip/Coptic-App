import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String senderId;
  final Timestamp timestamp;
  String? name;

  Message({
    this.name,
    required this.message,
    required this.senderId,
    required this.timestamp,
  });
}
