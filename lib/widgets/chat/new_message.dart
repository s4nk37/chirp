import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import '../../api_key.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'userName': userData.data()!['username'],
      'userImage': userData.data()!['image_url']
    });

    Future<void> sendPushNotification() async {
      try {
        final body = {
          "to": "/topics/chats",
          "collapse_key": "chat",
          "notification": {
            "title": userData.data()!['username'],
            "body": _enteredMessage,
          },
          "topic": "chats",
        };

        await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'key=$fcmServerKey',
            },
            body: jsonEncode(body));
      } catch (e) {
        // print('\nsendPushNotificationE: $e');
      }
    }

    sendPushNotification();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(bottom: 17, top: 15, left: 20, right: 20),
      height: 70,
      color: Colors.indigo.shade400,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enableSuggestions: true,
              decoration: const InputDecoration(
                hintText: 'Send a message...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              onSubmitted: (value) {
                _enteredMessage.trim().isEmpty ? null : _sendMessage();
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
