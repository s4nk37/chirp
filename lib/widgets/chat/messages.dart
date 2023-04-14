import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
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
            itemBuilder: (ctx, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(width: 0.0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  chatDocs[index]['text'],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
