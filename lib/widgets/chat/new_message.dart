import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = TextEditingController();

  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(bottom: 25, top: 15, left: 20, right: 20),
      color: Colors.indigoAccent.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Send a message...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              // onSubmitted: (_) {
              //   setState(() {
              //     _enteredMessage.trim().isEmpty ? null : _sendMessage;
              //   });
              // },
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
