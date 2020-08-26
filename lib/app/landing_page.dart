import 'package:flutter/material.dart';
import 'package:timeTracker/app/home_page.dart';
import 'package:timeTracker/app/sign_in/sign_in_page.dart';
import 'package:timeTracker/services/auth.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;
  LandingPage({
    @required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
        User user = snapshot.data;
        if (user == null) {
          return SignInPage(
            auth: auth,
          );
        }
        return HomePage(
          auth: auth,
        );
      },
    );
  }
}
