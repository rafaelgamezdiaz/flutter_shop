import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthRepositoryImplementation extends AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepositoryImplementation({AuthDatasource? authDatasource})
    : authDatasource = authDatasource ?? AuthDatasourceImplementation();

  @override
  Future<User> isAuthenticated(String token) {
    return authDatasource.isAuthenticated(token);
  }

  @override
  Future<User> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  // @override
  // Future<void> logout() {
  //   return authDatasource.logout();
  // }

  @override
  Future<User> register(String email, String password, String fullName) {
    return authDatasource.register(email, password, fullName);
  }
}
