import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  const AuthForm({Key? key, required this.submitFn, required this.isLoading})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _toggleVisibility = true;
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter valid email';
    } else {
      return null;
    }
  }

  _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password field cannot be empty';
    }
    // Use any password length of your choice here
    if (value.length < 7) {
      return 'Password length must be greater than 7';
    }
  }

  _validateUserName(String value) {
    if (value.isEmpty) {
      return 'Username cannot be empty';
    }
  }

  void _trySubmit() {
    var isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        borderOnForeground: false,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        color: Colors.white.withOpacity(0.5),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: const ValueKey('email'),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) => _validateEmail(val!),
                      onSaved: (val) => _userEmail = val!,
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('username'),
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
                        elevation: 0.0,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: widget.isLoading
                          ? const CircularProgressIndicator()
                          : Text(_isLogin ? "Login" : "Signup"),
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
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
