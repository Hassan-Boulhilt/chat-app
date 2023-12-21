import 'package:chat_app/Widgets/auth_button.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/utils/validation_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? errorText;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !isValidEmail(value)) {
                      errorText = 'Please enter a valid email';
                      return errorText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Enter you email.',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      errorText = 'Please enter a valid password';
                      return errorText;
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Enter your password.',
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                AuthButton(
                  lable: 'Log in',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                          duration: Duration(milliseconds: 300),
                        ),
                      );
                      try {
                        await _auth.signInWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );
                        if (_auth.currentUser != null) {
                          // ignore: use_build_context_synchronously
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Logged in successfuly'),
                            backgroundColor: Colors.green,
                          ));
                          // ignore: use_build_context_synchronously
                          context.go('/chat');
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-credential') {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wrong password or email'),
                              backgroundColor: Colors.red,
                              // shape: RoundedRectangleBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(20)),
                              // ),
                              behavior: SnackBarBehavior.fixed,
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
