import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, index) => Container(
          padding: const EdgeInsets.all(10),
          child: const Text("Text"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          FirebaseFirestore.instance
              .collection('chats/vaQQ1Vg6hgxb8Os3KfVM/messages')
              .snapshots()
              .listen((data) {
            print(data.docs[0]['text']);
          });
        },
      ),
    );
  }
}
