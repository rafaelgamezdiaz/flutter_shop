import 'package:teslo_shop/features/shared/shared.dart';

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
class Notifier extends StateNotifier<> {
  Notifier(): super();
  
}

// 3- StateNotifierProvider -  se consume desde la UI
