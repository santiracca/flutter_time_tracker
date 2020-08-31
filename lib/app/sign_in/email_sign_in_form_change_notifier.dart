import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:timeTracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:timeTracker/common/form_submit_button.dart';
import 'package:timeTracker/common/platform_exception_alert_dialog.dart';
import 'package:timeTracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({
    @required this.bloc,
  });
  final EmailSignInChangeModel bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) => EmailSignInFormChangeNotifier(
          bloc: model,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormChangeNotifier> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.bloc;

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    }
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      const SizedBox(height: 8),
      _buildPasswordTextField(),
      const SizedBox(height: 8),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 8),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? () => model.toggleFormType() : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      onChanged: (password) => model.updateWith(password: password),
      obscureText: true,
      autocorrect: false,
      decoration: InputDecoration(
        enabled: model.isLoading ? false : true,
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      onChanged: (email) => model.updateWith(email: email),
      autofocus: true,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(
          model.emailValidator.isValid(model.email)
              ? _passwordFocusNode
              : _emailFocusNode,
        );
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        enabled: model.isLoading ? false : true,
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
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
}
