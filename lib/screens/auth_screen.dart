import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File? image, bool isLogin, BuildContext ctx) async {
    final UserCredential authResult;

    try {
      if (isLogin) {
        setState(() {
          _isLoading = true;
        });

        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${authResult.user!.uid}.jpg');

        await ref.putFile(image!);

        final imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'image_url': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = "An error occurred, please check your credentials";
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          const Positioned(
            bottom: 400,
            child: CircleAvatar(
              backgroundColor: Color(0xffC96CF6),
              radius: 400,
            ),
          ),
          const Positioned(
            top: 600,
            left: 100,
            child: CircleAvatar(
              backgroundColor: Color(0xff6966F1),
              radius: 200,
            ),
          ),
          const Positioned(
            top: 300,
            right: 200,
            child: CircleAvatar(
              backgroundColor: Color(0xff88EAF3),
              radius: 300,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 70, sigmaX: 70),
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/noise.png',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: AuthForm(submitFn: _submitAuthForm, isLoading: _isLoading),
          )
        ],
      ),
    );
    ;
  }
}
