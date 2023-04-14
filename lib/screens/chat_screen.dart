import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chirp'),
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: const Icon(
                  Icons.menu_sharp,
                  color: Colors.white,
                ),
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(
                          Icons.logout,
                          color: Colors.indigo,
                        ),
                        Text("Log out"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
