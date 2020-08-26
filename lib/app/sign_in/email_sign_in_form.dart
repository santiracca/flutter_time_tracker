import 'package:flutter/material.dart';

class EmailSignInForm extends StatelessWidget {
  List<Widget> _buildChildren() {
    return [
      TextField(
        decoration:
            InputDecoration(labelText: 'Email', hintText: 'test@test.com'),
      ),
      TextField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
