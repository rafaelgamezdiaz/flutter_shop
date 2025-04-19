import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImplementation();

  return AuthNotifier(authRepository: authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> login(String email, String password) async {
    Future.delayed(const Duration(microseconds: 600));

    // state = state.copyWith(authStatus: AuthStatus.checking);
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error inesperado');
    }
  }

  Future<void> registerUser(
    String email,
    String password,
    String fullName,
  ) async {
    Future.delayed(const Duration(microseconds: 600));

    try {
      final user = await authRepository.register(email, password, fullName);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error inesperado');
    }
  }

  void checkStatus() async {
    // state = state.copyWith(authStatus: AuthStatus.checking);
    // try {
    //   final user = await AuthRepository().isAuthenticated(state.user?.token ?? '');
    //   state = state.copyWith(authStatus: AuthStatus.authenticated, user: user);
    // } catch (e) {
    //   state = state.copyWith(
    //     authStatus: AuthStatus.unauthenticated,
    //     errorMessage: e.toString(),
    //   );
    // }
  }

  Future<void> logout([String? errorMessage]) async {
    // TODO limpiar token

    state = state.copyWith(
      authStatus: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage ?? '',
    );
  }

  void _setLoggedUser(User user) {
    // TODO necesito guardar el token en el local storage
    print('Response: _setLoggedUser*********************************');

    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }
}

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
