import 'package:flutter/material.dart';
import 'package:timeTracker/app/sign_in/email_sign_in_page.dart';
import 'package:timeTracker/app/sign_in/sign_in_button.dart';
import 'package:timeTracker/app/sign_in/social_sign_in_button.dart';
import 'package:timeTracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({
    @required this.auth,
  });

  final AuthBase auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          fullscreenDialog: true, builder: (context) => EmailSignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 10.0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sign in',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 48),
          SocialSignInButton(
            color: Colors.white,
            text: 'Sign in With Google',
            textColor: Colors.black87,
            assetName: 'images/google-logo.png',
            onPressed: _signInWithGoogle,
          ),
          SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            color: Color(0xFF334D92),
            text: 'Sign in With Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          SignInButton(
            color: Colors.teal[700],
            text: 'Sign in With Email',
            textColor: Colors.white,
            onPressed: () => _signInWithEmail(context),
          ),
          const SizedBox(height: 8),
          Text(
            'or',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SignInButton(
            color: Colors.lime[300],
            text: 'Go Anonymous',
            textColor: Colors.black,
            onPressed: _signInAnonymously,
          ),
        ],
      ),
    );
  }
}
