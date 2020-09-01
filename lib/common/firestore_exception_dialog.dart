import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeTracker/common/platform_alert_dialog.dart';

class FirebaseExceptionAlertDialog extends PlatformAlertDialog {
  FirebaseExceptionAlertDialog({
    @required String title,
    @required FirebaseException exception,
  }) : super(
            title: title,
            content: _message(exception),
            defaultActionText: 'OK');

  static String _message(FirebaseException exception) {
    if (exception.code == 'permission-denied') {
      return 'You dont have permission to';
    }
    print(exception.message);
    print(_errors[exception.code]);

    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'ERROR_WEAK_PASSWORD': 'The password is weak',
    'PERMISSION_DENIED': 'You dont have permission to',
    'permission-denied': 'You dont have permission to',

    ///   • `ERROR_INVALID_EMAIL` - If the email address is malformed.
    ///   • `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
    ///   • `ERROR_WRONG_PASSWORD` - If the [password] is wrong.
    ///   • `ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
    ///   • `ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
    ///   • `ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
    ///   • `ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
  };
}
