import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/sign_in/sign_inButton.dart';
import 'package:time_tracker/sign_in/sign_in_manager.dart';
import 'package:time_tracker/sign_in/social_sign_in_button.dart';
import '../common_widgets/show_exception_alert_dialog.dart';
import '../services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manager, required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Tracker'),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50.0, child: _buildHeader()),
          const SizedBox(
            height: 48,
          ),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            color: Colors.white,
            textColor: Colors.black,
          ),
          const SizedBox(
            height: 8,
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with FaceBook',
            onPressed: isLoading ? null : () => _signInWithFacebook(context),
            color: const Color(0xFF334D92),
            textColor: Colors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Sign in with email',
            onPressed: isLoading ? null : () => _signInWithEmail(context),
            color: Colors.teal[700],
            textColor: Colors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'or',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          SignInButton(
            text: 'Go anonymous',
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            color: Colors.lime,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const Text(
      'Sign In',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 48.0,
      ),
    );
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
