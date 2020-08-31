import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/app/sign_in/email_sign_in_page.dart';
import 'package:timeTracker/app/sign_in/sign_in_bloc.dart';
import 'package:timeTracker/app/sign_in/sign_in_button.dart';
import 'package:timeTracker/app/sign_in/social_sign_in_button.dart';
import 'package:timeTracker/common/platform_exception_alert_dialog.dart';
import 'package:timeTracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({
    @required this.bloc,
  });
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => SignInPage(
          bloc: bloc,
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in Failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
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
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? CircularProgressIndicator()
              : Text(
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
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            color: Color(0xFF334D92),
            text: 'Sign in With Facebook',
            assetName: 'images/facebook-logo.png',
            textColor: Colors.white,
            onPressed: isLoading ? null : () {},
          ),
          const SizedBox(height: 8),
          SignInButton(
            color: Colors.teal[700],
            text: 'Sign in With Email',
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }
}
