import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/app/home_page.dart';
import 'package:timeTracker/app/sign_in/sign_in_page.dart';
import 'package:timeTracker/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
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
          return SignInPage.create(context);
        }
        return HomePage();
      },
    );
  }
}
