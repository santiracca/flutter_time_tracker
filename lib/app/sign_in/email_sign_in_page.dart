import 'package:flutter/material.dart';
import 'package:timeTracker/app/sign_in/email_sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 10.0,
      ),
      body: Card(
        child: EmailSignInForm(),
      ),
    );
  }
}
