import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'email_sign_in_model.dart';
import 'validators.dart';
import '../common_widgets/form_submit_button.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  @override
  State<EmailSignInFormStateful> createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailFormType _formType = EmailFormType.signIn;
  bool _submitted = false;
  bool isLoading = false;

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailFormType.signIn) {
        await auth.signInWithEmailAndPassword(
          _email,
          _password,
        );
        Navigator.of(context).pop();
      } else {
        await auth.createUserWithEmailAndPassword(
          _email,
          _password,
        );
      }
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        exception: e,
        title: 'Sign in failed',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailFormType.signIn
          ? EmailFormType.register
          : EmailFormType.signIn;
      _emailController.clear;
      _passwordController.clear;
    });
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailFormType.signIn ? 'Sign in' : 'Create an account';
    final secondaryText = _formType == EmailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = !isLoading &&
        widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password);

    return [
      _buildEmailTextField(),
      const SizedBox(height: 8.0),
      _buildPasswordTextField(),
      const SizedBox(height: 8.0),
      FormSubmitButton(
        onPressed: submitEnabled ? _submit : null,
        text: primaryText,
      ),
      const SizedBox(height: 8.0),
      TextButton(
        onPressed: !isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool _showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        enabled: isLoading == false,
        labelText: 'Password',
        errorText: _showErrorText ? widget.invalidPasswordErrorText : null,
      ),
      obscureText: true,
      onChanged: (password) => _updateState(),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool _showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        enabled: isLoading == false,
        hintText: 'test@gmail.com',
        labelText: 'Email',
        errorText: _showErrorText ? widget.invalidEmailErrorText : null,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailOnEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }

  void _emailOnEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
