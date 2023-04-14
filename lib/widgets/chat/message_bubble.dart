import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final Timestamp createdAt;
  final bool isMe;

  const MessageBubble(
      {Key? key,
      required this.msg,
      required this.createdAt,
      required this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          width: 290,
          decoration: BoxDecoration(
            color: isMe
                ? Colors.indigoAccent.shade200.withOpacity(0.7)
                : Colors.white70,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                msg,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color:
                        isMe ? Colors.white.withOpacity(0.85) : Colors.black87),
              ),
              Text(
                // createdAt.toString(),
                DateTime.now().hour.toString(),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
