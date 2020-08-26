import 'package:flutter/material.dart';
import 'package:timeTracker/services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;
  HomePage({
    @required this.auth,
  });

  Future<void> _signout() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          FlatButton(
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _signout,
          )
        ],
      ),
    );
  }
}
