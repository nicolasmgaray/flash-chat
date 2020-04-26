import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'registration_screen.dart';
import '../components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String route = "/";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: Hero(
                        child: Image.asset('images/logo.png'),
                        tag: "logo",
                      ),
                      height: 60,
                    ),
                    TypewriterAnimatedTextKit(
                      text: ['Flash Chat'],
                      totalRepeatCount: 1,
                      speed: Duration(milliseconds: 200),
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                RoundedButton(
                    background: Colors.lightBlueAccent,
                    label: "Login",
                    onPress: () {
                      Navigator.pushNamed(context, LoginScreen.route);
                    }),
                RoundedButton(
                    background: Colors.blueAccent,
                    label: "Register",
                    onPress: () {
                      Navigator.pushNamed(context, RegistrationScreen.route);
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
