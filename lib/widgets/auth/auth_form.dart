import 'dart:io';
import 'package:flutter/material.dart';
import '../pickers/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File? image, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  const AuthForm({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _toggleVisibility = true;
  bool _isLogin = true;
  bool _isSuccessfullySent = false;

  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImageFile;
  final _userPassResetEmail = TextEditingController();

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  String? _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password field cannot be empty';
    }
    // Use any password length of your choice here
    if (value.length < 7) {
      return 'Password length must be greater than 7';
    }
    return null;
  }

  String? _validateUserName(String value) {
    if (value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  void _trySubmit() {
    var isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && _isLogin == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please pick an image',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  Future<void> _tryResetRequest() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _userPassResetEmail.text.trim())
        .whenComplete(() {
      setState(() {
        _isSuccessfullySent = true;
      });
      _userPassResetEmail.dispose();
    });
  }

  void _showForgotPassModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 35.0, horizontal: 35),
              child: _isSuccessfullySent
                  ? const Text("Email sent successfully.")
                  : Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          key: const ValueKey('forgot-pass-email'),
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey.shade300.withOpacity(0.4)),
                          onChanged: (val) => _validateEmail(val),
                          controller: _userPassResetEmail,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: _tryResetRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent.shade400,
                            minimumSize: const Size(double.infinity, 50),
                            elevation: 0.0,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text(
                            "Send Password Reset Email",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0.0,
        color: Colors.white.withOpacity(0.5),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                    TextFormField(
                      key: const ValueKey('email'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) => _validateEmail(val!),
                      onSaved: (val) => _userEmail = val!,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.text,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (val) => _validateUserName(val!),
                        onSaved: (val) => _userName = val!,
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _toggleVisibility,
                      validator: (val) => _validatePassword(val!),
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
                        ),
                      ),
                      onSaved: (val) => _userPassword = val!,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _trySubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent.shade400,
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 0.0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: widget.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _isLogin ? "Login" : "Signup",
                              style: const TextStyle(color: Colors.white70),
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? "Create a new account"
                          : "Already have an account?"),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _showForgotPassModal();
                        });
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
