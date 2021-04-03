import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:think_art/Pages/NavBar.dart';
import 'authentication.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  email = prefs.getString('think_art_email');
  if (email == null) email = '';
  runApp(ThinkArt());
}

class ThinkArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 4), () {
      if (email == '') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Authentication()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CircularNavBar()));
      }
    });

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250.0,
          child: FadeAnimatedTextKit(
            onTap: () {
              print("Tap Event");
            },
            text: ["Welcome To!", "ThinkArt!!!"],
            textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
