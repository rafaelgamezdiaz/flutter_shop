import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// 3- StateNotifierProvider -  se consume desde la UI
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
      final loginUserCallback = ref.watch(authProvider.notifier).login;
      return LoginFormNotifier(loginUserCallback: loginUserCallback);
    });

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
  final Function(String, String) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback})
    : super(LoginFormState());

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

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isFormValid) return;
    state = state.copyWith(isPosting: true);
    await loginUserCallback(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
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
