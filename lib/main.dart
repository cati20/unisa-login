import 'package:flutter/material.dart';
import 'package:unisa/app/sign_in/Landing_page.dart';
import 'package:unisa/app/sign_in/student_login.dart';
import 'package:unisa/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:custom_splash/custom_splash.dart';
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

  void main(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top:30),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch ,
            children: <Widget>[
            Image.asset(
              'images/Splash.gif',
              height: 600 ,
              fit: BoxFit.fill,
              width:MediaQuery.of(context).size.width,
              ),
            FlatButton(
              onPressed: (){
                 Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Apps()
            )
        );
              },
               child: Text(
                 'Continue', 
                 style: TextStyle(
                   fontFamily: 'Montserrat'
                    , fontWeight: FontWeight.w600,
                     fontSize: 18,
                     color: Colors.white
                     ),
                 ),
                 color: Colors.teal,
                 )
            ],
        ),
          ),
      )
    );
  }
}


class Apps extends StatelessWidget {
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



