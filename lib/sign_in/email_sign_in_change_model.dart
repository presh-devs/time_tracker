import 'package:flutter/foundation.dart';
import 'package:time_tracker/sign_in/validators.dart';

import '../services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailSignInChangeModel(
      {required this.auth,
      this.email = '',
      this.password = '',
      this.formType = EmailFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final AuthBase auth;
  String email;
  String password;
  EmailFormType? formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (formType == EmailFormType.signIn) {
        await auth.signInWithEmailAndPassword(
          email,
          password,
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          email,
          password,
        );
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailFormType.signIn ? 'Sign in' : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  String? get passwordErrorText {
    bool _showErrorText = submitted && !passwordValidator.isValid(password);
    return _showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool _showErrorText = submitted && !emailValidator.isValid(email);
    return _showErrorText ? invalidEmailErrorText : null;
  }

  bool get canSubmit {
    return emailValidator.isValid(email) && passwordValidator.isValid(password);
  }

  void toggleFormType() {
    final formType = this.formType == EmailFormType.signIn
        ? EmailFormType.register
        : EmailFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String? email,
    String? password,
    EmailFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
