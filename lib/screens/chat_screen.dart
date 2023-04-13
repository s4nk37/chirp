import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/vaQQ1Vg6hgxb8Os3KfVM/messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: streamSnapshot.data?.docs.length,
              itemBuilder: (ctx, index) => Container(
                padding: const EdgeInsets.all(10),
                child: Text(streamSnapshot.data?.docs[index]['text']),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          FirebaseFirestore.instance
              .collection('chats/vaQQ1Vg6hgxb8Os3KfVM/messages')
              .add({'text': "added"});
        },
      ),
    );
  }
}
