import 'package:chat_app/Widgets/auth_button.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
            TextField(
              onChanged: (value) {
                email = value;
              },
              keyboardType: TextInputType.emailAddress,
              decoration:
                  kInputDecoration.copyWith(hintText: 'Enter your email.'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              obscureText: true,
              decoration:
                  kInputDecoration.copyWith(hintText: 'Enter your password.'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            AuthButton(
              lable: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                try {
                  _auth.createUserWithEmailAndPassword(
                      email: email!, password: password!);
                  context.go('/chat');
                } on Exception catch (e) {
                  Text('$e: Failed to create your account, try later!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
