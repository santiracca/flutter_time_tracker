import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timeTracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:timeTracker/app/sign_in/email_sign_in_model.dart';
import 'package:timeTracker/common/form_submit_button.dart';
import 'package:timeTracker/common/platform_exception_alert_dialog.dart';
import 'package:timeTracker/services/auth.dart';

class EmailSignInFormBloc extends StatefulWidget {
  EmailSignInFormBloc({
    @required this.bloc,
  });
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBloc(
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInFormBloc> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

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

  void _toggleFormType(EmailSignInModel model) {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      const SizedBox(height: 8),
      _buildPasswordTextField(model),
      const SizedBox(height: 8),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      const SizedBox(height: 8),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? () => _toggleFormType(model) : null,
      )
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      onChanged: (password) => widget.bloc.updatePassword,
      obscureText: true,
      autocorrect: false,
      decoration: InputDecoration(
        enabled: model.isLoading ? false : true,
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      onChanged: (email) => widget.bloc.updateEmail,
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
      child: StreamBuilder<EmailSignInModel>(
          stream: widget.bloc.modelStream,
          initialData: EmailSignInModel(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(snapshot.data),
            );
          }),
    );
  }
}
