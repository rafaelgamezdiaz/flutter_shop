import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// 3- StateNotifierProvider -  se consume desde la UI
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(
      (ref) => LoginFormNotifier(),
    );

// 1- State del provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isFormValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isFormValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  @override
  String toString() {
    return '''

    LoginFormState {
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isFormValid: $isFormValid,
      email: $email,
      password: $password,
    }
    ''';
  }

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isFormValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isFormValid: isFormValid ?? this.isFormValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

// 2- Notifier del provider
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value: value);
    state = state.copyWith(
      email: newEmail,
      isFormValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value: value);
    state = state.copyWith(
      password: newPassword,
      isFormValid: Formz.validate([newPassword, state.email]),
    );
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isFormValid) return;
    print(state);
    // state = state.copyWith(
    //   isFormPosted: true,
    //   isPosting: true,
    // );
  }

  _touchEveryField() {
    final email = Email.dirty(value: state.email.value);
    final password = Password.dirty(value: state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isFormValid: Formz.validate([email, password]),
    );
  }
}
