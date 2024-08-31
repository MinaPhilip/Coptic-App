import 'package:elkeraza/service/topic_maneger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTopicView extends StatefulWidget {
  @override
  _NotificationTopicViewState createState() => _NotificationTopicViewState();
}

class _NotificationTopicViewState extends State<NotificationTopicView> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<String?> _getSavedTopic() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('topic');
  }

  void _sendNotification() {
    final title = _titleController.text;
    final body = _bodyController.text;

    // Simple validation
    if (title.isEmpty || body.isEmpty) {
      setState(() {
        _errorMessage = 'Both fields are required';
      });
      return;
    }

    // Clear the error message
    setState(() {
      _errorMessage = null;
    });

    // Call your method to send the notification here
    print('Title: $title');
    print('Body: $body');

    // For demonstration, we'll show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification Sent: $title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDB47E),
        title: const Text('ارسال اشعارات للمخدومين',
            style: TextStyle(color: Colors.black, fontFamily: 'mainfont')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: const OutlineInputBorder(),
                errorText:
                    _errorMessage == null || _titleController.text.isNotEmpty
                        ? null
                        : 'Please enter a title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
                border: const OutlineInputBorder(),
                errorText:
                    _errorMessage == null || _bodyController.text.isNotEmpty
                        ? null
                        : 'Please enter a body',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                TopicManager.sendNotificationToTopic(
                    context,
                    await _getSavedTopic(),
                    _titleController.text,
                    _bodyController.text);
              },
              child: const Text('ارسل الاشعار',
                  style: TextStyle(
                      fontFamily: 'mainfont',
                      color: Colors.black,
                      fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
