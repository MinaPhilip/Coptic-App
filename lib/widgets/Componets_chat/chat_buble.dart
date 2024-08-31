import 'package:flutter/material.dart';
import '../../Model/message_model.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.message,
  });

  final Message message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              message.name!,
              style: const TextStyle(
                  fontFamily: 'mainfont',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(164, 0, 0, 0),
                  fontSize: 15),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
              color: Colors.white,
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'mainfont',
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatBubleForFriend extends StatelessWidget {
  const ChatBubleForFriend({
    super.key,
    required this.message,
  });

  final Message message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              message.name!,
              style: const TextStyle(
                  fontFamily: 'mainfont',
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(164, 0, 0, 0),
                  fontSize: 15),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding:
                const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
              color: Colors.black,
            ),
            child: Text(
              message.message,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'mainfont',
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
