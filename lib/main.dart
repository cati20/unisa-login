import 'package:flutter/material.dart';
import 'package:unisa/app/sign_in/Landing_page.dart';
import 'package:unisa/app/sign_in/student_login.dart';
import 'package:unisa/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:ui';

import 'package:unisa/services/unisa_login.dart';



void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      title: new Text(
        'Unisa Results App',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Color(0xFF072F62)),
      ),
      seconds: 5,
      navigateAfterSeconds: apps(),
      image: new Image.asset(
          'images/unisa-logo.jpg'),
      backgroundColor: Colors.white38,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      loaderColor: Color(0xFFF9930E),
    );
  }
}


class apps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Token>(
      create: (context) => Token(),
      child: MaterialApp(
        title: 'Exam Results',
        theme: ThemeData(
          primaryColor: Colors.teal,

        ),
        home: StudentLogin(),
      ),
    );
  }
}



