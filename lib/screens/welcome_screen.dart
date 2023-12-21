import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/Widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation? animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(_animationController);
    // animation = CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.decelerate,
    // );
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation?.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0x88000000),
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [TypewriterAnimatedText('Flash Chat')],
                      repeatForever: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            AuthButton(
              lable: 'Log in',
              colour: Colors.lightBlueAccent,
              onPressed: () => context.go('/login'),
            ),
            AuthButton(
              lable: 'Register',
              colour: Colors.blueAccent,
              onPressed: () => context.go('/register'),
            ),
          ],
        ),
      ),
    );
  }
}
