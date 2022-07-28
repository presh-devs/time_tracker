import 'package:time_tracker/sign_in/validators.dart';

enum EmailFormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel(
      {this.email = '',
      this.password = '',
      this.formType = EmailFormType.signIn,
      this.isLoading = false,
      this.submitted = false});
  final String email;
  final String password;
  final EmailFormType? formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText {
    return formType == EmailFormType.signIn ? 'Sign in' : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == EmailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  String? get passwordErrorText {
    bool _showErrorText = submitted && passwordValidator.isValid(password);
    return _showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool _showErrorText = submitted && emailValidator.isValid(email);
    return _showErrorText ? invalidEmailErrorText : null;
  }

  bool get canSubmit {
    return isLoading &&
        emailValidator.isValid(email) &&
        passwordValidator.isValid(password);
  }

  EmailSignInModel copyWith({
    required String? email,
    required String? password,
    required EmailFormType? formType,
    required bool? isLoading,
    required bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
