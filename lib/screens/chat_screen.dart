import 'package:chirp/widgets/chat/new_message.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/chat/messages.dart';
// import 'package:firebase_core/firebase_core.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.notification}");
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic("chats");
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // print(fbm.isAutoInitEnabled);
    // for sending push notification

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("ONMESSAGEOPENED : $message");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');

      print('Message data: ${message}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title} ${message.notification!.body}');
      }
    });

    super.initState();
  }

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
                // ElevatedButton(
                //     onPressed: sendPushNotification,
                //     child: Text("Send Message")),
                NewMessage(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
