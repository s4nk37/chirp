import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return MediaQuery.removePadding(
          removeBottom: true,
          context: context,
          child: ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              msg: chatDocs[index]['text'],
              userName: chatDocs[index]['userName'],
              isMe: chatDocs[index]['userId'] ==
                  FirebaseAuth.instance.currentUser!.uid,
              key: ValueKey(chatDocs[index].id),
            ),
          ),
        );
      },
    );
  }
}
