import 'dart:ui';

import '../widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _submitAuthForm(
      String email, String password, String username, bool isLogin) {}

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
            body: AuthForm(submitFn: _submitAuthForm),
          )
        ],
      ),
    );
    ;
  }
}
