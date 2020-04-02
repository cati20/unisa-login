import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unisa/app/sign_in/Home_page.dart';
import 'package:unisa/app/sign_in/validators.dart';
import 'package:unisa/common_widgets/form_submit_button.dart';
import 'package:unisa/common_widgets/platform_alert_dialog.dart';
import 'package:unisa/common_widgets/platform_exception_alert_dialog.dart';
import 'package:unisa/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:unisa/app/sign_in/validators.dart';
import 'package:unisa/common_widgets/form_submit_button.dart';
import 'package:unisa/common_widgets/platform_exception_alert_dialog.dart';
import 'package:unisa/services/auth.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;
import 'package:unisa/services/unisa_login.dart';



class StudentLogin extends StatefulWidget with EmailAndPasswordValidators {


  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _username => _usernameController.text;
  String get _password => _passWordController.text;

  bool _submitted = false;
  bool _isLoading = false;
  String all_access;

  @override
  void dispose(){
    _usernameController.dispose();
    _passWordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async{

  final token = Provider.of<Token>(context);
    //await token.myUnisa(_username, _password);
   // print(token.cookie);
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try{

      await token.myUnisa(_username, _password);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          )
      );

      if(token.error != null){
        PlatformAlertDialog(
          title: 'Login error',
          content: token.error,
          defaultActionText: 'Cancel',
          cancelActionText: 'Ok',
        );
      }



      //Navigator.of(context).pop();
    }on PlatformException catch(e){
      PlatformExceptionDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }finally{
      setState(() {
        _isLoading = false;
      });
    }

  }

  void _emailEditingComplete(){
    final newFocus = widget.emailValidator.isValid(_username)
        ? _passwordFocusNode : _usernameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }


  _updateState(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showEmailTextError = _submitted &&
        !widget.emailValidator.isValid(_username);
    bool showErrorText = _submitted &&
        !widget.passwordValidator.isValid(_password);

    bool submitEnabled = widget.emailValidator.isValid(_username) &&
        widget.passwordValidator.isValid(_password) && (!_isLoading);

    bool showpass = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Details', style: TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
        centerTitle: true,


      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                focusNode: _usernameFocusNode,
                decoration: InputDecoration(
                  labelText: 'Student No',
                  hintText: '56201265',
                  errorText: showEmailTextError
                      ? widget.invalidEmailErrortext
                      : null,
                    enabled: _isLoading == false ? true : false,
                    prefixIcon: Icon(Icons.account_circle, color: Colors.pink,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    focusColor: Colors.lightGreen
                ),
                maxLength: 8,
                autocorrect: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (email) => _updateState(),
                onEditingComplete: _emailEditingComplete,
                enabled: _isLoading ? false : true,
              ),
              SizedBox(height: 8.0,),
              TextField(
                controller: _passWordController,
                focusNode: _passwordFocusNode,
                decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: showErrorText
                        ? widget.invalidPasswordErrortext
                        : null,
                    enabled: _isLoading == false ? true : false,
                    prefixIcon: Icon(Icons.vpn_key, color: Colors.pink,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    focusColor: Colors.lightGreen
                ),
                maxLength: 8,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onChanged: (password) => _updateState(),
                onEditingComplete: _emailEditingComplete,
                enabled: _isLoading ? false : true,

              ),

              RaisedButton(
                child: Text("Myunisa Login", style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, fontWeight: FontWeight.w600),),
                color: Colors.teal,
                onPressed: () => _isLoading ? null : _submit(context),
              )

            ],
          ),
        ),
      ),

      backgroundColor: Colors.grey[200],
    );
  }


}

