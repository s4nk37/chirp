import 'dart:ui';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _toggleVisibility = true;
  bool _toggleButton = true;

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
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
            body: Center(
              child: Card(
                borderOnForeground: false,
                elevation: 0.0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                color: Colors.white.withOpacity(0.5),
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 40),
                    child: Form(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (val) {
                            validateEmail(val!);
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _toggleVisibility,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(_toggleVisibility
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _toggleVisibility = !_toggleVisibility;
                                  });
                                },
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent.shade400,
                            elevation: 0.0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(_toggleButton ? "Login" : "Signup"),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _toggleButton = !_toggleButton;
                            });
                          },
                          child: Text(_toggleButton
                              ? "Create a new account"
                              : "Already have an account?"),
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
