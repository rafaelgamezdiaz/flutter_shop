import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFomState>(
      (ref) => RegisterFormNotifier(),
    );

class RegisterFomState {
  final FullName fullName;
  final Email email;
  final Password password;
  final String confirmPassword;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  RegisterFomState({
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = '',
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
  });

  @override
  String toString() {
    return '''
    RegisterFomState(
      fullName: $fullName, 
      email: $email, 
      password: $password,
      confirmPassword: $confirmPassword, 
      isPosting: $isPosting, 
      isFormPosted: $isFormPosted, 
      isValid: $isValid 
    )
''';
  }

  RegisterFomState copyWith({
    FullName? fullName,
    Email? email,
    Password? password,
    String? confirmPassword,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) {
    return RegisterFomState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
    );
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFomState> {
  RegisterFormNotifier() : super(RegisterFomState());

  onFullNameChange(String value) {
    final newFullName = FullName.dirty(value: value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([newFullName, state.email, state.password]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value: value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password, state.fullName]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value: value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email, state.fullName]),
    );
  }

  onPasswordConfirmChange(String value) {
    state = state.copyWith(
      confirmPassword: value,
      isValid: (value == state.password.value) && state.isValid,
    );
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
  }

  _touchEveryField() {
    final fullName = FullName.dirty(value: state.fullName.value);
    final email = Email.dirty(value: state.email.value);
    final password = Password.dirty(value: state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}
