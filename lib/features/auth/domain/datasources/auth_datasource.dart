import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String username);
  Future<void> logout();
  Future<User> isAuthenticated(String token);
}
