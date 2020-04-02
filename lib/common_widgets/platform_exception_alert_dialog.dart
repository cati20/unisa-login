import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:unisa/common_widgets/platform_alert_dialog.dart';

class PlatformExceptionDialog extends PlatformAlertDialog {
  PlatformExceptionDialog({
    @required String title,
    @required PlatformException exception
  }) :super(
    title: title,
    content: _message(exception),
    defaultActionText: 'OK'
  );
  
  static String _message (PlatformException exception){
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'ERROR_WEAK_PASSWORD' : 'Please enter a strong password',
    'ERROR_INVALID_CREDENTIAL' :'Invalid Credentials',
    'ERROR_EMAIL_ALREADY_IN_USE' : 'the email is already in use by a different account',
    'ERROR_INVALID_EMAIL' : 'Please enter a valid email',
    'ERROR_WRONG_PASSWORD': 'The password is invalid',
    'ERROR_USER_NOT_FOUND' : 'User not found',
    'ERROR_USER_DISABLED' : 'Your account has been disabled',
    'ERROR_TOO_MANY_REQUESTS' : 'Please press Login once'
    ///   • `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };

}