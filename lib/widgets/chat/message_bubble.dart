import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final String userName;
  final String userImageUrl;
  final bool isMe;

  const MessageBubble(
      {Key? key,
      required this.msg,
      required this.userName,
      required this.isMe,
      required this.userImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMe)
          Container(
            margin: const EdgeInsets.only(left: 5.0, bottom: 10),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userImageUrl),
            ),
          ),
        Container(
          padding: EdgeInsets.only(
              top: 10, bottom: 2, left: 15, right: isMe ? 7 : 12),
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          width: 250,
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
            mainAxisAlignment: MainAxisAlignment.end,
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
                '~ $userName',
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
