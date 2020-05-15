import 'package:flutter/material.dart';
import 'package:unisa/app/sign_in/Home_page.dart';
import 'package:unisa/app/sign_in/sign_in_page.dart';
import 'package:unisa/app/sign_in/student_login.dart';
import 'package:unisa/services/auth.dart';
import 'package:unisa/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:unisa/app/sign_in/Home_page.dart';
import 'package:unisa/app/sign_in/sign_in_page.dart';
import 'package:unisa/services/auth.dart';
import 'package:unisa/services/unisa_login.dart';


class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Token>(context);
    return StudentLogin();
  }

}