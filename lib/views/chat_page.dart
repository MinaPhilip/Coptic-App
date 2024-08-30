import 'package:elkeraza/service/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Model/message_model.dart';
import '../widgets/chat_buble.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final data = Get.arguments ?? [];

  @override
  void initState() {
    super.initState();

    if (data.isEmpty) {
      // If roomId is null or empty, handle the error (e.g., navigate back or show an alert)
      Get.snackbar('Error', 'Room ID is missing.');
      Get.back(); // Navigate back if roomId is not provided
    }
  }

  Future<String?> _getCurrentUserId() async {
    return data[3]; // Implement actual user retrieval
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final currentUserId = await _getCurrentUserId();
      if (currentUserId == null)
        return; // Handle the case where the user ID is not available
      await _firestore
          .collection(data[0])
          .doc(data[1])
          .collection('messages')
          .add({
        'text': _messageController.text,
        'senderId': currentUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'name': data[2], // Ensures timestamp is set
      });

      // Get the latest messages to decide whether to send a notification
      final messagesSnapshot = await _firestore
          .collection(data[0])
          .doc(data[1])
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        final latestMessage = messagesSnapshot.docs.first.data();
        final senderId = latestMessage['senderId'] as String;

        if (senderId != currentUserId) {
          LocalNotificationService.showNotification(
            'New Message',
            _messageController.text,
          );
        }
      }

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDB47E),
        title: Text(data[1],
            style:
                const TextStyle(color: Colors.black, fontFamily: 'mainfont')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection(data[0])
                  .doc(data[1])
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages found.'));
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((doc) {
                    final message = Message(
                      message: doc['text'],
                      senderId: doc['senderId'],
                      timestamp: doc['timestamp'] ?? Timestamp.now(),
                      name: doc['name'] ?? '', // Use a default if null
                    );

                    return message.senderId == data[3]
                        ? ChatBuble(message: message)
                        : ChatBubleForFriend(message: message);
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "اكتب رسالتك هنا",
                      hintStyle: TextStyle(
                          fontFamily: 'mainfont', color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      _sendMessage();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
