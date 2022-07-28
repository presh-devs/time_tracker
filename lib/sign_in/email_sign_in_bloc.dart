import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final _modelSubjet = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  final AuthBase auth;

  Stream<EmailSignInModel> get modelStream => _modelSubjet.stream;
  EmailSignInModel get _model => _modelSubjet.value;

  void dispose() {
    _modelSubjet.close();
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailFormType.signIn) {
        await auth.signInWithEmailAndPassword(
          _model.email,
          _model.password,
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          _model.email,
          _model.password,
        );
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailFormType.signIn
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
    _modelSubjet.value = _model.copyWith(
        email: email!,
        password: password!,
        formType: formType!,
        isLoading: isLoading!,
        submitted: submitted!
    );
  }
}
