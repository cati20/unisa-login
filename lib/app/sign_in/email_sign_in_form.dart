import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum EmailSignInFormType{signIn, register}

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {


  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passWordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose(){
    _emailController.dispose();
    _passWordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async{
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try{
      final auth = Provider.of<AuthBase>(context);
      if(_formType == EmailSignInFormType.signIn){
        await auth.signInWithEmailAndPassword(_email, _password);
      }else{
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
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
    final newFocus = widget.emailValidator.isValid(_email)
    ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toogleFormType(){
    setState(() {
      _submitted = false;
      _formType = _formType ==EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passWordController.clear();
  }

  List<Widget> _buildChildren (){

    final primaryText = _formType == EmailSignInFormType.signIn ?
        'Sign In' : 'Create an account';
    final secondayText = _formType == EmailSignInFormType.signIn ?
        'Need an account? Register' : 'Have an account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
          widget.passwordValidator.isValid(_password) && !_isLoading;


    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text :primaryText,
        onPressed: submitEnabled? _submit :  null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(secondayText),
        onPressed: !_isLoading ? _toogleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =  _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passWordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrortext : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showEmailTextError = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'email@company.com',
        errorText: showEmailTextError ? widget.invalidEmailErrortext : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  _updateState(){
    setState(() {
    });
  }

}
