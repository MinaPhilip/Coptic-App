import 'package:elkeraza/helper/awesome_snackbar.dart';
import 'package:elkeraza/service/topic_maneger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationTokenView extends StatefulWidget {
  @override
  _NotificationTokenViewState createState() => _NotificationTokenViewState();
}

class _NotificationTokenViewState extends State<NotificationTokenView> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tokenController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDB47E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDB47E),
        title: const Text('ارسال اشعارات لمخدوم',
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
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'Token',
                border: const OutlineInputBorder(),
                errorText:
                    _errorMessage == null || _tokenController.text.isNotEmpty
                        ? null
                        : 'Please enter a title',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_tokenController.text.isEmpty ||
                    _titleController.text.isEmpty ||
                    _bodyController.text.isEmpty) {
                  showFailureSnackbar(
                      context, 'خطأ', 'الرجاء تعبئة جميع الحقول');
                } else {
                  TopicManager.sendNotificationToToken(
                      context,
                      _tokenController.text,
                      _titleController.text,
                      _bodyController.text);
                }
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
