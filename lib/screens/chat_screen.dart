import 'package:chirp/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/images/dark_bgchat.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: SizedBox(
                width: 85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Chirp'),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: FittedBox(
                        child: Image.asset(
                          'assets/icon/bird.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
            body: Column(
              children: const [
                Expanded(
                  child: Messages(),
                ),
                NewMessage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
