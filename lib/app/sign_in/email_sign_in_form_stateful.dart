import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/app/sign_in/email_sign_in_model.dart';
import 'package:timeTracker/app/sign_in/validators.dart';
import 'package:timeTracker/common/form_submit_button.dart';
import 'package:timeTracker/common/platform_exception_alert_dialog.dart';
import 'package:timeTracker/services/auth.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormStateful> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _hasSubmitted = false;
  bool _isLoading = false;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  String get email => _emailController.text;
  String get password => _passwordController.text;

  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context);
    setState(() {
      _hasSubmitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(title: 'Sign in Failed', exception: e)
          .show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _hasSubmitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(email) &&
        widget.passwordValidator.isValid(password) &&
        !_isLoading;
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 8),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      const SizedBox(height: 8),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        widget.passwordValidator.isValid(password) && _hasSubmitted;
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      onChanged: (password) => _updateState(),
      obscureText: true,
      autocorrect: false,
      decoration: InputDecoration(
          enabled: _isLoading ? false : true,
          labelText: 'Password',
          errorText: showErrorText ? widget.invalidPasswordErrorText : null),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = widget.emailValidator.isValid(email) && _hasSubmitted;
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      onChanged: (email) => _updateState(),
      autofocus: true,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(
          widget.emailValidator.isValid(email)
              ? _passwordFocusNode
              : _emailFocusNode,
        );
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          enabled: _isLoading ? false : true,
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? widget.invalidEmailErrorText : null),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
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

  void _updateState() {
    setState(() {});
  }
}
