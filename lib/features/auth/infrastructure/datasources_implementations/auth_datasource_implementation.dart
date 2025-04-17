import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImplementation extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      // connectTimeout: 5000,
      // receiveTimeout: 3000,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  @override
  Future<User> isAuthenticated(String token) {}

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return UserMapper.fromJson(response.data);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> logout() {}

  @override
  Future<User> register(String email, String password, String username) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
